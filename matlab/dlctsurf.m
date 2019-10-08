function dlctsurf(pos,dir,ind)
    thresh = 0;
    tempfile = 'temp.ply';
    surffile = 'surf.ply';

    %dir = dir ./ sqrt(abs(dir));


    dir = reshape(dir(:,:,[1,2,3]),[],3);
    pos = reshape(pos(:,:,[1,2,3]),[],3);
    plyWrite(tempfile,pos(ind,:).*[1,1,-1],dir(ind,:));

    % visualize surface 
    execpath = '~/Developer/PoissonRecon/Bin/Linux/';
    tempfile = 'temp.ply';
    surffile = 'surf.ply';
    q(sprintf('%s --in %s --out %s --degree 2 --bType 2 --pointWeight 4 --confidence -2 --ascii --density', ...
              fullfile(execpath,'PoissonRecon'), tempfile, surffile));
    q(sprintf('%s --in %s --out %s --trim %d', ...
              fullfile(execpath,'SurfaceTrimmer'), surffile, tempfile, thresh));

    [V,F] = plyRead(tempfile,1);
    plySurf(V,F);
    set(gca,'YDir','Normal');
    set(gca,'ZDir','Reverse');
    view(0,-90);
    camlight('right','infinite');
end