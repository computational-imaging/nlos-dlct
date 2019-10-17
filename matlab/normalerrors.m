%clear all;

scene = 'rabbit';
snr = 70;
%nlos = loaddata(scene);
normal = nlos.Normal;

alg = 'dlct';
load(sprintf('errors_%s_%f_%s.mat',scene,snr,alg));
load(sprintf('output_%s_%f_%s.mat',scene,snr,alg));

mads = zeros(length(lambdas),2);
rmse = zeros(length(lambdas),2);

g = find(gammas == 4);
for l = 1:length(lambdas)
    dirc = dirarray(:,:,:,g,l);
    dirc = dirc./sqrt(sum(dirc.^2,3));
    rmse(l,2) = sqrt(mean(reshape(sum((dirc - normal).^2,3),[],1),'omitnan'));
    mads(l,2) = mean(reshape(sqrt(sum((dirc - normal).^2,3)),[],1),'omitnan');
end

alg = 'lct';
load(sprintf('errors_%s_%f_%s.mat',scene,snr,alg));
load(sprintf('output_%s_%f_%s.mat',scene,snr,alg));

g = find(gammas == 4);
for l = 1:length(lambdas)
    [X,Y] = meshgrid(linspace(-0.5,0.5,256));
    Z = posarray(:,:,end,g,l);
    mask = normal;
    mask(~isnan(mask)) = 1;
    dirc = pcnormals(pointCloud(cat(3,-X,-Y,Z).*mask));
    rmse(l,1) = sqrt(mean(reshape(sum((dirc - normal).^2,3),[],1),'omitnan'));
    mads(l,1) = mean(reshape(sqrt(sum((dirc - normal).^2,3)),[],1),'omitnan');
end

lambda = 2.^(-8:+8);

[mmad,imad] = min(mads);
[mmse,imse] = min(rmse);

map  = vega10(10);
figure;
semilogx(lambda,rmse,'LineWidth',1);
hold on;
semilogx(lambda(imse(1))',mmse(1),'.','MarkerSize',10,'Color',map(1,:));
semilogx(lambda(imse(2))',mmse(2),'.','MarkerSize',10,'Color',map(2,:));
xlabel('$\lambda$');
%ylabel('root-mean-squared error (cm)');
yticks(0.5:0.2:1.1);
yticklabels(0.5:0.2:1.1);
a = yticklabels;
a{end} = '$\mathrm{cm}$';
yticklabels(a);
axis([10^-2,10^+2,0.5,1.1]);
pdfprint('temp.pdf','Width',9.5,'Height',10.5,'Position',[1.5,2.5,7,7]);

figure;
semilogx(lambda,mads,'LineWidth',1);
hold on;
semilogx(lambda(imad(1))',mmad(1),'.','MarkerSize',10,'Color',map(1,:));
semilogx(lambda(imad(2))',mmad(2),'.','MarkerSize',10,'Color',map(2,:));
%ylabel('mean absolute error (cm)');
xlabel('$\lambda$');
yticks(0.3:0.1:0.7);
yticklabels(0.3:0.1:0.7);
a = yticklabels;
a{end} = '$\mathrm{cm}$';
yticklabels(a);
axis([10^-2,10^+2,0.3,0.7]);
pdfprint('temp.pdf','Width',9.5,'Height',10.5,'Position',[1.5,2.5,7,7]);
