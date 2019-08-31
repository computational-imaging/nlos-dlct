function u = blockwiener(t, Hx, Hy, Hz, lambda)
    t = fftn(t, size(Hz));
    
    Hyx = conj(Hy).*Hx;
    Hzx = conj(Hz).*Hx;
    Hzy = conj(Hz).*Hy;

    Ixx = 1./(abs(Hx).^2 + lambda);
    Lyx = Hyx.*Ixx;
    Lzx = Hzx.*Ixx;

    Iyy = 1./(abs(Hy).^2 + lambda - real(Lyx.*conj(Hyx)));
    Hzy = Hzy - Lzx.*conj(Hyx);
    Lzy = Hzy.*Iyy;

    Izz = 1./(abs(Hz).^2 + lambda - real(Lzx.*conj(Hzx)) - real(Lzy.*conj(Hzy)));

    u = zeros([size(t),3]);
    u(:,:,:,1) = conj(Hx).*t;
    u(:,:,:,2) = conj(Hy).*t - Lyx.*u(:,:,:,1);
    u(:,:,:,3) = conj(Hz).*t - Lzy.*u(:,:,:,2) - Lzx.*u(:,:,:,1);

    u(:,:,:,3) = Izz.*u(:,:,:,3);
    u(:,:,:,2) = Iyy.*u(:,:,:,2) - conj(Lzy).*u(:,:,:,3);
    u(:,:,:,1) = Ixx.*u(:,:,:,1) - conj(Lyx).*u(:,:,:,2) - conj(Lzx).*u(:,:,:,3);

    u(:,:,:,1) = real(ifftn(u(:,:,:,1)));
    u(:,:,:,2) = real(ifftn(u(:,:,:,2)));
    u(:,:,:,3) = real(ifftn(u(:,:,:,3)));
end