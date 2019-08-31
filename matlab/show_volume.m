function show_volume(dump_file)
% show_volume loads the given dump_file and shows it on matlab's volume viewer 
% After that you can adjust the visualization parameters to see the hidden geometry

    vol = load_dump(dump_file);
    volumeViewer(vol);
end