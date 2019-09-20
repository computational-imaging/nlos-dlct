close all;
clear all; 

scene = 'bunny';

nlos = loaddata(scene);
measlr = imresize3(nlos.Data,[256,256,512]);
tofgridlr = [];
wall_size = 1;

M = size(measlr,3);
c = 3e8;
bin_resolution = 16e-12;
range = M.*c.*bin_resolution;
algorithm = 1;

load('~/Developer/cvpr2019_nlos/debugger/bunny/bunny_depth.mat','bunny_depth','bunny_mask');
bunny_mask = double(bunny_mask);

% maxNumCompThreads(4);
gammas = 4;%2:4;
lambdas = 2;%-8:8;
mse = zeros(1,length(lambdas));
mad = zeros(1,length(lambdas));

for g = 1:length(gammas)
    for l = 1:length(lambdas)
        gamma = gammas(g);
        lambda = lambdas(l);
        %[pos,dir,sec] = dlct(nlos,2^lambda,gamma,mu);
        %pos = pos(:,:,3);
        tic;
        lct = cnlos_reconstruction(measlr, tofgridlr, wall_size, range, ...
                                   algorithm, 2^lambda, gamma);
        sec = toc;
        [~,pos] = max(lct,[],3);
        pos = flipud(fliplr(pos')) * ((range/2)/M);
        mask = imresize(bunny_mask,size(pos),'nearest');
        depth = imresize(bunny_depth,size(pos));
        
        mse(g,l) = sum((pos(:) - depth(:)).^2 .* mask(:))/sum(mask(:));
        mad(g,l) = sum(abs(pos(:) - depth(:)) .* mask(:))/sum(mask(:));
        
        disp(sprintf('%s LCT | gamma: %d, lambda: %+6.2f, rmse: %5.2e, mad: %5.2e, time: %5.2fs', ...
                 scene, gamma, lambda, sqrt(mse(g,l)), mad(g,l), sec));
    end
end


%save(sprintf('mae_%s_lct.mat',scene),'mse','mad','lambdas','gammas');
