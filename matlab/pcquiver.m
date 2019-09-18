function pcquiver(pos,dir,mask)
if nargin < 3
    mask = double(dir(:,:,3)>0.4e-5);
    mask(mask == 0) = NaN;
end
pos = pos(:,:,[3,1,2]).*mask;
pos(:,:,[2,3]) = -pos(:,:,[2,3]);
% pcshow(pos);
% colormap(inferno);

mask = ~isnan(mask);
dir = -dir(:,:,[3,1,2]).*mask;
hold on;
pos = reshape(pos,[],3);
dir = reshape(dir,[],3);
hold on;
colormap(inferno);
quiver3c(pos(mask,1),pos(mask,2),pos(mask,3),dir(mask,1),dir(mask,2),dir(mask,3),1.25);

axis equal;
% axis off;
grid on;
view(-45,35);
set(gca,'zcolor','white');
set(gca,'ycolor','white');
set(gca,'xcolor','white');
set(gca,'GridColor',[0,0,0]);
set(gcf,'Color','none');
set(gca,'Color',[1,1,1]);
set(gca,'ZColor',[0,0,0]);
set(gca,'YColor',[0,0,0]);
set(gca,'XColor',[0,0,0]);

axis([0.0,0.8,-0.4,0.4,-0.4,0.4]);
zticks([-0.4,0.4]);
yticks([-0.4,0.4]);
xticks([0,0.8]);
zticklabels({0,2});
yticklabels({0});
xticklabels({});
axis off;
camproj('perspective');

pdfprint('temp.pdf','Width',10.5,'Height',10.5,'Position',[-3.5,-2.5,15.5,15.5],'Renderer','Painters','Resolution',600);
end