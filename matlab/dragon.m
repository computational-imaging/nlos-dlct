clear all;
close all;

load output_dragon_dlct2;
dir = dirarray(:,:,:,1,17);
pos = posarray(:,:,:,1,17);

grid = linspace(-1,+1,256);
mask = sqrt(sum(dir(:,:,:).^2,3))>10 & pos(:,:,3)<1.6;
se = strel('disk',0);
mask = imclose(mask,se);
%[X,Y] = meshgrid(grid);
%pos = cat(3,X,Y,pos);

% figure;
% vis(mask.*dir(:,:,3));

for w = 4%0:0.25:8
    figure;
    dlctsurf(pos,dir,mask,w);
    camup([1,0,0]);
    set(gca,'ydir','reverse');
    axis([-0.75,0.65,-0.60,0.80,-1.4612,-0.7054]);
    pdfprint(sprintf('%s_%4.2f.pdf','dragon',w),'Width',8.5,'Height',8.5,'Position',[0,0,8.5,8.5],'Renderer','OpenGL');
end