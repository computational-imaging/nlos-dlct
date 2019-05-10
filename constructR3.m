function [Rx,Ry,Rz] = constructR3(M)
 % Local function that defines resampling operators
     R1 = sparse([],[],[],M.^2,M,M.^2);
     x = 1:M.^2;
     R1(sub2ind(size(R1),x,ceil(sqrt(x)))) = 1;
     R2 = R1;
     R1 = spdiags(1./sqrt(x)',0,M.^2,M.^2)*R1;
     R1 = R1 .* (M/sum(R1(:)));
     R2 = R2 .* (M/sum(R2(:)));
     for k = 1:round(log(M)/log(2))
         R1 = (R1(1:2:end,:) + R1(2:2:end,:));
         R2 = (R2(1:2:end,:) + R2(2:2:end,:));
     end
     Rx = full(R1);
     Ry = Rx;
     Rz = full(R2);
end