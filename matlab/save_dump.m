function save_dump(voxel_volume, dump_name, save_old_dump_file, varargin)
%save_dump Stores a 3D float volume into a file with the format accepted by the visualization tool
    if nargin < 3
        save_old_dump_file = true;
    end
    
    if save_old_dump_file
        f_id = fopen(dump_name, 'w');

        grid_size = length(voxel_volume);

        fwrite(f_id, -grid_size, '*int32', 'ieee-be');

        for x = 1:grid_size
            for y = 1:grid_size
                fwrite(f_id, voxel_volume(x, y, :), 'single', 'ieee-be');
            end
        end
        fclose(f_id);
    else
        if exist(dump_name, 'file')
            delete(dump_name)
        end
        h5create(dump_name, '/voxelVolume', size(voxel_volume), ...
            'Datatype', 'single', ...
            'ChunkSize', max([1,1,1], size(voxel_volume) / 8), ...
            'Deflate', 4);
        h5write(dump_name, '/voxelVolume', voxel_volume);
        i = 1;
        while i < length(varargin)
           if ischar(varargin{i})
              h5writeatt(dump_name,'/', varargin{i}, varargin{i+1})
           end
           i = i + 2;
        end
    end
    
    
end