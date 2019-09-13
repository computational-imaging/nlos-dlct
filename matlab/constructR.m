function [Rx,Rz] = constructR(M,range)
% Local function that defines resampling operators
     R = sparse([],[],[],M^2,M,M^2);
     x = 1:M^2;
     R(sub2ind(size(R),x,ceil(sqrt(x)))) = 1;
     Rx = spdiags((M/range)./sqrt(x)',0,M^2,M^2)*R;
     Rz = 0.5*R;
     for k = 1:round(log2(M))
         Rx = (Rx(1:2:end,:) + Rx(2:2:end,:));
         Rz = (Rz(1:2:end,:) + Rz(2:2:end,:));
     end
     Rx = full(Rx);
     Rz = full(Rz);
     nf = 1/norm(blkdiag(Rx,Rz));
     Rx = Rx * nf;
     Rz = Rz * nf;
end