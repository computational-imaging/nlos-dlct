function lctdraw3(xp,yp,up)
    [X,Y,Z] = sphere(512);
    [X_,Y_,Z_] = ndgrid(-1:0.2:1,-1:0.2:1,0:0.1:1);
    hold off;
    D = abs(4*((X_+xp).^2 + (Y_+yp).^2 + Z_.^2) - up) < 0.05;
    C = 0.75*ones(size(Z_(:),1),3);
    C(D(:)==1,1) = 1;
    C(D(:)==1,2) = 0;
    C(D(:)==1,3) = 0;
    %scatter3(X_(:),Y_(:),4*Z_(:).^2,8,C,'filled');
    hold on;
    %lcscatter3(X_(D),Y_(D),4*Z_(D).^2,16,C(D,:),'filled');
    hold on;

    U = up - 4*(X).^2 - 4*(Y).^2;
    surf(X-xp,Y-yp,U,Y,'EdgeColor','none');
    colormap(hsv);
    camlight('right');
    material('shiny');
    lighting('gouraud');

    % text(-1,1,4.5,sprintf('$x''=%2.1f, y''=%2.1f, u''=%2.1f$',xp,yp,up), ...
    %      'HorizontalAlignment','center');
    
    xticks(-1:1:1);
    yticks(-1:1:1);

    zticks(0:2:4);
    % xlabel('$x$');
    % ylabel('$y$');
    % zlabel('$u$');
    a = gca;
    grid on;

    a.XLabel.Position = [0 -1.5 0];
    a.YLabel.Position = [+1.5 0 0];
    axis([-1,1,-1,1,0,4]);
    axis square;
    %pbaspect([2,2,1]);
    view(45,25);
    camproj('perspective');
    drawnow limitrate;
end