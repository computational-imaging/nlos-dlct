clear all;
close all;

y = 0:0.01:1;
x = 1;
imagesc(x,y,y');
%pbaspect([1,7,1]);
%axis equal;
%pbaspect([15*length(y),length(x),1]);
text(0.30,0,'0cm','VerticalAlignment','top','HorizontalAlignment','left','Color','white');
text(0.30,1,'4cm','VerticalAlignment','bottom','HorizontalAlignment','left','Color','white');

yticks(0:0.5:1);
yticklabels({});
xticks({});
set(gcf,'Color','black');
set(gca,'XColor','white');
set(gca,'YColor','white');
set(gca,'Ydir','normal');
set(gca,'YAxisLocation','right');
axis on;
colormap(hot);
pdfprint('temp.pdf','Width',2.5,'Height',8.5,'Position',[0.75,1,1.0,6.5])