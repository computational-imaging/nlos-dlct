% CONSTRUCTH Construct D-LCT (directional LCT) filter kernels
%
%   [HX, HY, HZ] = CONSTRUCTH(N, M, WIDTH, RANGE, MU) constructs the
%   directional LCT filter kernels HX, HY and HZ of size MxNxN, with
%   spatial width WIDTH and, depth RANGE (in meters), and extension
%   factor MU.
%
%   Authors:     Sean I. Young      David B. Lindell
%   Contacts: sean0@stanford.edu, lindell@stanford.edu
%
% Copyright 2019-2020 Stanford University, Stanford CA 94305, USA
%
%                         All Rights Reserved
%
% Permission to use, copy, modify, and distribute this software and
% its documentation for any purpose other than its incorporation into
% a commercial product is hereby granted without fee, provided that
% the above copyright notice appear in all copies and that both that
% copyright notice and this permission notice appear in supporting
% documentation, and that the name of Stanford University not be used
% in advertising or publicity pertaining to distribution of the
% software without specific, written prior permission.
%
% STANFORD UNIVERSITY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
% SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR ANY PARTICULAR PURPOSE. IN NO EVENT SHALL STANFORD
% UNIVERSITY BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
% DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
% OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
% TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
% PERFORMANCE OF THIS SOFTWARE.

function [Hx,Hy,Hz] = constructH(N,M,width,range,mu)
    % Local function to compute NLOS blur kernel
    x = linspace(-mu(1)*width,+mu(1)*width,mu(1)*N);
    y = linspace(-mu(2)*width,+mu(2)*width,mu(2)*N);
    z = linspace(0,mu(3)*range*range,mu(3)*M);
    [grid_z,grid_y,grid_x] = ndgrid(z,y,x);

    % Define PSF (scale grid_x, grid_y, grid_z to the actual range)
    h = abs(4*(grid_x.^2 + grid_y.^2) - grid_z);
    % We need a Gaussian blur here (currently does nearest neighbor)
    h = single(h == repmat(min(h,[],1),[length(z) 1 1]));
    h = h./norm(h(:));
    
    hx =-h.*grid_x;
    hx = circshift(hx,0.5*[0 length(y) length(x)]);
    Hx = fftn(hx,size(hx));
    
    hy =-h.*grid_y;
    hy = circshift(hy,0.5*[0 length(y) length(x)]);
    Hy = fftn(hy,size(hy));

    hz = h;
    hz = circshift(hz,0.5*[0 length(y) length(x)]);
    Hz = fftn(hz,size(hz));
end