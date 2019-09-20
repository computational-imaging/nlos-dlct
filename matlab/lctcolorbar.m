clear all;
close all;

y = 0:0.01:1;
x = 1;
imagesc(x,y,y');
%pbaspect([1,7,1]);
%axis equal;
%pbaspect([15*length(y),length(x),1]);
text(0.30,0,'0cm','VerticalAlignment','top','HorizontalAlignment','center');
text(0.30,1,'1cm','VerticalAlignment','bottom','HorizontalAlignment','center');

yticks(0:0.5:1);
yticklabels({});
xticks({});
set(gca,'Ydir','normal');
set(gca,'YAxisLocation','right');
axis on;
colormap(hot);