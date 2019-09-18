close all;
close all; 

scenes = {'serapis1.0'};

for s = 1:length(scenes)
    scene = scenes{s};
    nlos = loaddata(scene);
    [pos,dir] = dlct(nlos,2);
    lim = zeros(3,2);
    lim(1:2,2) = max(reshape(abs(dir(:,:,1:2)),[],1));
    lim(1:2,1) = -lim(1:2,2);
    lim(3:3,2) = max(reshape(abs(dir(:,:,3:3)),[],1));
    lim(3:3,1) = -lim(3:3,2);

    for i = 1:3
        vis(dir(:,:,i));
        caxis([lim(i,1),lim(i,2)]);
        colormap(gray);
        pdfprint(sprintf('%s_%d.pdf',scene,i),'Width',8.5,'Height',8.5,'Position',[0,0,8.5,8.5]);
    end
end