clear all;

load('./dlcterror.mat');
load('~/Developer/cvpr2019_nlos/debugger/bunny/bunny_depth.mat','bunny_depth','bunny_mask');

mask = imresize(bunny_mask,size(pos),'nearest');
depth = imresize(bunny_depth,size(pos));
mad = sum(abs(pos(:) - depth(:)) .* mask(:))/sum(mask(:));
mse = sum((pos(:) - depth(:)).^2 .* mask(:))/sum(mask(:));
figure;
vis(abs(pos-depth).*mask);
axis([41,214,41,214]);
caxis([0,0.01]);
colormap(hot);