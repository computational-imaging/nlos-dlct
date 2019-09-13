function [Hx,Hy,Hz] = constructH(N,M,width,range,mu)
    % Local function to compute NLOS blur kernel
    x = linspace(-mu(1)*width,+mu(1)*width,mu(1)*N);
    y = linspace(-mu(2)*width,+mu(2)*width,mu(2)*N);
    z = linspace(0,mu(3)*range*range,mu(3)*M);
    [grid_z,grid_y,grid_x] = ndgrid(z,y,x);

    % Define PSF (scale grid_x, grid_y, grid_z to the actual range)
    h = abs(4*(grid_x.^2 + grid_y.^2) - grid_z);
    % We need a Gaussian blur here (currently does nearest neighbor)
    h = single(h == repmat(min(h,[],1),[length(z) 1 1]));
    h = h./norm(h(:));
    
    hx =-h.*grid_x;
    hx = circshift(hx,0.5*[0 length(y) length(x)]);
    Hx = fftn(hx,size(hx));
    
    hy =-h.*grid_y;
    hy = circshift(hy,0.5*[0 length(y) length(x)]);
    Hy = fftn(hy,size(hy));

    hz = h;
    hz = circshift(hz,0.5*[0 length(y) length(x)]);
    Hz = fftn(hz,size(hz));
end