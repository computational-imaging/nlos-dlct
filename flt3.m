function t = flt3(t,Hz,Hx,Hy)
% x is M x N x N
    t = reshape(t,[size(H),3]);
    M = size(t,1); % Temporal resolution of data
    N = size(t,3); % Spatial resolution of data
    % Step 1: Resample depth axis and pad result
    % Step 2: Convolve with inverse filter and unpad result
    tz = ifftn(Hz.*fftn(t(:,:,:,1),[M,N,N]));
    tz = tz(1:M,1:N,1:N);

    tx = ifftn(Hx.*fftn(t(:,:,:,2),[M,N,N]));
    tx = tx(1:M,1:N,1:N);

    ty = ifftn(Hy.*fftn(t(:,:,:,3),[M,N,N]));
    ty = ty(1:M,1:N,1:N);

    % Step 3: Resample time axis and clamp results
    t = reshape(cat(4,tz,tx,ty),[],1);
end
