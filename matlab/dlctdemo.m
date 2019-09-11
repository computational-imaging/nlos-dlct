clear all; 
close all;

scene = 'bunny';
execpath = '~/Developer/PoissonRecon/Bin/Linux/';
tempfile = 'temp.ply';
surffile = 'surf.ply';

nlos = loaddata(scene);

tic;
hdim = size(nlos.Data);
ldim = [256,256,512];
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
data = data.*linspace(0,1,M)'.^2;

mu = 1;
[Hx,Hy,Hz] = constructH3(N,M,width,range);
R = constructR(M);
lambda = 10;

b = reshape(R*reshape(data,M,[]),[M,N,N]);
u = blockwiener(b, Hx, Hy, Hz, lambda);
u = u(1:M,1:N,1:N,:);
u = reshape(R'*u(:,:),[M,N,N,3]);
u = permute(u,[2,3,1,4]);
u = flip(flip(u,1),2);

% pseudo-3D impression
[~,Z] = max(sqrt(sum(u.^2,4)),[],3);
[X,Y] = ndgrid(1:size(u,1),1:size(u,2));

ind = sub2ind([N,N,M],X,Y,Z);
n_x = u(ind + 0*N*N*M);
n_y = u(ind + 1*N*N*M);
n_z = u(ind + 2*N*N*M);

x = (2.0*width/(N-1))*(X-1) - width;
y = (2.0*width/(N-1))*(Y-1) - width;
z = (0.5*range/(M-1))*(Z-1);

% proper 3D reconstruction
n_z = max(0,n_z);
mag = sqrt(n_x.^2 + n_y.^2 + n_z.^2);
dir = cat(3,n_y,n_x,n_z);
pos = cat(3,x,y,z);

% export to a PLY file
ind = find(mag > 5e-5);
dir = reshape(dir,[],3);
pos = reshape(pos,[],3) - 0.5*ldim;
% plyWrite(tempfile,pos(ind,:).*[1,1,-1],dir(ind,:).*[1,1,2/slope]);
plyWrite(tempfile,pos(ind,:).*[1,1,-1],dir(ind,:));
toc;

% visualize surface 
q(sprintf('%s --in %s --out %s --degree 2 --bType 2 --pointWeight 1 --ascii', ...
          fullfile(execpath,'PoissonRecon'), tempfile, surffile));
[V,F] = plyRead(surffile,1);
plySurf(V,F);
