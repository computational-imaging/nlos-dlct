clear all; 
close all;

scene = 'dragon';
execpath = '~/Developer/PoissonRecon/Bin/Linux/';
tempfile = 'temp.ply';
surffile = 'surf.ply';

nlos = loaddata(scene);

tic;
hdim = size(nlos.Data);
ldim = [128,128,256];
data = imresize3(nlos.Data, ldim);
data = paddata(data,[64,64,0]);

width = nlos.CameraGridSize / 2;
range = nlos.DeltaT * hdim(3); % Maximum range for histogram
slope = width / range;

% Permute data dimensions
data = permute(data,[3 2 1]);

% Define volume representing voxel distance from wall
N = size(data,3);
M = size(data,1);
data = data.*(linspace(0,1,M)'.^2);

% Multiply by the normalization factor
% grid_z = linspace(0,1,M)';
% data = data.*grid_z;
mu = 1;
[Hx,Hy,Hz] = constructH3(N,M,slope,mu);
R = constructR(M);
lambda = 10;

b = reshape(R*reshape(data,M,[]),[M,N,N]);
u = blockwiener(b, Hx, Hy, Hz, lambda);
u = u(1:M,1:N,1:N,:);
u = reshape(R'*u(:,:),[M,N,N,3]);
u = permute(u,[2,3,1,4]);
u = flip(flip(u,1),2);

% pseudo-3D impression
[~,z] = max(sqrt(sum(u.^2,4)),[],3);
[x,y] = ndgrid(1:size(u,1),1:size(u,2));

ind = sub2ind([N,N,M],x,y,z);
n_x = u(ind + 0*N*N*M);
n_y = u(ind + 1*N*N*M);
n_z = u(ind + 2*N*N*M);

x = (1.0*hdim(1)/ldim(1))*x;
y = (1.0*hdim(2)/ldim(2))*y;
z = (0.5*hdim(3)/ldim(3))*z;
img = n_x + n_y + n_z./z;

% proper 3D reconstruction
mag = sqrt(n_x.^2 + n_y.^2 + (n_z./z).^2);
dir = cat(3,n_y,n_x,n_z./z);
pos = cat(3,x,y,z);

% export to a PLY file
ind = find(mag > 3e-5);
dir = reshape(dir,[],3);
pos = reshape(pos,[],3) - 0.5*ldim;
plyWrite(tempfile,pos(ind,:).*[1,1,-1],dir(ind,:).*[1,1,2/slope]);
toc;

% visualize surface 
q(sprintf('%s --in %s --out %s --degree 2 --bType 2 --pointWeight 1 --ascii', ...
          fullfile(execpath,'PoissonRecon'), tempfile, surffile));
[V,F,N] = plyRead(surffile,1);
plySurf(V,F);
