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

for w = 4%0:0.25:4
    figure;
    dlctsurf(pos,dir,mask,w,7.5);
    camup([1,0,0]);
    set(gca,'ydir','reverse');
    axis([-0.55,0.55,-0.4,0.4,-1.4612,-0.7054]);
    set(gcf,'Color',0.95*[1,1,1]);
    % pdfprint(sprintf('%s_%4.2f.pdf','statue',w),'Width',8.5,'Height',8.5,'Position',[0,0,8.5,8.5],'Renderer','OpenGL');
end

scene = 'discobolus';

vid = VideoWriter(sprintf('%s_dlct.avi',scene),'MPEG-4');
vid.FrameRate = 25;
open(vid);

set(gcf,'Color',[0,0,0],'Position',[680,680,256,256]);
set(gca,'CameraViewAngleMode','Manual');

for i = 1:20
   camorbit(-2.25,0,'data',[1 0 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
for i = 1:40
   camorbit(+2.25,0,'data',[1 0 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
for i = 1:20
   camorbit(-2.25,0,'data',[1 0 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
for i = 1:20
   camorbit(0,-2.25,'data',[1 0 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
for i = 1:40
   camorbit(0,+2.25,'data',[1 0 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
for i = 1:20
   camorbit(0,-2.25,'data',[1 0 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
close(vid);

