function [pos, dir, time, snorm, rnorm] = dlct(nlos, lambda, gamma, sigma, mu, pad)
tic;

if nargin < 3
    gamma = 4;
end
if nargin < 4
    sigma = [1,1,1];
end
if nargin < 5
    mu = [2,2,2];
end
if nargin < 6
    pad = [0,0,0];
end

hdim = size(nlos.Data);
ldim = hdim./sigma;
tau = imresize3(nlos.Data, ldim);
tau = paddata(tau,pad);

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

% if nargout >= 4
%     snorm = norm(u(:));
% end
% if nargout >= 5
%     t = blockconv3d(u, Hx, Hy, Hz);
%     rnorm = norm(t(:) - b(:));
% end

u = u(1:M,1:N,1:N,:);
u(:,:,:,1) = reshape(Rx'*reshape(u(:,:,:,1),[M,N^2]),[M,N,N]);
u(:,:,:,2) = reshape(Ry'*reshape(u(:,:,:,2),[M,N^2]),[M,N,N]);
u(:,:,:,3) = reshape(Rz'*reshape(u(:,:,:,3),[M,N^2]),[M,N,N]);


% pseudo-3D impression
[~,Z] = max(u(:,:,:,3),[],1);
[~,R,C] = ndgrid(1,1:N,1:N);

ind = sub2ind([M,N,N],Z,R,C);
n_x = u(ind + 0*M*N*N);
n_y = u(ind + 1*M*N*N);
n_z = u(ind + 2*M*N*N);
n_z = max(0,n_z);

x = width - (width*2/N)*C;
y = width - (width*2/N)*R;
z = (range/2/M)*(Z-1);

pos = fliplr(flipud(squeeze(cat(4,x,y,z))));
dir = fliplr(flipud(squeeze(cat(4,n_x,n_y,n_z))));
time = toc;