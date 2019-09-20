clear all;
close all;

mads = [1.79e-02
        1.58e-02
        1.43e-02
        1.40e-02
        1.40e-02
        1.41e-02
        1.42e-02
        1.42e-02
        1.43e-02
        1.43e-02
        1.43e-02
        1.44e-02
        1.45e-02
        1.46e-02
        1.47e-02
        1.48e-02
        1.51e-02];

rmse = [5.54e-02
        5.01e-02
        4.59e-02
        4.54e-02
        4.55e-02
        4.58e-02
        4.64e-02
        4.65e-02
        4.67e-02
        4.67e-02
        4.67e-02
        4.67e-02
        4.67e-02
        4.68e-02
        4.69e-02
        4.70e-02
        4.73e-02];

lambda = 2.^(-8:+8);
% yyaxis left;
semilogx(lambda,rmse);
xlabel('$\lambda$');
%ylabel('root-mean-squared error (cm)');
yticks(0.044:0.004:0.056);
yticklabels(4.4:0.4:5.6);
axis([2^-8,2^+8,0.044,0.056]);


%yyaxis right;
semilogx(lambda,mads);
%ylabel('mean absolute error (cm)');
xlabel('$\lambda$');
yticks(0.014:0.001:0.019);
yticklabels(1.4:0.1:1.9);
axis([2^-8,2^+8,0.014,0.019]);
