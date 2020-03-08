% NLOSSTANFORDDATA Struct for Stanford transients for use with the
% D-LCT algorithm.
%
%
%   Author:  Sean I. Young  (Stanford University)
%   Contact: sean0@stanford.edu, seannz@gmail.com
%
% Copyright 2019-2020 Stanford University, Stanford CA 94305, USA
%
%                         All Rights Reserved
%
% Permission to use, copy, modify, and distribute this software and
% its documentation for any purpose other than its incorporation into
% a commercial product is hereby granted without fee, provided that
% the above copyright notice appear in all copies and that both that
% copyright notice and this permission notice appear in supporting
% documentation, and that the name of UNSW not be used in advertising
% or publicity pertaining to distribution of the software without
% specific, written prior permission.
%
% STANFORD UNIVERSITY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
% SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR ANY PARTICULAR PURPOSE.  IN NO EVENT SHALL UNSW BE
% LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY
% DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
% WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
% ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
% OF THIS SOFTWARE.

classdef NLOSStanfordData
    properties
        Filename
        DeltaT
        CameraGridSize
        Data
        Depth
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
            load(fullfile(filepath,filename));
            ds.Filename = filename;
            if exist('meas','var')
                ds.Data = meas;
            elseif exist('data','var')
                ds.Data = data;
            elseif exist('rect_data','var')
                ds.Data = rect_data;
            elseif exist('transientsCalibrated','var')
                ds.Data = transientsCalibrated;
            end
            if p.Results.shifttime
                load(fullfile(filepath,'tof.mat'),'tofgrid');
                ds.Data = NLOSStanfordData.AdjustForTimeCNLOS(ds.Data,tofgrid*(1/32));
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
