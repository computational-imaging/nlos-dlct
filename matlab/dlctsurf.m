function dlctsurf(pos,dir,ind)
% export to a PLY file
tempfile = 'temp.ply';
surffile = 'surf.ply';

mag = sqrt(sum(dir.^2,3));
if nargin < 3
    ind = find(mag > 0.5e-5);
end
dir = reshape(dir(:,:,[2,1,3]),[],3);
pos = reshape(pos(:,:,[2,1,3]),[],3);
plyWrite(tempfile,pos(ind,:).*[1,1,-1],dir(ind,:));

% visualize surface 
execpath = '~/Developer/PoissonRecon/Bin/Linux/';
tempfile = 'temp.ply';
surffile = 'surf.ply';
q(sprintf('%s --in %s --out %s --degree 2 --bType 2 --pointWeight 1 --ascii', ...
          fullfile(execpath,'PoissonRecon'), tempfile, surffile));
[V,F] = plyRead(surffile,1);
plySurf(V,F);

end