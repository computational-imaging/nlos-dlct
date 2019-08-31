clear all; 
close all;

file = '../zaragoza/bunny_l[0.00,-0.50,0.00]_r[1.57,0.00,3.14]_v[0.80,0.53,0.81]_s[256]_l[256]_gs[1.00]_conf.hdf5';
nlos = NLOSData(file,'bounces',2,'shifttime',true);
nlos.Data = nlos.Data(:,:,1:1024);

hdim = size(nlos.Data);
ldim = [128,128,512];
meas = imresize(nlos.Data, ldim(1:2));
% meas = max(0,meas).*(1/max(meas(:)));

isdiffuse = 1; % Toggle diffuse reflection (LCT only)
width = nlos.CameraGridSize / 2;

N = size(meas,1);
M = size(meas,3);

range = nlos.DeltaT*hdim(3); % Maximum range for histogram
slope = width / range;

% Permute data dimensions
data = permute(meas,[3 2 1]);

% Define volume representing voxel distance from wall
grid_z = linspace(0,1,M)';
data = data.*(linspace(0,1,M)'.^2);

% Multiply by the normalization factor
%data = data.*grid_z;

mu = 1;
[Hx,Hy,Hz] = constructH3(N,M,slope,mu);
R = constructR(M);
lambda = 1;

b = reshape(R*reshape(data,M,[]),[M,N,N]);
u = blockwiener(b, Hx, Hy, Hz, lambda);
u = reshape(R'*u(:,:),[M,N,N,3]);
u = permute(u,[3,2,1,4]);

% tic_z = linspace(0,range./2,size(v,1));
% tic_y = linspace(-width,width,size(v,2));
% tic_x = linspace(-width,width,size(v,3));

[~,Z] = max(sqrt(sum(u.^2,4)),[],3);
[X,Y] = ndgrid(1:size(u,1),1:size(u,2));

ind = sub2ind([N,N,M],X,Y,Z);

Nx = fliplr(flipud(u(ind + 0*N*N*M)'));
Ny = fliplr(flipud(u(ind + 1*N*N*M)'));
Nz = fliplr(flipud(u(ind + 2*N*N*M)'));

