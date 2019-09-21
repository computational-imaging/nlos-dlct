function dlctsurf(pos,dir,ind)
    tempfile = 'temp.ply';
    surffile = 'surf.ply';

    dir = reshape(dir(:,:,[1,2,3]),[],3);
    pos = reshape(pos(:,:,[1,2,3]),[],3);
    plyWrite(tempfile,pos(ind,:).*[1,1,-1],dir(ind,:));

    % visualize surface 
    execpath = '~/Developer/PoissonRecon/Bin/Linux/';
    tempfile = 'temp.ply';
    surffile = 'surf.ply';
    q(sprintf('%s --in %s --out %s --degree 2 --bType 2 --pointWeight 4 --confidence -1 --ascii --exact', ...
                             fullfile(execpath,'PoissonRecon'), tempfile, surffile));
    [V,F] = plyRead(surffile,1);
    plySurf(V,F);
    set(gca,'YDir','Normal');
    set(gca,'ZDir','Reverse');
    view(0,-90);
    camlight('headlight','infinite');
end