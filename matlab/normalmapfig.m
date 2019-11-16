%clear all;

alg = 'dlct';
scene = 'rabbit';
snr = 70;

load(sprintf('errors_%s_%f_%s.mat',scene,snr,alg));
load(sprintf('output_%s_%f_%s.mat',scene,snr,alg));

lambda = 2^3;
gamma = 4;
l = find(lambdas == log2(lambda));
g = find(gammas == 4);
nlos = loaddata(scene);

normal = nlos.Normal;
dirc = dirarray(:,:,1:3,g,l);
dirc = dirc./sqrt(sum(dirc.^2,3));
alpha = double(~isnan(normal(:,:,1)));


% posc = posarray(:,:,end,g,l);
%mask = ~isinf(normal);

figure;
vis(sqrt(sum((dirc - normal).^2,3)),alpha);
set(gcf,'Color',[1,1,1]);
axis([17,240,17,240]);
caxis([0,1]);
colormap(jet);
