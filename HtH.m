function HtH_t = HtH(t,H)
    Ht = sum(H.*reshape(t,size(H)),4);
    HtH_t = reshape(conj(H).*Ht,[],1);
end
