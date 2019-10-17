clear all; 
close all;

filepath = '~/Developer/cvpr2019_nlos/zaragoza/';
filename = 'bunny_l[0.00,-0.50,0.00]_r[1.57,0.00,3.14]_v[0.80,0.53,0.81]_s[256]_l[256]_gs[1.00]_conf_rec.hdf5';

vol = h5read(fullfile(filepath,filename),...
             '/position{0.00,-0.50,0.00}/size{1.00,1.00,1.00}/ground-truth/voxel-resolution{256,256,256}/voxelVolume');

vol = flip(flip(flip(double(vol),2),3),1);
[~,ind] = max(~isnan(vol) & vol~=0,[],2);
% ind(ind==1) = NaN;
[R,C] = ndgrid(1:256,1:256);
I = sub2ind(size(vol),R,squeeze(ind),C);

sigma = 1;
g = exp(-(-3*sigma:3*sigma).^2/(2*sigma^2));
g = g'/sum(g(:));
vol = imfilter(imfilter(imfilter(vol,shiftdim(g,-0)),shiftdim(g,-1)),shiftdim(g,-2));
[fz,fy,fx] = gradient(vol);
invfnorm = 1./sqrt(fz.^2 + fy.^2 + fx.^2);
fz = +fz .* invfnorm;
fy = -fy .* invfnorm;
fx = -fx .* invfnorm;

fz = squeeze(fz(I));
fy = squeeze(fy(I));
fx = squeeze(fx(I));

normal = cat(3,fx,fy,fz);

save(fullfile(filepath,'bunny_l[0.00,-0.50,0.00]_r[1.57,0.00,3.14]_v[0.80,0.53,0.81]_s[256]_l[256]_gs[1.00]_conf_nor.mat'),'normal');
     