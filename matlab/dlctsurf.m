function dlctsurf(pos,dir,ind, pointWeight, thresh)
    if nargin < 4
        pointWeight = 4;
    end
    if nargin < 5
        thresh = 0;
    end

    % dir = dir./abs(sqrt(dir));
    % thresh = 0;%7.5;
    tempfile = 'temp.ply';
    surffile = 'surf.ply';
    trimfile = 'trim.ply';

    %dir = dir ./ sqrt(abs(dir));


    dir = reshape(dir(:,:,[1,2,3]),[],3);
    pos = reshape(pos(:,:,[1,2,3]),[],3);
    plyWrite(tempfile,pos(ind,:).*[1,1,-1],dir(ind,:));

    % visualize surface 
    execpath = '~/Developer/PoissonRecon/Bin/Linux/';
    tempfile = 'temp.ply';
    surffile = 'surf.ply';
    q(sprintf('%s --in %s --out %s --degree 2 --bType 2 --pointWeight %f --ascii --density', ...
              fullfile(execpath,'PoissonRecon'), tempfile, surffile, pointWeight));
    q(sprintf('%s --in %s --out %s --trim %d', ...
              fullfile(execpath,'SurfaceTrimmer'), surffile, trimfile, thresh));

    [V,F] = plyRead(trimfile,1);
    plySurf(V,F);
    set(gca,'YDir','Normal');
    set(gca,'ZDir','Reverse');
    view(0,-90);
    camlight('right','infinite');
end