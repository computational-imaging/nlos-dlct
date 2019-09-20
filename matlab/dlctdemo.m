clear all; 
close all;

scene = 'serapis';
lambda = 4;

nlos = loaddata(scene);
[pos, dir] = dlct(nlos,lambda);

img = dir(:,:,3) - min(reshape(dir(:,:,3),[],1));
thresh = 0.1*max(img(:));
vis(shrinkage(fliplr(flipud(img')),thresh,0));
a = caxis;
caxis([-a(2),+a(2)]);
colormap(gray)

%dlctsurf(pos,dir);