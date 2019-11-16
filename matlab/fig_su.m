close all;
mask = sqrt(sum(vol(:,:,:,3).^2,4)) > 0.14;
%volumeViewer(mask.*vol(:,:,:,3),'ScaleFactors',[1,1,64/512])
[posx,posy,posz] = meshgrid(linspace(-0.35,0.35,64),linspace(-0.35,0.35,64),...
                            linspace(0,1.2288,512));
pos3 = cat(4,posx,posy,posz);
dlctsurf3(pos3,vol,mask,4,6);
axis([-0.35,0.35,-0.35,0.35,-1.5,-0.5]);
camproj('orthographic');
set(gcf,'Color',0.95*[1,1,1]);
pdfprint('temp.pdf','Width',8.5,'Height',8.5,'Position',[0,0,8.5,8.5],'Renderer','OpenGL');