close all;
clear all; 

rng(0);
scene = 'rabbit';

nlos = loaddata(scene);
measlr = imresize3(nlos.Data,[256,256,512]);
tofgridlr = [];
wall_size = nlos.CameraGridSize;

M = size(measlr,3);
range = M.*nlos.DeltaT;
algorithm = 1;

gammas = 4;%2:4;
lambdas = -8:8;
mse = zeros(1,length(lambdas));
mad = zeros(1,length(lambdas));

for g = 1:length(gammas)
    for l = 1:length(lambdas)
        gamma = gammas(g);
        lambda = lambdas(l);

        tic;
        lct = cnlos_reconstruction(measlr, tofgridlr, wall_size, range, ...
                                   algorithm, 2^lambda, gamma);
        sec = toc;
        [~,pos] = max(lct,[],3);
        pos = flipud(fliplr(pos'-1)) * ((range/2)/M);

        depth = fliplr(nlos.Depth');
        depth(isinf(depth)) = NaN;
        
        mse(g,l) = mean(abs(pos(:) - depth(:)).^2 .* depth(:),'omitnan');
        mad(g,l) = mean(abs(pos(:) - depth(:)).^1 .* depth(:),'omitnan');
        
        disp(sprintf('%s LCT | gamma: %d, lambda: %+6.2f, rmse: %5.2e, mad: %5.2e, time: %5.2fs', ...
                 scene, gamma, lambda, sqrt(mse(g,l)), mad(g,l), sec));
    end
end


%save(sprintf('mae_%s_lct.mat',scene),'mse','mad','lambdas','gammas');
