function R = constructR(M)
 % Local function that defines resampling operators
     R = sparse([],[],[],M.^2,M,M.^2);
     x = 1:M.^2;
     R(sub2ind(size(R),x,ceil(sqrt(x)))) = 1;
     R = spdiags(1./sqrt(x)',0,M.^2,M.^2)*R;
     R = R .* (M/sum(R(:)));
     for k = 1:round(log(M)/log(2))
         R = (R(1:2:end,:) + R(2:2:end,:));
     end
     R = full(R);
end