function meas = compensate_time(meas,tofgrid)

% adjust so that t=0 is when light reaches the scan surface
if ~isempty(tofgrid)
    for ii = 1:size(meas, 1)
        for jj = 1:size(meas,2 )
            meas(ii, jj, :) = circshift(meas(ii, jj, :), -floor(tofgrid(ii, jj)));
        end
    end  
end
