function pcsurf(data)
    [W,H,D] = size(data);
    S = double(data ~= 0);
    S(S==0) = NaN;
    [~,z] = min(S,[],3);
    z = reshape(repmat(z,[1,1,size(data,3)]),[],1);
    [X,Y,Z] = ndgrid(1:size(data,1),1:size(data,2),1:size(data,3));

    ind = find(((X(:) == 1 | X(:) == W  | ...
                 Y(:) == 1 | Y(:) == H  | ...
                 Z(:) == z | Z(:) == D)) & ~isnan(S(:)));
    [X,Y,Z] = ind2sub(size(data),ind);
    

    col = sub2ind(size(data),X,Y,min(512,Z+1));
    [X,Y,Z] = meshgrid(1:size(data,1),1:size(data,2),1:size(data,3));
    pcshow([Z(ind),Y(ind),X(ind)],log(data(col)),'MarkerSize',16);
    colormap(inferno);
    zticks([1,128,256]);
    yticks([1,128,256]);
    xticks([256,512]);
    zticklabels({'$-1$','$0$','$1$'})
    yticklabels({'$-1$','$0$','$1$'})
    xticklabels({'$T/2$','$T$'});
    view(-45,30);
    axis square;
    set(gca,'zcolor','white');
    set(gca,'ycolor','white');
    set(gca,'xcolor','white');
    set(gca,'GridColor','white');
    %axis off;
    pdfprint('temp.pdf','Width',10.5,'Height',10.5,'Position',[1.5,1.5,8.0,8.0],'Renderer','Zbuffer');
end