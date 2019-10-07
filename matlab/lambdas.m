clear all;
close all;

mads = [1.63e-02, 1.81e-02
        1.42e-02, 1.41e-02
        1.28e-02, 1.10e-02
        1.21e-02, 9.21e-03
        1.13e-02, 8.57e-03
        1.09e-02, 8.15e-03
        1.05e-02, 8.13e-03
        1.02e-02, 8.21e-03
        1.00e-02, 8.61e-03
        9.97e-03, 9.06e-03
        9.91e-03, 9.27e-03
        9.88e-03, 9.32e-03
        9.89e-03, 9.31e-03
        9.98e-03, 9.46e-03
        1.02e-02, 9.60e-03
        1.04e-02, 9.73e-03
        1.05e-02, 9.81e-03];

rmse = [6.38e-02  6.20e-02
        5.99e-02  5.27e-02
        5.70e-02  4.45e-02
        5.57e-02  3.90e-02
        5.32e-02  3.73e-02
        5.16e-02  3.61e-02
        5.04e-02  3.65e-02
        4.89e-02  3.75e-02
        4.81e-02  4.00e-02
        4.78e-02  4.27e-02
        4.74e-02  4.39e-02
        4.68e-02  4.40e-02
        4.66e-02  4.39e-02
        4.64e-02  4.43e-02
        4.66e-02  4.44e-02
        4.65e-02  4.46e-02
        4.66e-02  4.45e-02];

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
yticks(0.030:0.010:0.070);
yticklabels(4.0:1.0:7.0);
a = yticklabels
a{end} = '$\mathrm{cm}$';
yticklabels(a);
axis([2^-8,2^+8,0.03,0.07]);
pdfprint('temp.pdf','Width',10,'Height',10.5,'Position',[1.5,2.5,8,7.5]);

figure;
semilogx(lambda,mads,'LineWidth',1);
hold on;
semilogx(lambda(imad(1))',mmad(1),'.','MarkerSize',10,'Color',map(1,:));
semilogx(lambda(imad(2))',mmad(2),'.','MarkerSize',10,'Color',map(2,:));
%ylabel('mean absolute error (cm)');
xlabel('$\lambda$');
yticks(0.007:0.002:0.015);
yticklabels(0.7:0.2:1.5);
a = yticklabels
a{end} = '$\mathrm{cm}$';
yticklabels(a);
axis([2^-8,2^+8,0.007,0.015]);
pdfprint('temp.pdf','Width',10,'Height',10.5,'Position',[1.5,2.5,8,7.5]);


































































































































