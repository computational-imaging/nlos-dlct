function lctdraw(xp,yp,tc)
    [X,Y,Z] = sphere(256);
    [X_,Y_,Z_] = ndgrid(-1:0.2:1,-1:0.2:1,0:0.1:1);
    hold off;
    D = abs(2*sqrt((X_+xp).^2 + (Y_+yp).^2 + Z_.^2) - tc) < 0.05;
    C = 0.75*ones(size(Z_(:),1),3);
    C(D(:)==1,1) = 1;
    C(D(:)==1,2) = 0;
    C(D(:)==1,3) = 0;
    %scatter3(X_(:),Y_(:),Z_(:),4,C,'filled');
    hold on;
    %scatter3(X_(D),Y_(D),Z_(D),8,C(D,:),'filled');
    hold on;
    %Z = sqrt(max(0,tc^2/4 - (X-xp).^2 - (Y-yp).^2));
    %Z(Z<0.01) = NaN;
    surf(X*(tc/2)-xp,Y*(tc/2)-yp,Z*(tc/2),0*Z,'EdgeColor','none','LineWidth',0.5,'FaceColor','red');
    camlight('right');
    material('shiny');
    lighting('gouraud');
    % colormap(inferno);

    % text(-1,1,1.25,sprintf('$x''=%2.1f, y''=%2.1f, tc=%2.1f$',xp,yp,tc), ...
    %      'HorizontalAlignment','center');

    xticks(-1:1:1);
    yticks(-1:1:1);
    zticks(0:1:2);
    % xlabel('$x$');
    % ylabel('$y$');
    % zlabel('$z$');
    a = gca;
    % a.XLabel.Position = [0 -1.5 0];
    % a.YLabel.Position = [+1.5 0 0];
    axis equal;
    axis([-1,1,-1,1,0,2]);
    grid on;
    camproj('perspective');
    view(45,25);
    % pbaspect([2,2,1]);
    drawnow limitrate;
end