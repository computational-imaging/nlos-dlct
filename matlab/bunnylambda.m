close all;
clear all; 

scene = 'bunny';

nlos = loaddata(scene);

load('~/Developer/cvpr2019_nlos/debugger/bunny/bunny_depth.mat','bunny_depth','bunny_mask');

bunny_mask = double(bunny_mask);

gammas = 3;
lambdas = 0:4;
mse = zeros(length(gammas),length(lambdas));
mad = zeros(length(gammas),length(lambdas));

for g = 1:length(gammas)
    for l = 1:length(lambdas)
        gamma = gammas(g);
        lambda = lambdas(l);
        [pos,dir,sec] = dlct(nlos,2^lambda,gamma);
        pos = pos(:,:,3);
        mask = imresize(bunny_mask,size(pos),'nearest');
        depth = imresize(bunny_depth,size(pos));
        
        % mse(g,l) = sum(((pos(:) - depth(:)) .* mask(:)).^2)/sum(mask(:).^2);
        mse(g,l) = sum((pos(:) - depth(:)).^2 .* mask(:))/sum(mask(:));
        mad(g,l) = sum(abs(pos(:) - depth(:)) .* mask(:))/sum(mask(:));
        disp(sprintf('%s | gamma: %d, lambda: %+6.2f, mse: %5.2e, mad: %5.2e, time: %5.2fs', ...
                     scene, gamma, lambda, mse(g,l), mad(g,l), sec));
    end
end
vis(abs(pos-depth).*mask); 
colormap(jet); caxis([0,0.01]);
% pcdenoise(pointCloud(pos.*(mask>0)),'NumNeighbors',64,'Threshold',0.06))