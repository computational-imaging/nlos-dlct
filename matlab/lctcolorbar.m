clear all;
close all;

y = 0:0.01:1;
x = 1;
imagesc(x,y,y');
pbaspect([1,8,1]);
%axis equal;
%pbaspect([15*length(y),length(x),1]);
yticks(0:0.5:1);
yticklabels({'$0$cm','','$1$cm'});
xticks({});
set(gca,'Ydir','normal');
set(gca,'YAxisLocation','right');
axis on;
colormap(hot);