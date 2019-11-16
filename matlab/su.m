clear all;
close all;

load output_statue_dlct2;
dir = dirarray(:,:,:,1,17);
pos = posarray(:,:,:,1,17);


grid = linspace(-1,+1,256);
mask = sqrt(sum(dir(:,:,:).^2,3))>9 & pos(:,:,3)<1.3;
se = strel('disk',0);
mask = imclose(mask,se);
%[X,Y] = meshgrid(grid);
%pos = cat(3,X,Y,pos);

% figure;
% vis(mask.*dir(:,:,3));

for w = 0:0.25:4
    figure;
    dlctsurf(pos,dir,mask,w,7.5);
    camup([1,0,0]);
    set(gca,'ydir','reverse');
    % axis([-0.55,0.55,-0.4,0.4,-1.4612,-0.7054]);
    pdfprint(sprintf('%s_%4.2f.pdf','statue',w),'Width',8.5,'Height',8.5,'Position',[0,0,8.5,8.5],'Renderer','OpenGL');
end