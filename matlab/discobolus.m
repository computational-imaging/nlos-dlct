clear all;
close all;

load output_statue_dlct2;
dir = dirarray(:,:,:,1,18);
pos = posarray(:,:,:,1,18);

grid = linspace(-1,+1,256);

mask = sqrt(sum(dir.^2,3))>24 & pos<1.3;
se = strel('disk',0);
mask = imclose(mask,se);
[X,Y] = meshgrid(grid);
pos = cat(3,X,Y,pos);

vis(mask.*dir(:,:,3));
