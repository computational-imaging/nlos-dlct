close all;
clear all; 

rng(0);
scene = 'su';
snr = Inf;
nlos = loaddata(scene, snr);

gammas = 2;%2:0.5:4;
lambdas = 1;
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

        depth = 0;%fliplr(nlos.Depth'); %-0.005;
        depth(isinf(depth)) = NaN;

        mse(g,l) = mean(abs(dep(:) - depth(:)).^2,'omitnan');
        mad(g,l) = mean(abs(dep(:) - depth(:)).^1,'omitnan');
        posarray(:,:,:,g,l) = pos;
        dirarray(:,:,:,g,l) = dir;
        disp(sprintf('%s D-LCT | SNR: %3.0f dB, gamma: %d, lambda: %+6.2f, rmse: %5.2e, mad: %5.2e, time: %5.2fs', ...
                     scene, snr, gamma, lambda, sqrt(mse(g,l)), mad(g,l), sec));
    end
end


save(sprintf('errors_%s_%f_dlct.mat',scene,snr),'mse','mad','lambdas','gammas');
save(sprintf('output_%s_%f_dlct.mat',scene,snr),'posarray','dirarray');