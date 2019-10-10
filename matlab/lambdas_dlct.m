close all;
clear all; 

rng(0);
scene = 'dragon';

nlos = loaddata(scene);
gammas = 4:5;%2:0.5:4;
lambdas = -16:16;
sigmas = [1,1,1];
[w,h,~] = size(nlos.Data);
mse = zeros(length(gammas),length(lambdas));
mad = zeros(length(gammas),length(lambdas));

posarray = zeros(w/sigmas(1),h/sigmas(2),3,length(gammas),length(lambdas));
dirarray = zeros(w/sigmas(1),h/sigmas(2),3,length(gammas),length(lambdas));

for g = 1:length(gammas)
    for l = 1:length(lambdas)
        gamma = gammas(g);
        lambda = lambdas(l);

        [pos,dir,sec] = dlct(nlos,2^lambda,gamma,sigmas,[2,2,2]);
        dep = pos(:,:,3);

        depth = fliplr(nlos.Depth'-0.005);
        depth(isinf(depth)) = NaN;

        mse(g,l) = mean(abs(dep(:) - depth(:)).^2 .* depth(:),'omitnan');
        mad(g,l) = mean(abs(dep(:) - depth(:)).^1 .* depth(:),'omitnan');
        posarray(:,:,:,g,l) = pos;
        dirarray(:,:,:,g,l) = dir;
        disp(sprintf('%s D-LCT | gamma: %d, lambda: %+6.2f, rmse: %5.2e, mad: %5.2e, time: %5.2fs', ...
                     scene, gamma, lambda, sqrt(mse(g,l)), mad(g,l), sec));
    end
end


save(sprintf('mae_%s_dlct.mat',scene),'mse','mad','lambdas','gammas');
save(sprintf('output_%s_dlct2.mat',scene),'posarray','dirarray');

