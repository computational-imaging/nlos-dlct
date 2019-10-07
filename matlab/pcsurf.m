function pcsurf(data)
    [W,H,D] = size(data);
    S = double(data ~= 0);
    S(S==0) = NaN;
    [~,z] = min(S,[],3);
    z = reshape(repmat(z,[1,1,size(data,3)]),[],1);
    [X,Y,Z] = ndgrid(1:size(data,1),1:size(data,2),1:size(data,3));

    ind = find(~isnan(S(:)));
    [X,Y,Z] = ind2sub(size(data),ind);
    

    col = sub2ind(size(data),X,Y,min(512,Z+1));
    [X,Y,Z] = meshgrid(1:size(data,1),1:size(data,2),1:size(data,3));
    pcshow([Z(ind),Y(ind),X(ind)],min(0.05,data(col).^0.5),'MarkerSize',4);
    colormap(gray);
    zticks([1,256]);
    yticks([1,256]);
    xticks([128,512]);
    zticklabels({'$0$','$1$'})
    yticklabels({'$0$','$1$'})
    xticklabels({'$0$','$2$'});
    view(-45,30);
    box on; 
    axis square;
    axis([128,512,1,256,1,256]);
    set(gca,'zcolor','white');
    set(gca,'ycolor','white');
    set(gca,'xcolor','white');
    set(gca,'BoxStyle','full');
    set(gca,'GridColor',[1,1,1]);
    set(gcf,'Color',[1,1,1]);
    set(gca,'Color',[0,0,0]);
    set(gca,'ZColor',[0,0,0]);
    set(gca,'YColor',[0,0,0]);
    set(gca,'XColor',[0,0,0]);
    camproj('perspective');
    axis off;
    %pdfprint('temp.pdf','Width',10.5,'Height',10.5,'Position',[0.75,1,9.5,9.5],'Renderer','OpenGL');
end