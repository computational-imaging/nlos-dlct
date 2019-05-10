function H = contructH3(N,M,slope)
    % Local function to compute NLOS blur kernel
    x = linspace(-2,2,2*N);
    y = linspace(-2,2,2*N);
    z = linspace(0,2,2*M);
    [grid_z,grid_y,grid_x] = ndgrid(z,y,x);

    % Define PSF (scale grid_x, grid_y, grid_z to the actual range)
    h = abs(((4.*slope).^2).*(grid_x.^2 + grid_y.^2) - 4.*grid_z);
    % We need a Gaussian blur here (currently does nearest neighbor)
    h = double(h == repmat(min(h,[],1),[length(z) 1 1]));
    h = h./norm(h(:));
    
    hx =-h.*grid_x;
    hx = circshift(hx,0.5*[0 length(y) length(x)]);
    Hx = fftn(hx);
    
    hy =-h.*grid_y;
    hy = circshift(hy,0.5*[0 length(y) length(x)]);
    Hy = fftn(hy);

    hz = h;
    hz = circshift(hz,0.5*[0 length(y) length(x)]);
    Hz = fftn(hz);
    
    H = cat(4,Hz,Hx,Hy);
end

