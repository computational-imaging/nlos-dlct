classdef NLOSData
    %% NLOSData  load and use nlos data from hdf5 or mat files
    %
    %   NLOSDATA = NLOSData(FILENAME)
    %   NLOSDATA = NLOSData(FILENAME, KEY, VALUE)
    %
    %   NLOSDATA = NLOSData(FILENAME) loads all the data from FILENAME as
    %   is, without any processing done on it. It can all be accessed from
    %   the public properties in the instance.
    %
    %   NLOSDATA = NLOSData(FILENAME, KEY, VALUE) loads all the data from
    %   FILENAME applying the chosen processes from the KEY VALUE pairs.
    %   Parameter Value Pairs
    %   ---------------------
    %       'bounces'       - May be the string 'all' or 'sum', or a single
    %                         value indicating the bounce to read. For .mat
    %                         files only the 'all' value can be used and the
    %                         bounces must be separated manually.
    %       'shifttime'     - Boolean value. If true, Data will be shifted in
    %                         time according to the distance from the recorded
    %                         point and the spad and the laser source. This is
    %                         a preprocessing necessary for CNLOS.
    %       'gaussianSNR'   - SNR value for added gaussian noise. Ignored
    %                         if the value is Inf, otherwise noise will be
    %                         added so that the resulting SNR is VALUE.
    %                         This will be applied after blurring.
    
    properties
        Filename
        
        Data
        Depth
        Normal
        DeltaT
        TimeOffset

        CameraGridPositions
        CameraGridNormals
        CameraPosition
        CameraGridPoints
        CameraGridSize
        
        LaserGridPositions
        LaserGridNormals
        LaserPosition
        LaserGridPoints
        LaserGridSize
        
        HiddenVolumePosition
        HiddenVolumeRotation
        HiddenVolumeSize
        
        IsConfocal
    end
    properties (Access=private)
        engine
        data_order
        needs_permute
    end
    properties (Constant = true, Access=private)
        CAM_GRID_POINT_POSITIONS = {'cameraGridPositions', 'cameraPos'};
        CAM_GRID_POINT_NORMALS = {'cameraGridNormals', 'cameraNormal'};
        CAM_POSITION = {'cameraPosition', 'cameraOrigin'};
        CAM_GRID_POINTS = {'cameraGridPoints'};
        CAM_GRID_SIZE = {'cameraGridSize', 'camera_grid_size'};
        
        LASER_GRID_POINT_POSITIONS = {'laserGridPositions', 'laserPos'};
        LASER_GRID_POINT_NORMALS = {'laserGridNormals', 'laserNorm'};
        LASER_POSITION = {'laserPosition', 'laserOrigin'};
        LASER_GRID_POINTS = {'laserGridPoints'};
        LASER_GRID_SIZE = {'laserGridSize', 'laser_grid_size'};
        
        DATA = {'data'};
        DELTA_T = {'deltaT', 'deltat'};
        T0 = {'t0'};
        T = {'t'};
        HIDDEN_VOLUME_POSITION = {'hiddenVolumePosition', 'hidden_volume_pos'};
        HIDDEN_VOLUME_ROTATION = {'hiddenVolumeRotation', 'hidden_volume_rot'};
        HIDDEN_VOLUME_SIZE = {'hiddenVolumeSize', 'hidden_volume_size'};
        IS_CONFOCAL = {'isConfocal'}
    end

    methods (Access=private)
        function [value, success] = readField(ds, datasetNames, start, count)
            % readField Reads a dataset from disk.
            value = false;
            [fsize, success] = ds.fieldSize(datasetNames);
            if success{1}
                if nargin < 3
                    % Start reading the field from the beggining
                    start = ones(1,length(fsize));
                end
                if nargin < 4
                    % Read the field to the end
                    count = inf(1,length(fsize));
                end
                if ds.needs_permute
                    start = flip(start);
                    count = flip(count);
                end
                value = double(h5read(ds.Filename, success{2}, start, count));
            end
            if ds.needs_permute
                value = permute(value, length(size(value)):-1:1);
                fsize(flip(count)==1) = 1;
            else
                fsize(count==1) = 1;
            end
            if length(size(value)) < length(fsize)
                value = reshape(value, fsize);
            end
        end
        
        function [value, success] = fieldSize(ds, datasetNames, dim)
            % fieldSize Reads the size of a dataset from disk.
            if class(datasetNames) ~= 'cell'
                datasetNames = {datasetNames};
            end
            for i = 1:length(datasetNames)
                dsname = ['/' char(datasetNames{i})];
                try
                    value = h5info(ds.Filename, dsname);
                    success{1} = true;
                    success{2} = dsname;
                    if nargin > 2
                        if ds.needs_permute
                            dim = length(value.Dataspace.Size) - dim + 1;
                        end
                        value = value.Dataspace.Size(dim);
                    else
                        value = value.Dataspace.Size;
                    end
                    break;
                catch
                    value = false;
                    success{1} = false;
                    success{2} = false;
                end
            end
            if ds.needs_permute
                value = flip(value);
            end
        end
    end
    
    methods
        function ds = NLOSData(filename, varargin)
            % Parse varargin
            p = inputParser;
            addRequired(p, 'filename', @ischar);
            addParameter(p, 'bounces', 'all', @(x) any(strcmp(x, {'all', 'sum'})) || isfloat(x));
            addParameter(p, 'blur', [], @isfloat);
            addParameter(p, 'shifttime', false, @islogical);
            addParameter(p, 'gaussianSNR', inf, @isnumeric);
            parse(p, filename, varargin{:});
            
            if exist(p.Results.filename, 'file') ~= 2
                error('''%s'' does not exist or is not a file\n', filename);
            end
            
            ds.Filename = filename;
            if ~any(contains(ds.Filename, {'.hdf5', '.h5', '.mat'}))
                error('''%s'' does not exist or is not in a valid format\n', filename);
            end
            % Check how the data was written.
            try
                ds.data_order = h5readatt(filename, '/', 'data order');
                ds.needs_permute = strcmp(ds.data_order, 'row-major');
            catch
                ds.data_order = '';
                ds.needs_permute = false;
            end
            try 
                ds.engine = h5readatt(filename, '/', 'engine');
                ds.engine = ds.engine{1};
            catch
                ds.engine = '';
            end
            
            [ds.DeltaT, ok] = ds.readField(ds.DELTA_T);
            if ~ok{1}
                error('%s is not a valid dataset\n', filename);
            end

            [ds.TimeOffset, ok] = ds.readField(ds.T0);
            if ~ok{1}
                error('%s is not a valid dataset\n', filename);
            end
            
            ds.HiddenVolumePosition = ds.readField(ds.HIDDEN_VOLUME_POSITION);
            ds.HiddenVolumeRotation = ds.readField(ds.HIDDEN_VOLUME_ROTATION);
            ds.HiddenVolumeSize = ds.readField(ds.HIDDEN_VOLUME_SIZE);
            ds.IsConfocal = ds.ReadIsConfocal();
            if p.Results.bounces == 0
                ds.Data = 0;
            else
                ds.Data = ds.ReadData(p.Results.bounces, p.Results.shifttime, ...
                    p.Results.gaussianSNR, p.Results.blur);
            end
            ds.CameraGridPositions = ds.ReadCameraGridPositions();
            ds.CameraGridNormals = ds.ReadCameraGridNormals();
            ds.CameraPosition = ds.readField(ds.CAM_POSITION);
            ds.CameraGridPoints = ds.readField(ds.CAM_GRID_POINTS);
            if ds.CameraGridPoints == 0
                % if it's not defined take the value from the laser grid
                ds.CameraGridPoints = size(ds.CameraGridPositions);
                ds.CameraGridPoints = ds.CameraGridPoints(1:end-1);
                if length(ds.CameraGridPoints) > 1 &&...
                        ds.CameraGridPoints(1) == ds.CameraGridPoints(2)
                    ds.CameraGridPoints = ds.CameraGridPoints(1);
                end
            end
            ds.CameraGridSize = ds.ReadCameraGridSideLength();
            
            ds.LaserGridPositions = ds.ReadLaserGridPositions();
            ds.LaserGridNormals = ds.ReadLaserGridNormals();
            ds.LaserPosition = ds.readField(ds.LASER_POSITION);
            ds.LaserGridPoints = ds.readField(ds.LASER_GRID_POINTS);
            if ds.LaserGridPoints == 0
                % if it's not defined take the value from the laser grid
                ds.LaserGridPoints = size(ds.LaserGridPositions);
                ds.LaserGridPoints = ds.LaserGridPoints(1:end-1);
                if length(ds.LaserGridPoints) > 1 &&...
                        ds.LaserGridPoints(1) == ds.LaserGridPoints(2)
                    ds.LaserGridPoints = ds.LaserGridPoints(1);
                end
            end
            ds.LaserGridSize = ds.ReadLaserGridSideLength();
        end
        
        function conf = ReadIsConfocal(ds)
            [conf, exists] = ds.readField(ds.IS_CONFOCAL);
            if exists{1}
                return;
            end
            if fieldSize(ds, ds.CAM_GRID_SIZE) ~= fieldSize(ds, ds.LASER_GRID_SIZE)
                return
            end
            dsize = fieldSize(ds, ds.DATA);
            gsize = fieldSize(ds, ds.CAM_GRID_POINT_POSITIONS, 1);
            if ~all(abs(readField(ds, ds.CAM_GRID_POINT_POSITIONS) -...
                    readField(ds, ds.LASER_GRID_POINT_POSITIONS))<1e-3)
                return
            end
            if dsize(1) == dsize(2) && sqrt(gsize) == dsize(1)
                conf = true;
            end
        end
        
        function glength = ReadLaserGridSideLength(ds)
            % LaserGridSideLength   Retrieve the length of the sides of the
            % laser grid
            glength = ds.readField(ds.LASER_GRID_SIZE);
            if length(glength) > 1
                if glength(1) == glength(2)
                    glength = glength(1);
                end
            else
                % Computed since older datasets may have wrong side length
                % values
                actual_pos = ds.ReadLaserGridPositions;
                glength = abs(2*actual_pos(1,1,1));
            end
        end
        
        function glength = ReadCameraGridSideLength(ds)
            % GridSideLength   Retrieve the length of the sides of the
            % captured grid
            glength = ds.readField(ds.CAM_GRID_SIZE);
            if length(glength) > 1
                if glength(1) == glength(2)
                    glength = glength(1);
                end
            else
                % Computed since older datasets may have wrong side length
                % values
                actual_pos = ds.CameraGridPositions;
                glength = abs(2*actual_pos(1,1,1));
            end
        end
        
        function data = ReadData(ds, bounces, adjustTimeForCNLOS, gaussianNoiseSNR, blurBounces)
            % Data   Retrieve transient measurements
            %   Data returns a matrix containing the transient volume
            %   measurements.
            %   The shape of the data follows (n_grid_points_y, n_grid_points_x,
            %   n_bounces, time_resolution). If you choose to retrieve a single
            %   bounce, the bounce dimension will be squeezed.
            %   data(1) will correspond to the first recorded radiance for the
            %   corresponding bounce on top-left spad point.
            %
            %   When simulating, a virtual point camera is placed on the wall
            %   recording the bounces. This is why the first bounce is left
            %   blank and why all subsequent bounces will appear before they
            %   would in the scene. Therefore, the second bounce (data(:,:,2,:))
            %   contains radiance from the first bounce from the hidden
            %   geometry.
            %
            %
            %   data = ds.Data(BOUNCES) retrieves the selected BOUNCES, which
            %   can be:
            %       'all'         - Retrieves all bounces, returning the
            %                       4-dimensional matrix specified above.
            %       'sum'         - Adds up all bounces, returning a
            %                       3-dimensional matrix
            %       [integer]     - Retrieves the selected bounces.
            %
            %   For .mat files, 'all' bounces will always be selected,
            %   failing if anything else is specified.
            %
            %   If gaussianNoiseSNR is specified and not Inf, gaussian
            %   noise with the selected SNR will be added to the data.
            
            if nargin < 2
                bounces = 'all';
            end
            if nargin < 3
                adjustTimeForCNLOS = false;
            end
            if nargin < 4
                gaussianNoiseSNR = inf;
            end
            if nargin < 5
                blurBounces = [];
            end
            function newData = quickRead(readBegin, mask)
                newData = ds.readField(ds.DATA, readBegin, mask);
                if ~isempty(readBegin(readBegin ~= 1)) && any(readBegin(readBegin ~= 1) == blurBounces)
                    newData = imgaussfilt3(squeeze(newData), 2);
                end
            end
            dsize = ds.fieldSize(ds.DATA);
            if ischar(bounces)
                switch bounces
                    case 'all'
                        data = ds.readField(ds.DATA);
                    case 'sum'
                        % Don't read the first bounce (it's empty) and sum
                        % the rest (one by one to avoid creating huge
                        % matrices)
                        if length(dsize) == 4
                            data = zeros(dsize(1),dsize(2), 1,dsize(4));
                            for i = 2:dsize(3)
                                data = data + quickRead( [1,1,i,1], [inf,inf,1,inf]);
                            end
                        elseif length(dsize) == 5
                            data = zeros(dsize(1),dsize(2), 1,dsize(4),dsize(5));
                            for i = 2:dsize(3)
                                data = data + quickRead( [1,1,i,1,1], [inf,inf,1,inf,inf]);
                            end
                        elseif length(dsize) == 6
                            data = zeros(dsize(1),dsize(2),dsize(3),dsize(4), 1,dsize(6));
                            for i = 2:dsize(5)
                                data = data + quickRead([1,1,1,1,i,1], [inf,inf,inf,inf,1,inf]);
                            end
                        elseif length(dsize) == 7
                            data = zeros(dsize(1),dsize(2),dsize(3),dsize(4), 1,dsize(6),dsize(7));
                            for i = 2:dsize(5)
                                data = data + quickRead( [1,1,1,1,i,1,1], [inf,inf,inf,inf,1,inf,inf]);
                            end
                        end
                    otherwise
                        if contains(ds.Filename, '.mat')
                            error(['Cannot retrieve single bounce form mat file.\n'...
                                'You can still retrieve all values and slice them yourself\n']);
                        end
                        fprintf('Unknown parameter %s\n', bounces);
                end
            else
                switch length(dsize)
                    case 4
                        data = zeros(dsize(1),dsize(2),length(bounces), dsize(4));
                        for i = 1:length(bounces)
                            data(:,:,i,:) = quickRead( [1,1,bounces(i),1],[Inf, Inf, 1,Inf]);
                        end                        
                    case 5
                        data = zeros(dsize(1),dsize(2),length(bounces), dsize(4),dsize(5));
                        for i = 1:length(bounces)
                            data(:,:,i,:,:) = quickRead( [1,1,bounces(i),1,1],[Inf, Inf, 1,Inf,Inf]);
                        end
                    case 6
                        data = zeros(dsize(1),dsize(2),dsize(3),dsize(4), length(bounces), dsize(6));
                        for i = 1:length(bounces)
                            data(:,:,:,:,i,:) = quickRead( [1,1,1,1,bounces(i),1], [Inf, Inf, Inf, Inf, 1, Inf]);
                        end
                    case 7
                        data = zeros(dsize(1),dsize(2),dsize(3),dsize(4), length(bounces), dsize(6), dsize(7));
                        for i = 1:length(bounces)
                            data(:,:,:,:,i,:,:) = quickRead( [1,1,1,1,bounces(i),1,1], [Inf, Inf, Inf, Inf, 1, Inf, Inf]);
                        end
                end
            end
            
            [cam_grid_pos, f_ud, f_lr] = ds.ReadCameraGridPositions;
            
            % Make sure the data matches the grid 
            if f_ud
                data = flip(data,2);
            end
            if f_lr
                data = flip(data,1);
            end
            
            dsize = size(data);
            if ~isinf(gaussianNoiseSNR)
                switch length(dsize)
                    case 6
                        for b = 1:dsize(5)
                            for sy = 1:dsize(1)
                                for sx = 1:dsize(2)
                                    for ly = 1:dsize(3)
                                        data(sy, sx, ly,:,b,:) = abs(awgn(squeeze(data(sy, sx, ly,:,b,:)), gaussianNoiseSNR, 'measured'));
                                    end
                                end
                            end
                        end
                    case 4
                        for b = 1:dsize(3)
                            for sly = 1:dsize(1)
                                data(sly,:,b,:) = abs(awgn(squeeze(data(sly,:,b,:)), gaussianNoiseSNR, 'measured'));
                            end
                        end
                    otherwise
                        warning('Invalid data size found while adding noise\n');
                end
            end
            
            if adjustTimeForCNLOS
                [laser_grid_pos, ~, ~] = ds.ReadLaserGridPositions;
                switch length(dsize)
                    case 6
                        warning('Shifting time for non-CNLOS data');
                        for b = 1:size(data, 5)
                            for sy = 1:dsize(1)
                                for sx = 1:dsize(2)
                                    data(sy,sx,:,:,b,:) = NLOSData.AdjustForTimeCNLOS(...
                                        data(sy,sx,:,:,b,:), ds.DeltaT, cam_grid_pos, ...
                                        readField(ds, ds.CAM_POSITION), laser_grid_pos,...
                                        readField(ds, ds.LASER_POSITION));
                                end
                            end
                        end
                    case 4
                        % Adjust time on each bounce
                        for b = 1:size(data, 3)
                            data(:,:,b,:) = NLOSData.AdjustForTimeCNLOS(...
                                data(:,:,b,:), ds.DeltaT, cam_grid_pos, ...
                                readField(ds, ds.CAM_POSITION), laser_grid_pos,...
                                readField(ds, ds.LASER_POSITION));
                        end
                end
            end
            % Remove singleton bounce dimension
            if dsize(end-1) == 1
                dsize(end-1) = [];
                data = reshape(data, dsize);
            end
            
            if ~ds.IsConfocal && length(size(data)) < 5
                data = reshape(data, [sqrt(size(data,1)),sqrt(size(data,1)),...
                    sqrt(size(data,2)), sqrt(size(data,2)), size(data,3), size(data,4)]);
            end
        end
        
        function [cgpos, varargout] = ReadCameraGridPositions(ds)
            cgpos = readField(ds, ds.CAM_GRID_POINT_POSITIONS);
            if numel(cgpos) == 3
                % Single camera setup, but may have wrong shape.
                cgpos = reshape(cgpos, [1,1,3]);
            end
            if length(size(cgpos)) == 2 
                dataSize = ds.fieldSize(ds.DATA);
                y = dataSize(2);
                x = dataSize(1);
                if ~ds.ReadIsConfocal()
                    x = sqrt(x);
                    y = sqrt(y);
                end
                cgpos = reshape(cgpos, [y, x, 3]);
                cgpos = permute(cgpos, [2,1,3]);
            end
            varargout = {false, false};
            % Check if the z-axis is correctly positioned
            if cgpos(1,1,3) > cgpos(end,end,3)
                cgpos = flip(cgpos, 2);
                varargout{1} = true;
            end
            % Check if the x-axis is correctly positioned
            if cgpos(1,1,1) > cgpos(end,end,1)
                cgpos = flip(cgpos, 1);
                varargout{2} = true;
            end
        end
        
        function [cgnorm] = ReadCameraGridNormals(ds)
            [~, fud, flr] = ds.ReadCameraGridPositions;
            cgnorm = readField(ds, ds.CAM_GRID_POINT_NORMALS);
            if numel(cgnorm) == 3
                % Single camera setup, but may have wrong shape.
                cgnorm = reshape(cgnorm, [1,1,3]);
            end
            if length(size(cgnorm)) == 2
                dataSize = ds.fieldSize(NLOSData.DATA);
                x = dataSize(2);
                y = dataSize(1);
                if ~ds.ReadIsConfocal
                    x = sqrt(x);
                    y = sqrt(y);
                end
                cgnorm = reshape(cgnorm, [y, x, 3]);
                cgnorm = permute(cgnorm, [2,1,3]);
            end
            if fud
                cgnorm = flip(cgnorm,2);
            end
            if flr
                cgnorm = flip(cgnorm,1);
            end
        end
        
        function [lgpos, varargout] = ReadLaserGridPositions(ds)
            lgpos = readField(ds, ds.LASER_GRID_POINT_POSITIONS);
            if numel(lgpos) == 3
                lgpos = reshape(lgpos, [1,1,3]);
            end
            if length(size(lgpos)) == 2
                dataSize = ds.fieldSize(NLOSData.DATA);
                x = dataSize(2);
                y = dataSize(1);
                if ~ds.ReadIsConfocal
                    x = sqrt(x);
                    y = sqrt(y);
                end
                lgpos = reshape(lgpos, [y, x, 3]);
                lgpos = permute(lgpos, [2,1,3]);
            end
            varargout = {false, false};
            if lgpos(1,1,3) > lgpos(end,end,3)
                lgpos = flip(lgpos,2);
                varargout{1} = true;
            end
            if lgpos(1,1,1) > lgpos(end,end,1)
                lgpos = flip(lgpos,1);
                varargout{2} = true;
            end
        end
        
        function [lgnorm] = ReadLaserGridNormals(ds)
            [~, fud, flr] = ds.ReadCameraGridPositions;
            lgnorm = readField(ds, ds.LASER_GRID_POINT_NORMALS);
            if numel(lgnorm) == 3
                lgnorm = reshape(lgnorm, [1,1,3]);
            end
            if length(size(lgnorm)) == 2
                dataSize = ds.fieldSize(NLOSData.DATA);
                x = dataSize(2);
                y = dataSize(1);
                if ~ds.ReadIsConfocal
                    x = sqrt(x);
                    y = sqrt(y);
                end
                lgnorm = reshape(lgnorm, [y, x, 3]);
                lgnorm = permute(lgnorm, [2,1,3]);
            end
            if fud
                lgnorm = flip(lgnorm,2);
            end
            if flr
                lgnorm = flip(lgnorm,1);
            end
        end
        
        function ViewSetup(ds, hposition, hsize)
            figure(); hold on;
            axis equal;
            
            gpos = double(ds.ReadLaserGridPositions);
            gpos = reshape(gpos, [size(gpos,1)*size(gpos,2), 3]);
            
            scatter3(gpos(:,1), gpos(:,2), gpos(:,3),'r.');
            
            gpos = ds.ReadCameraGridPositions;
            gpos = reshape(gpos, [size(gpos,1)*size(gpos,2), 3]);
            scatter3(gpos(:,1), gpos(:,2), gpos(:,3),'b.');
            
            c = ds.CameraPosition;
            
            scatter3(c(1), c(2), c(3));
            
            if nargin < 2
                hposition = ds.readField(ds.HIDDEN_VOLUME_POSITION);
            end
            if nargin < 3
                hsize = ds.readField(ds.HIDDEN_VOLUME_SIZE);
            end
                
            cube_plot(hposition - hsize(1)/2, hsize(1), hsize(1), hsize(1), 'w');
        end
        
        function Info(ds)
            fprintf('Filename %s\n', ds.Filename);
            fprintf(['\tData size [' repmat('%d ', 1, length(size(ds.Data))) ']\n'], size(ds.Data));
            fprintf(['\tDeltaT size [' repmat('%d ', 1, length(size(ds.DeltaT))) ']\n'], size(ds.DeltaT));
            fprintf(['\tTimeOffset size [' repmat('%d ', 1, length(size(ds.TimeOffset))) ']\n'], size(ds.TimeOffset));
            fprintf(['\tCameraGridPositions size [' repmat('%d ', 1, length(size(ds.CameraGridPositions))) ']\n'], size(ds.CameraGridPositions));
            fprintf(['\tCameraGridNormals size [' repmat('%d ', 1, length(size(ds.CameraGridNormals))) ']\n'], size(ds.CameraGridNormals));
            fprintf(['\tCameraPosition size [' repmat('%d ', 1, length(size(ds.CameraPosition))) ']\n'], size(ds.CameraPosition));
            fprintf(['\tCameraGridPoints size [' repmat('%d ', 1, length(size(ds.CameraGridPoints))) ']\n'], size(ds.CameraGridPoints));
            fprintf(['\tCameraGridSize size [' repmat('%d ', 1, length(size(ds.CameraGridSize))) ']\n'], size(ds.CameraGridSize));
            fprintf(['\tLaserGridPositions size [' repmat('%d ', 1, length(size(ds.LaserGridPositions))) ']\n'], size(ds.LaserGridPositions));
            fprintf(['\tLaserGridNormals size [' repmat('%d ', 1, length(size(ds.LaserGridNormals))) ']\n'], size(ds.LaserGridNormals));
            fprintf(['\tLaserPosition size [' repmat('%d ', 1, length(size(ds.LaserPosition))) ']\n'], size(ds.LaserPosition));
            fprintf(['\tLaserGridPoints size [' repmat('%d ', 1, length(size(ds.LaserGridPoints))) ']\n'], size(ds.LaserGridPoints));
            fprintf(['\tLaserGridSize size [' repmat('%d ', 1, length(size(ds.LaserGridSize))) ']\n'], size(ds.LaserGridSize));
            fprintf(['\tHiddenVolumePosition size [' repmat('%d ', 1, length(size(ds.HiddenVolumePosition))) ']\n'], size(ds.HiddenVolumePosition));
            fprintf(['\tHiddenVolumeRotation size [' repmat('%d ', 1, length(size(ds.HiddenVolumeRotation))) ']\n'], size(ds.HiddenVolumeRotation));
            fprintf(['\tHiddenVolumeSize size [' repmat('%d ', 1, length(size(ds.HiddenVolumeSize))) ']\n'], size(ds.HiddenVolumeSize));
            fprintf(['\tIsConfocal size [' repmat('%d ', 1, length(size(ds.IsConfocal))) ']\n'], size(ds.IsConfocal));
        end
    end
    
    methods (Static)
        function data = AdjustForTimeCNLOS(data, deltaT, camera_grid_positions, camera_position, laser_grid_positions, laser_position)
            % AdjustForTimeCNLOS Shifts the transient volume so that t0 is
            % the same for all point captures.
            
            if nargin < 6
                laser_grid_positions = camera_grid_positions;
                laser_position = camera_position;
            end
            data = squeeze(data);
            
            cdist = sqrt(sum((camera_grid_positions - reshape(camera_position,[1,1,3])).^2,3));
            ldist = sqrt(sum(( laser_grid_positions - reshape( laser_position,[1,1,3])).^2,3));
            tdist = ceil((cdist + ldist) * (1/deltaT));

            for j = 1:size(data, 2)
                for i = 1:size(data, 1)
                    % cdist = ceil(pdist([squeeze(camera_grid_positions(i,j,:))'; camera_position], 'euclidean') / deltaT);
                    % ldist = ceil(pdist([squeeze(laser_grid_positions(i,j,:))'; laser_position], 'euclidean') / deltaT);
                    % tdist = cdist+ldist;
                    % data(i,j,:) = [squeeze(data(i,j,tdist:end)); zeros(tdist-1, 1)]';
                    data(i,j,:) = circshift(data(i,j,:), -tdist(i,j));
                    % Add direct component
                    % data(i,j,1) = 1;
                end
            end
        end
        
        function ShowSlice(data, spad_or_laser, index)
            if length(size(data)) ~= 3
                error('Can''t get a single slice from %dD data', length(size(data)));
            end
            figure(); hold on;
            title(sprintf('%s slice %s', spad_or_laser, index));
            if spad_or_laser(1) == 's'
                if index == 'sum'
                    slice = sum(data, 2);
                elseif isnumeric(index)
                    slice = data(:, index, :);
                end
            elseif spad_or_laser(1) == 'l'
                if index == 'sum'
                    slice = sum(data, 1);
                elseif isnumeric(index)
                    slice = data(index, :, :);
                end
            end
            imshow(tonemap(squeeze(slice)));

        end
        
        function data = Trim(data)
            % Trim   Remove trailing zeros from the data. The final time
            % resolution will always be the smallest power of two that
            % won't lose any non zero values. Only useful for very short
            % scenes (or long exposure ones) where all radiance is in a
            % in the first few frames.
            switch length(size(data))
                case 6
                    [~, ~, ~, ~, ~, last_radiance] = ind2sub(size(data), find(data>0,1,'last'));
                    if isempty(last_radiance); last_radiance = size(data, 6); end
                    data = data(:,:,:,:,:, 1:2^round(log2(last_radiance)));
                    last_index = 2^round(log2(last_radiance));
                    if last_index > size(data,6)
                        data(:,:,:,:,:,last_index) = 0.0;
                    else
                        data = data(:,:,:,:,:,1:last_index);    
                    end
                case 5
                    [~, ~, ~, ~, last_radiance] = ind2sub(size(data), find(data>0,1,'last'));
                    if isempty(last_radiance); last_radiance = size(data, 5); end
                    last_index = 2^round(log2(last_radiance));
                    if last_index > size(data,5)
                        data(:,:,:,:,last_index) = 0.0;
                    else
                        data = data(:,:,:,:,1:last_index);    
                    end
                case 4
                    [~, ~, ~, last_radiance] = ind2sub(size(data), find(data>0,1,'last'));
                    if isempty(last_radiance); last_radiance = size(data, 4); end
                    last_index = 2^round(log2(last_radiance));
                    if last_index > size(data,4)
                        data(:,:,:,last_index) = 0.0;
                    else
                        data = data(:,:,:,1:last_index);    
                    end
                case 3
                    [~, ~, last_radiance] = ind2sub(size(data), find(data>0,1,'last'));
                    if isempty(last_radiance); last_radiance = size(data, 3); end
                    last_index = 2^round(log2(last_radiance));
                    if last_index > size(data,3)
                        data(:,:,last_index) = 0.0;
                    else
                        data = data(:,:,1:last_index);    
                    end
            end
        end
        
        function index = FirstSampleIndex(data)
            [~, ~, index] = ind2sub(size(data), find(data>0,1));
        end
        
        function data = Blur(data, kernelSize)
            % Blur  Adds gaussian blur to the data with the chosen
            % kernelSize
            G = fspecial('gaussian', [kernelSize kernelSize], 2);
            
            switch length(size(data))
                case 6
                    for b = 1:size(data,5)
                        for sy = 1:size(data,1)
                            for sx = 1:size(data,2)
                                for ly = 1:size(data,3)
                                    data(sy,sx,ly,:,b,:) = imfilter(data(sy,sx,ly,:,b,:), G, 'same');
                                end
                            end
                        end
                    end
                case 5
                    for sy = 1:size(data,1)
                        for sx = 1:size(data,2)
                            for ly = 1:size(data,3)
                                data(sy,sx,ly,:,:) = imfilter(data(sy,sx,ly,:,:), G, 'same');
                            end
                        end
                    end
                case 4
                    for b = 1:size(data,3)
                        for sly = 1:size(data,1)
                            data(sly,:,b,:) = imfilter(data(sly,:,b,:), G, 'same');
                        end
                    end
                case 3
                    for sly = 1:size(data,1)
                        data(sly,:,:) = imfilter(data(sly,:,:), G, 'same');
                    end
                otherwise
                warning('Invalid data size found while adding blur\n');
            end
        end
        
    end
end
