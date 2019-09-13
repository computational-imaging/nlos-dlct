clear all; 
close all;

scene = 'bunny';
lambda = 1;

nlos = loaddata(scene);

lambdas = -18:4;
snorms = zeros(length(lambdas),1);
rnorms = zeros(length(lambdas),1);

for l = 1:length(lambdas)
    lambda = lambdas(l);
    [~,~,snorms(l),rnorms(l),sec] = dlct(nlos,2^lambda);
    disp(sprintf('%s | lambda: %+6.2f, rnorm: %5.2e, snorm: %5.2e, time: %5.2fs', ...
                 scene, lambda, rnorms(l), snorms(l), sec));
    loglog(rnorms,snorms);
    drawnow;

end

