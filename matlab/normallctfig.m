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
%nlos = loaddata(scene);

normal = nlos.Normal;
[X,Y] = meshgrid(linspace(-0.5,0.5,256));
Z = posarray(:,:,end,g,l);
mask = normal;
mask(~isnan(mask)) = 1;

dirc = pcnormals(pointCloud(cat(3,-X,-Y,Z).*mask));

figure;
vis(sqrt(sum((dirc - normal).^2,3)));
axis([17,240,17,240]);
caxis([0,1]);
colormap(hot);