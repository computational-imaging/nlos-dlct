% Local function that defines resampling operators
M = 16;
mtx = sparse([],[],[],2*M,M,M);

x = 1:2*M;
mtx(sub2ind(size(mtx),x,ceil(x/2))) = 1;
mtx  = spdiags(1./sqrt(x)',0,M.^2,M.^2)*mtx;

K = log(2)./log(2);
for k = 1:round(K)
    mtx  = 0.5.*(mtx(1:2:end,:)  + mtx(2:2:end,:));
end

