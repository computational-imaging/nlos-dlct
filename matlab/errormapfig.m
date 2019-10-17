%clear all;

alg = 'lct';
scene = 'rabbit';
snr = 70;

load(sprintf('errors_%s_%f_%s.mat',scene,snr,alg));
load(sprintf('output_%s_%f_%s.mat',scene,snr,alg));

lambda = 2^6;
gamma = 4;
l = find(lambdas == log2(lambda));
g = find(gammas == 4);
nlos = loaddata(scene);

depth = flipud(nlos.Depth)';
posc = posarray(:,:,end,g,l);
mask = ~isinf(depth);

figure;
vis(min(0.08,abs(posc-depth)).*mask);
axis([17,240,17,240]);
caxis([0,0.04]);
colormap(hot);