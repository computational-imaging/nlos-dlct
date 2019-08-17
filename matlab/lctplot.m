close all;
clear all;

N = 128;
M = 128;

x = linspace(-1,1,N);
y = linspace(-1,1,N);
z = linspace(-1,1,M);

[X_,Y_,Z_] = ndgrid(-1:0.2:1,-1:0.2:1,0:0.1:1);
% scatter3(X_(:),Y_(:),Z_(:),8,[1,0,0],'filled');
% hold on;
[X,Y,Z] = sphere(N);
%[X,Y] = (x,y);



for xp = 0:0.02:1
    lctdraw(-cos(xp*2*pi),0,2);
    pdfprint(sprintf('temp_%2.2f.pdf',xp),'Width',20,'Height',15,'Position',[3,1,15,13])
end

for yp = 0:0.02:0.50
    lctdraw(0,-cos(yp*2*pi),2);
    pdfprint(sprintf('temp_%2.2f.pdf',yp),'Width',20,'Height',15,'Position',[3,1,15,13])
end

for tc = 0:0.02:0.50
    lctdraw(0,0,2- 2*sin((tc)*pi));
    pdfprint(sprintf('temp_%2.2f.pdf',tc),'Width',20,'Height',15,'Position',[3,1,15,13])
end

xp = 0;
tc = 2;
for yp = sin((0:0.01:1)*2*pi)
    hold off;
    D = abs(2*sqrt((X_-xp).^2 + (Y_-yp).^2 + Z_.^2) - tc) < 0.05;
    C = 0.8*ones(size(Z_(:),1),3);
    C(D(:)==1,1) = 1;
    C(D(:)==1,2) = 0;
    C(D(:)==1,3) = 0;
    h = scatter3(X_(:),Y_(:),Z_(:),16,C,'filled');
    hold on;
    Z = sqrt(max(0,tc^2/4 - (X-xp).^2 - (Y-yp).^2));
    Z(Z<0.01) = NaN;
    mesh(X,Y,Z,'EdgeColor','black');
    text(-1,0,1.25,sprintf('$\\tau(%2.1f,%2.1f,%2.1f)$',xp,yp,tc), ...
         'HorizontalAlignment','center');
    xticks(-1:0.5:1);
    yticks(-1:0.5:1);
    zticks(0:0.5:1);
    xlabel('$x$');
    ylabel('$y$');
    zlabel('$z$');
    a = gca;
    % a.XLabel.Position = [0 -1.5 0];
    % a.YLabel.Position = [+1.5 0 0];

    axis([-1,1,-1,1,0,1]);
    axis equal;
    view(45,25);
    camproj('perspective');
    drawnow limitrate;
end

xp = 0;
yp = 0;
for tc = 2 - 2*sin((0:0.01:1)*pi)
    hold off;
    D = abs(2*sqrt((X_-xp).^2 + (Y_-yp).^2 + Z_.^2) - tc) < 0.05;
    C = 0.75*ones(size(Z_(:),1),3);
    C(D(:)==1,1) = 1;
    C(D(:)==1,2) = 0;
    C(D(:)==1,3) = 0;
    scatter3(X_(:),Y_(:),Z_(:),8,C,'filled');
    hold on;
    scatter3(X_(D),Y_(D),Z_(D),16,C(D,:),'filled');
    hold on;

    Z = sqrt(max(0,tc^2/4 - (X-xp).^2 - (Y-yp).^2));
    Z(Z<0.01) = NaN;
    mesh(X,Y,Z,'EdgeColor','black');
    
    text(1,-1,2.25,sprintf('$\\tau(%2.1f,%2.1f,%2.1f)$',xp,yp,tc), ...
         'HorizontalAlignment','center');
    
    xticks(-1:0.5:1);
    yticks(-1:0.5:1);
    zticks(0:0.5:1);
    xlabel('$x$');
    ylabel('$y$');
    zlabel('$z$');
    a = gca;
    a.XLabel.Position = [0 -1.25 0];
    a.YLabel.Position = [+1.25 0 0];

    axis('equal',[-1,1,-1,1,0,1]);
    view(45,25);
    camproj('perspective');
    drawnow limitrate;
end

