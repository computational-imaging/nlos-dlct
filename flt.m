function Ax = flt(x,H,R)
% x is M x N x N
    Ax = reshape(x,size(H));
    M = size(Ax,1); % Temporal resolution of data
    N = size(Ax,3); % Spatial resolution of data
    % Step 1: Resample depth axis and pad result
    if (~isempty(R))
        Ax = real(reshape(R*Ax(:,:),[M N N]));
    end
    % Step 2: Convolve with inverse filter and unpad result
    Ax = ifftn(H.*fftn(Ax,[M,N,N]));
    Ax = Ax(1:M,1:N,1:N);
    % Step 3: Resample time axis and clamp results
    if (~isempty(R))
        Ax = real(reshape(R'*Ax(:,:),[M N N]));
    end
    Ax = reshape(Ax,[],1);
end
