clear all; 
close all;

% spheres: 2^1

alg = 'dlct';
scene = 'rabbit';
snr = Inf;

load(sprintf('errors_%s_%f_%s.mat',scene,snr,alg));
load(sprintf('output_%s_%f_%s.mat',scene,snr,alg));

lambda = 2;

nlos = loaddata(scene);
%[pos, dir] = dlct(nlos,lambda, 3, [1,1,1], [1,1,1],[48,48,48]);




% img = dir(:,:,3) - min(reshape(dir(:,:,3),[],1));

posc = posarray(:,:,:,1,10);
dirc = dirarray(:,:,:,1,10);
indc = ~isinf(flipud(nlos.Depth)');

% se = strel('disk',0);
% indc = imclose(indc,se);
 dlctsurf(posc,dirc,indc,4,6);