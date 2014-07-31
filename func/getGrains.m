function [ grains, grainsf ] = getGrains( ebsd, thr, mgs, varargin)
%Get grains from EBSD
%   Get grains from EBSD with boundary misorientation more than 'thr', and
%   size more then 'mgs'.
%
% Syntax
%   [ grains, grains_full ] = getGrains( ebsd, thr, mgs, varargin );
%
% Input
%   ebsd    - source EBSD data
%   thr     - grain detection threshold, misorientation angle in radian
%   mgs     - minimal grain size, in points (Grain with this size and 
%               smaller will be removed at 2nd pass). Set '0' to disable.
%   'unitcell'
%
% Output
%   grains  - list of grains
%   grainsf - list of grains before small grains removing
%
% History
% 23.01.12  Add comments
% 29.01.12  Add saveing of grains (Cancelled: At load GrainSet not created)
% 21.11.12  Add function description
% 16.04.13  Fix comments. Now 'thr' in radian.
% 21.04.13  Comments makeup. Now grain size must be > mgs
% 17.12.13  Some time ago add varargin for setting 'unitcell' for 'calcGrains'

% Check EBSD
if ~exist('ebsd','var')
    strCmd = 'ebsd = s01_load';
    error('Variable "ebsd" is not init. Init EBSD data useing command "%s"', strCmd);
end
    
% % Get Hash from EBSD
% n = length(ebsd);
% if (n > 1084)
%     o1084 = get(ebsd(1084),'orientation');
%     e1084 = Euler(o1084);
%     a = n + e1084(1)*e1084(2)*e1084(3)*n*71 + (e1084(1)+e1084(2)+e1084(3))*n*3;
%     a = a*131;
%     a = floor(a);
%     while (a > 2147483648)
%         a = floor(a/51);
%     end
%     hash = dec2hex(int32(a));  
% end
% 
% % Get output directory
% outdir = getpref('ebsdam','output_dir');
% outdir = [outdir '\grains'];
% if ~exist(outdir, 'dir')
%     mkdir(outdir);
% end
%     
% % Name of MAT file with saveing variables 
% matfile = [outdir '\' hash '_' num2str(thr) '_' num2str(mgs) '.mat'];

%% Get grains
% if exist(matfile,'file') && 0
%     % Load saveing data
%     load_struct = load(matfile, 'grains');
%     grains = load_struct.grains;
% else
    % Detect grains
    grainsf = calcGrains(ebsd, 'threshold',thr, 'antipodal', 'angletype','disorientation',varargin{:});

    if (mgs > 0)
        grainsl = grainsf(grainSize(grainsf) > mgs);
        grains = calcGrains(grainsl, 'threshold',thr, 'antipodal', 'angletype','disorientation',varargin{:});
    else
        grains = grainsf;
    end
    
%     save(matfile, 'grains');
% end

if (check_option(varargin, 'display'))
    display(grains);
end

