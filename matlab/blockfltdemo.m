clear all; 
close all;

load('../dragon/meas_10min.mat');
load('../dragon/tof.mat');

% resize to low resolution to reduce memory requirements
sz = 128;
meas = imresize3(meas, [sz, sz, 2048]); % y, x, t
tofgrid = imresize(tofgrid, [sz, sz]); 

isdiffuse  = 1;          % Toggle diffuse reflection (LCT only)
bin_resolution = 32e-12; % Native bin resolution for SPAD is 4 ps
c = 3e8;                 % Speed of light (meters per second)
wall_size = 2;           % scanned area is 2 m x 2 m
width = wall_size / 2;
depth = 512;

meas = compensate_time(meas,tofgrid/(bin_resolution*1e12));
meas = meas(:, :, 1:depth);

N = size(meas,1);
M = size(meas,3);

range = M.*c.*bin_resolution; % Maximum range for histogram
slope = width/range;

% Permute data dimensions
data = permute(meas,[3 2 1]);

% Define volume representing voxel distance from wall
grid_z = repmat(linspace(0,1,M)',[1 N N]);
if (isdiffuse)
    data = data.*(grid_z.^2);
else
    data = data.*(grid_z.^2);
end

% Multiply by the normalization factor
%data = data.*grid_z;

mu = 1;
[Hx,Hy,Hz] = constructH3(N,M,slope,mu);
[Rx,Ry,Rz] = constructR3(M);
lambda = 2;

b = reshape(Rx*reshape(data,M,[]),[M,N,N]);

u = blockwiener(b, Hx, Hy, Hz, lambda);

v = zeros(M,N,N,3);
v(1:M,1:N,1:N,1) = reshape(Rx'*reshape(u(1:M,1:N,1:N,1),M,[]),[M,N,N]);
v(1:M,1:N,1:N,2) = reshape(Ry'*reshape(u(1:M,1:N,1:N,2),M,[]),[M,N,N]);
v(1:M,1:N,1:N,3) = reshape(Rz'*reshape(u(1:M,1:N,1:N,3),M,[]),[M,N,N]);

vol = v(:,:,:,3);

tic_z = linspace(0,range./2,size(vol,1));
tic_y = linspace(-width,width,size(vol,2));
tic_x = linspace(-width,width,size(vol,3));

% View result
% figure
% [Z,Y,X] = ndgrid(tic_z,tic_y,tic_x);
% quiver3(Z(1:2:end,1:2:end,1:2:end),...
%         Y(1:2:end,1:2:end,1:2:end),...
%         X(1:2:end,1:2:end,1:2:end),...
%         v(1:2:end,1:2:end,1:2:end,3),...
%         0*v(1:2:end,1:2:end,1:2:end,2),...
%         0*v(1:2:end,1:2:end,1:2:end,1));



nz = squeeze(max(v(:,:,:,3),[],1))';
nz = nz./max(nz(:));
imwrite(nz, 'nz.png')

ny = squeeze(max(v(:,:,:,2),[],1))';
ny = ny./max(ny(:));
imwrite(ny, 'ny.png')

nx = squeeze(max(v(:,:,:,1),[],1))';
nx = nx./max(nx(:));
imwrite(nx, 'nx.png')


% subplot(1,3,1);
% imagesc(tic_x,tic_y,squeeze(max(v(:,:,:,1),[],1))');
% title('Front view');
% xticks([-width,0,+width]);
% yticks([-width,0,+width]);
% xlabel('$x$ (m)');
% ylabel('$y$ (m)');
% colormap('gray');
% axis square;

% subplot(1,3,2);
% imagesc(tic_z,tic_y,squeeze(max(v(:,:,:,3),[],2))');
% title('Side view');
% xticks([0,range/4,range/2]);
% yticks([-width,0,+width]);
% xlabel('$z$ (m)');
% ylabel('$y$ (m)');
% colormap('gray');
% axis square;

% subplot(1,3,3);
% imagesc(tic_x,tic_z,squeeze(max(v(:,:,:,3),[],3)))
% title('Top view');
% xticks([-width,0,+width]);
% yticks([0,range/4,range/2]);
% xlabel('$x$ (m)');
% ylabel('$z$ (m)');
% colormap('gray');
% axis square;



drawnow;
