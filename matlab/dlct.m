% DLCT Filter transients using the D-LCT to find directional albedo.
%
%   [POS, DIR, VOL] = DLCT(NLOS, LAMBDA, GAMMA, SIGMA, MU) runs the
%   D-LCT on transient object NLOS with smoothness LAMBDA, fall-off
%   GAMMA, down-sampling factors SIGMA and extension factors MU and
%   returns voxel positions POS and directional albedos DIR, at the
%   positions of maximum intensities along the z direction. VOL are
%   the full 3D volumes of directional albedo components.
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

function [pos, dir, vol] = dlct(nlos, lambda, gamma, sigma, mu)

if nargin < 3
    gamma = 4;
end
if nargin < 4
    sigma = [1,1,1];
end
if nargin < 5
    mu = [2,2,2];
end

hdim = size(nlos.Data);
ldim = hdim./sigma;
tau = imresize3(nlos.Data, ldim);

width = nlos.CameraGridSize / 2;
range = nlos.DeltaT * hdim(3); % Maximum range for histogram
                               % slope = width / range;

% Permute tau dimensions
tau = permute(tau,[3 2 1]);

% Define volume representing voxel distance from wall
N = size(tau,3);
M = size(tau,1);
tau = tau.*linspace(0,range,M)'.^gamma;

[Hx,Hy,Hz] = constructH(N,M,width,range,mu);
[Rx,Ry,Rz] = constructR(M,range);

b = reshape(Rx*reshape(tau,M,[]),[M,N,N]);
u = blockwiener(b, Hx, Hy, Hz, lambda);

u = u(1:M,1:N,1:N,:);
u(:,:,:,1) = reshape(Rx'*reshape(u(:,:,:,1),[M,N^2]),[M,N,N]);
u(:,:,:,2) = reshape(Ry'*reshape(u(:,:,:,2),[M,N^2]),[M,N,N]);
u(:,:,:,3) = reshape(Rz'*reshape(u(:,:,:,3),[M,N^2]),[M,N,N]);
u(:,:,:,3) = max(0,u(:,:,:,3));

% pseudo-3D impression
[~,Z] = max(u(:,:,:,3),[],1);
[~,R,C] = ndgrid(1,1:N,1:N);

ind = sub2ind([M,N,N],Z,R,C);
n_x = u(ind + 0*M*N*N);
n_y = u(ind + 1*M*N*N);
n_z = u(ind + 2*M*N*N);
% n_z = max(0,n_z);

x = width - (width*2/N)*C;
y = width - (width*2/N)*R;
z = (range/2/M)*(Z-1);

pos = fliplr(flipud(squeeze(cat(4,x,y,z))));
dir = fliplr(flipud(squeeze(cat(4,n_x,n_y,n_z))));
vol = fliplr(flipud(permute(u,[2,3,1,4])));
