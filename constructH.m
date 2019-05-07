function [H,Hx,Hy] = constructH(N,M,slope)
    % Local function to compute NLOS blur kernel
    x = linspace(-1,1,N);
    y = linspace(-1,1,N);
    z = linspace(0,1,M);
    [grid_z,grid_y,grid_x] = ndgrid(z,y,x);

    % Define PSF (scale grid_x, grid_y, grid_z to the actual range)
    h = abs(((4.*slope).^2).*(grid_x.^2 + grid_y.^2) - 4.*grid_z);
    % We need a Gaussian blur here (currently does nearest neighbor)
    h = double(h == repmat(min(h,[],1),[length(z) 1 1]));
    h = h./norm(h(:));
    h = circshift(h,0.5*[0 length(y) length(x)]);
    H = fftn(h);
end

