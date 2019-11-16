function nlos = loaddata(scene,snr)
    if nargin < 2
        snr = Inf;
    end
    basepath = '~/Developer/cvpr2019_nlos';
    switch scene
      case 'rabbit'
        loadfile = 'bunny_l[0.00,-0.50,0.00]_r[1.57,0.00,3.14]_v[0.80,0.53,0.81]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:512;
      case 'occluded'
        loadfile = 'occluded_l[0.00,-1.00,0.00]_r[1.57,0.00,3.14]_v[0.27,0.41,0.81]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:2048;
      case 'serapis'
        loadfile = 'serapis_l[0.00,-0.50,-0.41]_r[0.00,0.00,-1.57]_v[0.82]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:512;
      case 'serapis1.0'
        loadfile = 'serapis_l[0.00,-1.00,-0.40]_r[0.00,0.00,-1.57]_v[0.62,0.67,0.80]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:2048;
      case 'spheres'
        loadfile = 'spheres_l[0.00,-0.50,-0.64]_r[0.00,0.00,0.00]_v[0.68]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:512;
      case 'xyzrgb_dragon'
        loadfile = 'xyzrgb_dragon_l[0.00,-0.50,-0.66]_r[0.00,0.00,1.00]_v[0.68]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:512;
      case 'hairball'
        loadfile = 'hairball_l[0.00,-1.00,-0.40]_r[1.57,0.00,3.14]_v[0.80]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:1024;
      case 'sportscar'
        loadfile = 'sports_car_l[0.00,-0.50,-0.72]_r[0.00,0.00,-4.00]_v[0.76]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:512;
      case 'concavities'
        loadfile = 'concavities_l[0.00,-0.50,0.00]_r[1.57,0.00,3.14]_v[0.81,0.51,0.80]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:512;
      case 'statue'
        loadfile = 'statue/meas_180min.mat';
        loadtype = 'stanford';
        templast = 1:512;
      case 'exit_sign'
        loadfile = 'exit/data_exit_sign.mat';
        loadtype = 'cnloslct';
        templast = 1:2048;%1225:1225+512-1;
        z_trim   = 600;
      case 'diffuse_s'
        loadfile = 'diffuse_s/data_diffuse_s.mat';
        loadtype = 'cnloslct';
        templast = 1:2048;%1225:1225+512-1;
        z_trim   = 100;
      case 'su'
        loadfile = 'su/data_s_u.mat';
        loadtype = 'cnloslct';
        templast = 1:2048;
      case 'discus'
        loadfile = 'discus/meas_360min.mat';
        loadtype = 'stanford';
        templast = 1:1024;
      case 'dragon'
        loadfile = 'dragon/meas_180min.mat';
        loadtype = 'stanford';
        templast = 1:512;
      case 'bike'
        loadfile = 'bike/meas_10min.mat';
        loadtype = 'stanford';
        templast = 1:512;
      case 'bunny'
        loadfile = 'bunny/bunny.mat';
        loadtype = 'debugger';
        templast = 1:512;
      case 'horse'
        loadfile = 'horse/horse_dataset_calibrated.mat';
        loadtype = 'cmu';
        templast = 1:1024;
      case 'numbers'
        loadfile = 'numbers/numbers_dataset_calibrated.mat';
        loadtype = 'cmu';
        templast = 1:1024;
    end
    switch loadtype
      case 'zaragoza'
        nlos = NLOSData(fullfile(basepath,loadtype,[loadfile,'.hdf5']),'bounces','sum','shifttime',true,'GaussianSNR',snr);
        nlos.Data = max(0,nlos.Data(:,:,templast));
        if exist(fullfile(basepath,loadtype,[loadfile,'_rec.mat']),'file')
            load(fullfile(basepath,loadtype,[loadfile,'_rec.mat']),'depth');
            nlos.Depth = depth;
        end
        if exist(fullfile(basepath,loadtype,[loadfile,'_nor.mat']),'file')
            load(fullfile(basepath,loadtype,[loadfile,'_nor.mat']),'normal');
            nlos.Normal = normal;
        end
      case 'stanford'
        nlos = NLOSStanfordData(fullfile(basepath,loadtype,loadfile),'shifttime',true);
        nlos.Data = nlos.Data(:,:,templast);
        nlos.DeltaT = 3e8 * 32e-12;
        nlos.CameraGridSize = 2;
        nlos.Depth = NaN;
      case 'debugger'
        nlos = NLOSStanfordData(fullfile(basepath,loadtype,loadfile),'shifttime',false);
        nlos.Data = flipud(fliplr(permute(nlos.Data(templast,:,:),[2,3,1])));
        nlos.DeltaT = 3e8 * 16e-12;
        nlos.CameraGridSize = 1;
      case 'cnloslct'
        nlos = NLOSStanfordData(fullfile(basepath,loadtype,loadfile),'shifttime',false);
        nlos.Data(:,:,1:z_trim) = 0;
        nlos.Data = imresize3(fliplr((nlos.Data(:,:,templast))),[64,64,512]);
        nlos.DeltaT = 4 * 3e8 * 4e-12;
        nlos.CameraGridSize = 0.70;
      case 'cmu'
        nlos = NLOSStanfordData(fullfile(basepath,loadtype,loadfile),'shifttime',false);
        nlos.Data = imresize3(reshape(nlos.Data(templast,:)',64,64,[]),[64,64,1024]);
        nlos.DeltaT = 1 * 3e8 * 4e-12;
        nlos.CameraGridSize = 0.70;
    end
end
