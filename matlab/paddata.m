function V = paddata(V)
    padsize = 0.5*[size(V,1),size(V,2)];
    V = padarray(V,padsize,'replicate','both');
    h = cell(3,1);
    for i = 1:2
        h{i} = shiftdim(exp(-(-padsize(i):padsize(i))'.^2 * (1/2/(padsize(i)/2)^2)),-i+1);
    end
    V([1:padsize(1),end-padsize(1):end],:,:) = V([1:padsize(1),end-padsize(1):end],:,:).*h{1};
    V(:,[1:padsize(2),end-padsize(2):end],:) = V(:,[1:padsize(2),end-padsize(2):end],:).*h{2};
    %V(:,:,[1:padsize(3),end-padsize(3):end]) = V(:,:,[1:padsize(3),end-padsize(3):end]).*h{3};
end