function savehdf5(filename, datastruct)
%SAVEHDF5 Saves the fields in a struct as an hdf5 file
    for fname = fieldnames(datastruct)'
        s = size(datastruct.(fname{:}));
        h5create(filename, ['/' fname{:}], s, 'DataType', ...
            class(datastruct.(fname{:})), 'ChunkSize', ceil(s/2), 'Deflate', 5);
        h5write(filename, ['/' fname{:}], datastruct.(fname{:}));
    end
end
