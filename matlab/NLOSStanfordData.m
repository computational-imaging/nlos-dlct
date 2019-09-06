classdef NLOSStanfordData
    properties
        Filename
        DeltaT
        CameraGridSize
        Data
    end
    methods
        function ds = NLOSStanfordData(filename, varargin)
            p = inputParser;
            addRequired(p, 'filename', @ischar);
            addParameter(p, 'shifttime', false, @islogical);
            parse(p, filename, varargin{:});
            if exist(p.Results.filename, 'file') ~= 2
                error('''%s'' does not exist or is not a file\n', filename);
            end
            [filepath,filename] = fileparts(filename);
            load(fullfile(filepath,filename),'meas');
            load(fullfile(filepath,'tof.mat'),'tofgrid');

            ds.Filename = filename;
            ds.DeltaT = 3e8 * 32e-12;
            ds.CameraGridSize = 2;
            if p.Results.shifttime
                ds.Data = NLOSStanfordData.AdjustForTimeCNLOS(meas,tofgrid*(1/32));
            end
        end
    end
    methods (Static)
        function meas = AdjustForTimeCNLOS(meas,tofgrid)
        % adjust so that t=0 is when light reaches the scan surface
            if ~isempty(tofgrid)
                for ii = 1:size(meas, 1)
                    for jj = 1:size(meas,2 )
                        meas(ii, jj, :) = circshift(meas(ii, jj, :), -floor(tofgrid(ii, jj)));
                    end
                end  
            end
        end
    end
end
