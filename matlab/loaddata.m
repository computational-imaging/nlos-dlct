% LOADDATA Load transients for use with the D-LCT algorithm.
%
%   NLOS = LOADDATA(SCENE) loads the transients struct NLOS for the
%   scene SCENE.
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
% documentation, and that the name of Stanford University not be used
% in advertising or publicity pertaining to distribution of the
% software without specific, written prior permission.
%
% STANFORD UNIVERSITY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
% SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR ANY PARTICULAR PURPOSE. IN NO EVENT SHALL STANFORD
% UNIVERSITY BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
% DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
% OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
% TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
% PERFORMANCE OF THIS SOFTWARE.

function nlos = loaddata(scene)
    basepath = '../';
    switch scene
      case 'rabbit'
        loadfile = 'bunny_l[0.00,-0.50,0.00]_r[1.57,0.00,3.14]_v[0.80,0.53,0.81]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:512;
      case 'serapis'
        loadfile = 'serapis_l[0.00,-0.50,-0.41]_r[0.00,0.00,-1.57]_v[0.82]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:512;
      case 'spheres'
        loadfile = 'spheres_l[0.00,-0.50,-0.64]_r[0.00,0.00,0.00]_v[0.68]_s[256]_l[256]_gs[1.00]_conf';
        loadtype = 'zaragoza';
        templast = 1:512;
      case 'statue'
        loadfile = 'statue/meas_180min.mat';
        loadtype = 'stanford';
        templast = 1:512;
      case 'dragon'
        loadfile = 'dragon/meas_180min.mat';
        loadtype = 'stanford';
        templast = 1:512;
      case 'data_s_u'
        loadfile = 'data_s_u.mat';
        loadtype = 'confocal_nlos_code';
        z_trim = 600;
      case 'data_exit_sign'
        loadfile = 'data_exit_sign.mat';
        loadtype = 'confocal_nlos_code';
        z_trim = 600;
    end
    switch loadtype
      case 'zaragoza'
        nlos = NLOSData(fullfile(basepath,loadtype,[loadfile,'.hdf5']),'bounces','sum','shifttime',true);
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
      case 'confocal_nlos_code'
        nlos = NLOSStanfordData(fullfile(basepath,loadtype,loadfile),'shifttime',false);
        nlos.Data(:,:,1:z_trim) = 0;
        nlos.DeltaT = 3e8 * 4e-12;
        nlos.CameraGridSize = 0.70;
        nlos.Depth = NaN;
    end
end
