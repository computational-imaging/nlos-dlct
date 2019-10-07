close all;
clear all; 

rng(0);
scene = 'serapis';

nlos = loaddata(scene);
gammas = 5;%2:0.5:4;
lambdas = -8:8;
sigmas = [1,1,1];
[w,h,~] = size(nlos.Data);
for g = 1:length(gammas)
    for l = 1:length(lambdas)
        gamma = gammas(g);
        lambda = lambdas(l);

        [pos,dir,sec] = dlct(nlos,2^lambda,gamma,[1,1,1],[2,2,2]);
        pos = pos(:,:,3);

        depth = fliplr(nlos.Depth'-0.005);
        depth(isinf(depth)) = NaN;

        mse(g,l) = mean(abs(pos(:) - depth(:)).^2 .* depth(:),'omitnan');
        mad(g,l) = mean(abs(pos(:) - depth(:)).^1 .* depth(:),'omitnan');

        disp(sprintf('%s D-LCT | gamma: %d, lambda: %+6.2f, rmse: %5.2e, mad: %5.2e, time: %5.2fs', ...
                     scene, gamma, lambda, sqrt(mse(g,l)), mad(g,l), sec));
    end
end


save(sprintf('mae_%s_dlct.mat',scene),'mse','mad','lambdas','gammas');
%save(sprintf('output_%s_dlct.mat',scene),'posarray','dirarray');
