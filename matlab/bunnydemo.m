%% Run this demo script to step through the included reconstruction procedures

% First, run FBP, LCT, and f-k migration reconstructions for one of the
% captured datasets

% Optionally replace the below filenames with files from other scenes:
% bike, discoball, dragon, outdoor, resolution, statue, teaser
load('~/Developer/cvpr2019_nlos/debugger/bunny/bunny.mat');
load('~/Developer/cvpr2019_nlos/debugger/bunny/bunny_depth.mat','bunny_depth','bunny_mask');

% resize to low resolution to reduce memory requirements
measlr = imresize3(permute(data,[3,2,1]),[256,256,512]);
tofgridlr = [];
wall_size = 1;

M = size(measlr,3);
c = 3e8;
bin_resolution = 16e-12;
range = M.*c.*bin_resolution;
lambda = 10;

% run LCT
fprintf('\nRunning LCT\n');
algorithm = 1;
lct = cnlos_reconstruction(measlr, tofgridlr, wall_size, range, ...
                           algorithm, lambda);

[~,pos] = max(lct,[],3);
pos = pos * ((range/2)/M);
mask = imresize(bunny_mask,size(pos),'nearest');
depth = imresize(bunny_depth,size(pos));
mad = sum(abs(pos(:) - depth(:)) .* mask(:))/sum(mask(:));
mse = sum((pos(:) - depth(:)).^2 .* mask(:))/sum(mask(:));
vis(abs(pos-depth).*mask);
figure;
colormap(hot);
caxis([0,0.01]);