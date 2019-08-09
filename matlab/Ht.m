function t = Ht(t,Hz,Hx,Hy)
% x is M x N x N
    t = reshape(t,U,V,V);
    M = size(t,1); % Temporal resolution of data
    N = size(t,3); % Spatial resolution of data
    % Step 1: Resample depth axis and pad result
    % Step 2: Convolve with inverse filter and unpad result
    t = fftn(t,2*[M,N,N]);

    Hzt = ifftn(conj(Hz).*t);
    Hzt = Hzt(1:M,1:N,1:N);

    Hxt = ifftn(conj(Hx).*t);
    Hxt = Hxt(1:M,1:N,1:N);

    Hyt = ifftn(conj(Hy).*t);
    Hyt = Hyt(1:M,1:N,1:N);

    % Step 3: Resample time axis and clamp results
    t = reshape(cat(4,Hzt,Hxt,Hyt),[],1);
end
