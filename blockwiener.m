function [ux, uy, uz] = blockwiener(tx, ty, tz, Hx, Hy, Hz, lambda)
    ux = tx;
    uy = ty - Lyx*ux;
    uz = tz - Lzx*ux - Lzy*uy;
    
    ux = Dxx*ux;
    uy = Dyy*uy;
    uz = Dzz*uz;

    uz = uz;
    uy = uy - Lyz*uz;
    ux = ux - Lxy*uy - Lxz*uz;
end