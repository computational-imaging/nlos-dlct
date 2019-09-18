clear all;
close all;

x = -1:0.01:1;
y = 1;
imagesc(y,x,repmat(x',1,10));
pbaspect([20*length(y),length(x),1]);
yticks(-1:1:1);
set(gca,'Ydir','normal');
axis on;
xticks({});
colormap(jet);