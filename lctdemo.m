%% Run this demo script to step through the included reconstruction procedures

% First, run FBP, LCT, and f-k migration reconstructions for one of the
% captured datasets

% Optionally replace the below filenames with files from other scenes:
% bike, discoball, dragon, outdoor, resolution, statue, teaser
load('statue/tof.mat');
load('statue/meas_10min.mat');

% resize to low resolution to reduce memory requirements
measlr = imresize3(meas, [64, 64, 2048]); % y, x, t
tofgridlr = imresize(tofgrid, [64, 64]); 
wall_size = 2; % scanned area is 2 m x 2 m

% run LCT
fprintf('\nRunning LCT\n');
algorithm = 1;
lct = cnlos_lct(measlr, tofgridlr, wall_size, algorithm);