clear all; 
close all;

% spheres: 2^1

alg = 'dlct';
scene = 'statue';
snr = Inf;

load(sprintf('errors_%s_%f_%s.mat',scene,snr,alg));
load(sprintf('output_%s_%f_%s.mat',scene,snr,alg));

lambda = 2;

nlos = loaddata(scene);
%[pos, dir] = dlct(nlos,lambda, 3, [1,1,1], [1,1,1],[48,48,48]);




% img = dir(:,:,3) - min(reshape(dir(:,:,3),[],1));

posc = posarray(:,:,:,1,10);
dirc = dirarray(:,:,:,1,10);
indc = ~isinf(flipud(nlos.Depth)');

% se = strel('disk',0);
% indc = imclose(indc,se);
dlctsurf(posc,dirc,indc,4,6);

vid = VideoWriter(sprintf('%s_dlct.avi',scene),'MPEG-4');
vid.FrameRate = 25;
open(vid);


set(gcf,'Color',[0,0,0],'Position',[680,680,256,256]);
set(gca,'CameraViewAngleMode','Manual');
axis([-0.5,0.5,-0.5,0.5,-1,0])
for i = 1:20
   camorbit(+2.25,0,'data',[0 1 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
for i = 1:40
   camorbit(-2.25,0,'data',[0 1 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
for i = 1:20
   camorbit(+2.25,0,'data',[0 1 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
for i = 1:20
   camorbit(0,+2.25,'data',[0 1 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
for i = 1:40
   camorbit(0,-2.25,'data',[0 1 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
for i = 1:20
   camorbit(0,+2.25,'data',[0 1 0])
   frame = getframe(gcf,[0,0,256,256]);
   writeVideo(vid,frame);
end
close(vid);

