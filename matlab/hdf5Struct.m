function dataset = hdf5Struct(filename)
%hdf5Struct Loads a whole HDF5 file as a matlab struct

    info = h5info(filename);
    
    dataset = struct();
    
    for n = {info.Datasets.Name}
        name = strjoin(n);
        dataset.(name) = h5read(filename, ['/' name]);
    end

end