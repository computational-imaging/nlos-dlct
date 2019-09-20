clear all;
close all;

mads = [4.02e-01 2.12e-02  
        1.45e-02 1.82e-02  
        1.39e-02 1.65e-02  
        1.38e-02 1.56e-02  
        1.41e-02 1.49e-02  
        1.43e-02 1.47e-02  
        1.44e-02 1.45e-02  
        1.44e-02 1.44e-02  
        1.44e-02 1.44e-02  
        1.44e-02 1.43e-02  
        1.45e-02 1.43e-02  
        1.45e-02 1.44e-02  
        1.46e-02 1.44e-02  
        1.48e-02 1.46e-02  
        1.49e-02 1.48e-02  
        1.50e-02 1.51e-02  
        1.54e-02 1.55e-02];

rmse = [4.09e-01 6.46e-02    
        4.62e-02 5.79e-02  
        4.44e-02 5.39e-02  
        4.41e-02 5.15e-02  
        4.52e-02 4.91e-02  
        4.61e-02 4.84e-02  
        4.67e-02 4.77e-02  
        4.66e-02 4.72e-02  
        4.67e-02 4.71e-02  
        4.67e-02 4.68e-02  
        4.67e-02 4.67e-02  
        4.68e-02 4.67e-02  
        4.68e-02 4.68e-02  
        4.70e-02 4.69e-02  
        4.71e-02 4.72e-02  
        4.72e-02 4.78e-02  
        4.75e-02 4.85e-02];

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
yticks(0.040:0.004:0.060);
yticklabels(4.0:0.4:6);
a = yticklabels
a{end} = '$\mathrm{cm}$';
yticklabels(a);
axis([2^-8,2^+8,0.04,0.06]);
pdfprint('temp.pdf','Width',10,'Height',10.5,'Position',[1.5,2.5,8,7.5]);

figure;
semilogx(lambda,mads,'LineWidth',1);
hold on;
semilogx(lambda(imad(1))',mmad(1),'.','MarkerSize',10,'Color',map(1,:));
semilogx(lambda(imad(2))',mmad(2),'.','MarkerSize',10,'Color',map(2,:));
%ylabel('mean absolute error (cm)');
xlabel('$\lambda$');
yticks(0.013:0.001:0.018);
yticklabels(1.3:0.1:1.8);
a = yticklabels
a{end} = '$\mathrm{cm}$';
yticklabels(a);
axis([2^-8,2^+8,0.013,0.018]);


































































