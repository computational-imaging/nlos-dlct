function t = flt(t,H,R)
% x is M x N x N
    t = reshape(t,size(H));
    M = size(t,1); % Temporal resolution of data
    N = size(t,3); % Spatial resolution of data
    % Step 1: Resample depth axis and pad result
    % Step 2: Convolve with inverse filter and unpad result
    t = ifftn(H.*fftn(t,[M,N,N]));
    t = t(1:M,1:N,1:N);
    % Step 3: Resample time axis and clamp results
    t = reshape(t,[],1);
end
