clear all; 
close all;

load('statue/meas_10min.mat');
load('statue/tof.mat');

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

mu = 2;
[Hx,Hy,Hz] = constructH3(N,M,slope,mu);
[Rx,Ry,Rz] = constructR3(M);
lambda = 2;

b = reshape(Rx*reshape(data,M,[]),[M,N,N]);
b = fftn(b,mu*[M,N,N]);

u = blockwiener(b, Hx, Hy, Hz, lambda);
for i=1:3
    u(:,:,:,i) = real(ifftn(u(:,:,:,i)));
end

v = zeros(M,N,N,3);
v(1:M,1:N,1:N,1) = reshape(Rx'*reshape(u(1:M,1:N,1:N,1),M,[]),[M,N,N]);
v(1:M,1:N,1:N,2) = reshape(Ry'*reshape(u(1:M,1:N,1:N,2),M,[]),[M,N,N]);
v(1:M,1:N,1:N,3) = reshape(Rz'*reshape(u(1:M,1:N,1:N,3),M,[]),[M,N,N]);

vol = v(:,:,:,3);

tic_z = linspace(0,range./2,size(vol,1));
tic_y = linspace(width,-width,size(vol,2));
tic_x = linspace(width,-width,size(vol,3));

% clip artifacts at boundary, rearrange for visualization
vol(end-10:end, :, :) = 0;
vol = permute(vol, [1, 3, 2]);
% result = permute(vol, [2, 3, 1]);
vol = flip(vol, 2);
vol = flip(vol, 3);

% View result
figure

subplot(1,3,1);
imagesc(tic_x,tic_y,squeeze(max(vol,[],1)));
title('Front view');
set(gca,'XTick',linspace(min(tic_x),max(tic_x),3));
set(gca,'YTick',linspace(min(tic_y),max(tic_y),3));
xlabel('x (m)');
ylabel('y (m)');
colormap('gray');
axis square;

subplot(1,3,2);
imagesc(tic_x,tic_z,squeeze(max(vol,[],2)));
title('Top view');
set(gca,'XTick',linspace(min(tic_x),max(tic_x),3));
set(gca,'YTick',linspace(min(tic_z),max(tic_z),3));
xlabel('x (m)');
ylabel('z (m)');
colormap('gray');
axis square;

subplot(1,3,3);
imagesc(tic_z,tic_y,squeeze(max(vol,[],3))')
title('Side view');
set(gca,'XTick',linspace(min(tic_z),max(tic_z),3));
set(gca,'YTick',linspace(min(tic_y),max(tic_y),3));
xlabel('z (m)');
ylabel('y (m)');
colormap('gray');
axis square;

drawnow;
