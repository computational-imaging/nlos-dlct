function nlos = loaddata(scene)
    basepath = '..';
    switch scene
      case 'rabbit'
        loadfile = 'bunny_l[0.00,-0.50,0.00]_r[1.57,0.00,3.14]_v[0.80,0.53,0.81]_s[256]_l[256]_gs[1.00]_conf.hdf5';
        loadtype = 'zaragoza';
        templast = 512;
      case 'serapis'
        loadfile = 'serapis_l[0.00,-0.50,-0.41]_r[0.00,0.00,-1.57]_v[0.82]_s[256]_l[256]_gs[1.00]_conf.hdf5';
        loadtype = 'zaragoza';
        templast = 512;
      case 'hairball'
        loadfile = 'hairball_l[0.00,-1.00,-0.40]_r[1.57,0.00,3.14]_v[0.80]_s[256]_l[256]_gs[1.00]_conf.hdf5';
        loadtype = 'zaragoza';
        templast = 1024;
      case 'sportscar'
        loadfile = 'sports_car_l[0.00,-0.50,-0.72]_r[0.00,0.00,-4.00]_v[0.76]_s[256]_l[256]_gs[1.00]_conf.hdf5';
        loadtype = 'zaragoza';
        templast = 512;
      case 'concavities'
        loadfile = 'concavities_l[0.00,-0.50,0.00]_r[1.57,0.00,3.14]_v[0.81,0.51,0.80]_s[256]_l[256]_gs[1.00]_conf.hdf5';
        loadtype = 'zaragoza';
        templast = 512;
      case 'statue'
        loadfile = 'statue/meas_10min.mat';
        loadtype = 'stanford';
        templast = 512;
      case 'dragon'
        loadfile = 'dragon/meas_10min.mat';
        loadtype = 'stanford';
        templast = 512;
      case 'bike'
        loadfile = 'bike/meas_10min.mat';
        loadtype = 'stanford';
        templast = 512;
      case 'bunny'
        loadfile = 'bunny/bunny.mat';
        loadtype = 'debugger';
        templast = 512;
    end
    switch loadtype
      case 'zaragoza'
        nlos = NLOSData(fullfile(basepath,loadtype,loadfile),'bounces','sum','shifttime',true);
        nlos.Data = nlos.Data(:,:,1:templast);
      case 'stanford'
        nlos = NLOSStanfordData(fullfile(basepath,loadtype,loadfile),'shifttime',true);
        nlos.Data = nlos.Data(:,:,1:templast);
        nlos.DeltaT = 3e8 * 32e-12;
        nlos.CameraGridSize = 2;
      case 'debugger'
        nlos = NLOSStanfordData(fullfile(basepath,loadtype,loadfile),'shifttime',false);
        nlos.Data = flipud(fliplr(permute(nlos.Data(1:templast,:,:),[2,3,1])));
        nlos.DeltaT = 3e8 * 16e-12;
        nlos.CameraGridSize = 1;
    end
end
