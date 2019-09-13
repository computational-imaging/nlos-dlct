clear all; 
close all;

scene = 'bunny';
lambda = 4;

nlos = loaddata(scene);
[pos, dir] = dlct(nlos,lambda);

dlctsurf(pos,dir);