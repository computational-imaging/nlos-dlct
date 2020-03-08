% DLCTSURF Visualize surface from DLCT directional albedo.
%
%   DLCTSURF(POS, DIR, IND) visualizes the NLOS surface represented
%   by the voxel positions POS, directional albedo DIR, and the
%   mask ID.
%
%   DLCTSURF(..., POINTWEIGHT, THRESH) visualizes the NLOS surface
%   by additionally specifying the POINTWEIGHT and the THRESHOLD
%   parameters for the Poisson Surface Reconstruction software.
%
%   Author:  Sean I. Young  (Stanford University)
%   Contact: sean0@stanford.edu, seannz@gmail.com
%
% Copyright 2019-2020 Stanford University, Stanford CA 94305, USA
%
%                         All Rights Reserved
%
% Permission to use, copy, modify, and distribute this software and
% its documentation for any purpose other than its incorporation into
% a commercial product is hereby granted without fee, provided that
% the above copyright notice appear in all copies and that both that
% copyright notice and this permission notice appear in supporting
% documentation, and that the name of Stanford University not be used
% in advertising or publicity pertaining to distribution of the
% software without specific, written prior permission.
%
% STANFORD UNIVERSITY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
% SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR ANY PARTICULAR PURPOSE.  IN NO EVENT SHALL STANFORD
% UNIVERSITY BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
% DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
% OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
% TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
% PERFORMANCE OF THIS SOFTWARE.

function dlctsurf(pos,dir,ind, pointWeight, thresh)
    if nargin < 4
        pointWeight = 4;
    end
    if nargin < 5
        thresh = 6 - log2(256/size(pos,1));
    end

    dir = reshape(dir(:,:,[1,2,3]),[],3);
    pos = reshape(pos(:,:,[1,2,3]),[],3);
    plyWrite('temp.ply',pos(ind,:).*[1,1,-1],dir(ind,:));

    % Poisson surface reconstruction
    execpath = '~/Developer/PoissonRecon/Bin/Linux/';
    system(sprintf('%s --in %s --out %s --degree 2 --bType 2 --pointWeight %f --ascii --density', ...
                   fullfile(execpath,'PoissonRecon'), 'temp.ply', 'surf.ply', pointWeight));
    system(sprintf('%s --in %s --out %s --trim %d', fullfile(execpath,'SurfaceTrimmer'), ...
                   'surf.ply', 'trim.ply', thresh));


    % visualize the reconstructed surface
    [V,F] = plyRead('trim.ply',1);
    p = patch('Faces',F,'Vertices',V,'EdgeColor','none');
    p.FaceColor = 0.98*[1,1,1];
    axis equal off;
    material(p,'shiny');
    lighting('gouraud');
    camproj('perspective');
    cameratoolbar('show');
    set(gcf,'Color','black');
    set(gca,'YDir','Normal');
    set(gca,'ZDir','Reverse');
    view(0,-90);
    camlight('right','infinite');
end