% DLCTDEMO Run the D-LCT demo script for NLOS surface reconstruction.
%
%   DLCTDEMO runs the demo script for NLOS surface reconstruction
%   based on the D-LCT (Directional Light-cone Transform).
%
%   Authors:     Sean I. Young      David B. Lindell
%   Contacts: sean0@stanford.edu, lindell@stanford.edu
%
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
% FITNESS FOR ANY PARTICULAR PURPOSE.  IN NO EVENT SHALL STANFORD
% UNIVERSITY BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
% DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
% OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
% TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
% PERFORMANCE OF THIS SOFTWARE.

clear all; 
close all;

scene = 'rabbit'; % choose from 'rabbit', 'serapis', 'statue',' dragon'
lambda = 0.5; % trade-off between fidelity and smoothness terms.
                  % the paper uses lambda = 1.
gamma  = 4.00000; % radiometric fall-off.
sigmas = [2,2,2]; % downsample the transients by factors [sx,sy,st].
                  % the paper uses sigmas = [1,1,1].

nlos = loaddata(scene);
[pos, dir] = dlct(nlos,lambda, gamma, sigmas);
dims = size(dir);


if ~isnan(nlos.Depth) % use groundtruth mask
    ind = imresize(~isinf(flipud(nlos.Depth)'),dims(1:2));
else % create our own mask by e.g. thresholding
    ind = dir(:,:,3) > 0.20*max(reshape(dir(:,:,3),[],1));
end

% render directional-albedo
figure(1);
dlctplot(dir);

% render surface reconstruction
figure(2);
dlctsurf(pos,dir,ind,4,6);