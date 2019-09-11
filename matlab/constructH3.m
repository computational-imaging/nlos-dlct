function [Hx,Hy,Hz] = constructH3(N,M,width,range)
    % Local function to compute NLOS blur kernel
    x = linspace(-width,+width,N);
    y = linspace(-width,+width,N);
    z = linspace(0,range*range,M);
    [grid_z,grid_y,grid_x] = ndgrid(z,y,x);

    % Define PSF (scale grid_x, grid_y, grid_z to the actual range)
    h = abs(4*(grid_x.^2 + grid_y.^2) - grid_z);
    % We need a Gaussian blur here (currently does nearest neighbor)
    h = single(h == repmat(min(h,[],1),[length(z) 1 1]));
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
end

