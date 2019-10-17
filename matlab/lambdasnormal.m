clear all;
close all;

scene = 'rabbit';
snr = 70;

mads = zeros(17,2);
mses = zeros(17,2);

load(sprintf('errors_%s_%f_%s.mat',scene,snr,'lct'));
mads(:,1) = mad;
rmse(:,1) = sqrt(mse);

load(sprintf('errors_%s_%f_%s.mat',scene,snr,'dlct'));
mads(:,2) = mad;
rmse(:,2) = sqrt(mse);

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
yticks(0.040:0.010:0.080);
yticklabels(4.0:1.0:8.0);
a = yticklabels;
a{end} = '$\mathrm{cm}$';
yticklabels(a);
axis([10^-1,10^+2,0.04,0.08]);
pdfprint('temp.pdf','Width',9.5,'Height',10.5,'Position',[1.5,2.5,7,7]);

figure;
semilogx(lambda,mads,'LineWidth',1);
hold on;
semilogx(lambda(imad(1))',mmad(1),'.','MarkerSize',10,'Color',map(1,:));
semilogx(lambda(imad(2))',mmad(2),'.','MarkerSize',10,'Color',map(2,:));
%ylabel('mean absolute error (cm)');
xlabel('$\lambda$');
yticks(0.014:0.004:0.030);
yticklabels(1.4:0.4:3.0);
a = yticklabels;
a{end} = '$\mathrm{cm}$';
yticklabels(a);
axis([10^-1,10^+2,0.014,0.030]);
pdfprint('temp.pdf','Width',9.5,'Height',10.5,'Position',[1.5,2.5,7,7]);
