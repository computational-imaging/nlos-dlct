function plySurf(V,F,C,N)
    axis equal off;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    view(0,0);
    ax = gca;
    %ax.Position = [0,0,1,1];
    %ax.CameraViewAngle = 7;
    %ax.Projection = 'perspective';
    f = gcf;
    %f.Renderer = 'painters';
    %f.ToolBar = 'none';
    % f.MenuBar = 'none';
    % V = V(:,[2,3,1]);
    % V(:,3) = -V(:,3);
    p = patch('Faces',F,'Vertices',V);
    p.FaceColor = 0.97*[1,1,1];
    p.EdgeColor = 'none';
    material(p,'shiny');
    lighting('gouraud');
    %camlight('headlight','infinite');
    camproj('perspective');
    cameratoolbar('show');

    if nargin == 4
        hold on;
        quiver3(C(:,1),C(:,3),C(:,2),N(:,1),N(:,3),N(:,2),'Color','white');
    end
end