clear all; 
close all;

scene = 'rabbit';
lambda = 1;

nlos = loaddata(scene);
[pos, dir] = dlct(nlos,lambda, 4, [1,1,1], [1,1,1]);

% img = dir(:,:,3) - min(reshape(dir(:,:,3),[],1));

% posc = pos(33:end-32,:,:);
% dirc = dir(33:end-32,:,:);
% indc = dirc(:,:,3)>2e-5;

% se = strel('disk',16);
% indc = imclose(indc,se);
% dlctsurf(posc,dirc,indc);