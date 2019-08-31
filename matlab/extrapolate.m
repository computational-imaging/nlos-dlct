function V = extrapolate(V)
    padsize = 0.5*size(V);
    V = padarray(V,padsize,'replicate','both');
end