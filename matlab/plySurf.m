function plySurf(V,F,N)
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
    % N = 0.5 + 0.5 * N./sqrt(sum(N.^2,2));
    p = patch('Faces',F,'Vertices',V,'EdgeColor','none');
    p.FaceColor = 0.95*[1,1,1];
    % p.EdgeColor = 'none';
    material(p,'shiny');
    lighting('gouraud');
    %camlight('headlight','infinite');
    camproj('perspective');
    cameratoolbar('show');
end