close all;
clear all;

x = pi/2*(-1:0.01:1);
a = 1;
b = 0;
plot(x,a*cos(x)+b,'Color',0.5*[1,1,1]);
hold on;
plot(x,cos(x).^2,'r');


xticks([-pi/2,0,pi/2]);
xticklabels({'$-\pi/2$','$0$','$\pi/2$'});
yticks(-1:1:1);
axis([-pi/2,pi/2,-1,1]);
xlabel('$x$');
set(gcf,'Color','white');
pdfprint('temp.pdf','Width',10,'Height',10,'Position',[1.5,1.5,7.5,7.5]);