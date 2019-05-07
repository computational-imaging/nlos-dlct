function [ux, uy, uz] = blockwiener(t, Hx, Hy, Hz, lambda)
    t = fftn(t);
    tx = conj(Hx).*t;
    ty = conj(Hy).*t;
    tz = conj(Hy).*t;
    
    Hyx = conj(Hy).*Hx;
    Hzx = conj(Hz).*Hx;
    Hzy = conj(Hz).*Hy;

    Dxx = abs(Hx).^2 + lambda;
    Ixx = 1./Dxx;
    Lyx = Hyx.*Ixx;
    Lzx = Hzx.*Ixx;

    Dyy = abs(Hy).^2 + lambda - Lyx.*conj(Hyx);
    Iyy = 1./Dyy;
    Hzy = Hzy - Lzx.*conj(Hyx);
    Lzy = Hzy.*Iyy;

    Dzz = abs(Hz).^2 + lambda - Lzx.*conj(Hzx) - Lzy.*conj(Hzy);
    Izz = 1./Dzz;

    ux = tx;
    uy = ty - Lyx*ux;
    uz = tz - Lzx*ux - Lzy*uy;

    ux = Ixx*ux;
    uy = Iyy*uy;
    uz = Izz*uz;

    uz = uz;
    uy = uy - Lyz*uz;
    ux = ux - Lxy*uy - Lxz*uz;
    
    ux = real(ifftn(ux));
    uy = real(ifftn(uy));
    uz = real(ifftn(uz));
end