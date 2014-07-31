function startup_ebsdam(varargin)
% Initialize EBSD Analysis Module.
%   It sets preferences and search paths. It's dynamic way of setup.
% 
% Syntax
%   startup_ebsdam(varargin)
%
% Input
%   'uninstall' - uninstall module
%
% History
% 27.03.13  Ask 'output_dir' before 'cache_dir'.
% 05.04.13  Increase minor version.
% 12.04.13  Dynamic setup: now this fucntion running on MATLAB starting
%           from 'startup'.
%           For unsinstall call 'startup_ebsdam('uninstall')'.
%           New additional directories will be added after restart, only
%           one root access needed.

mpath = path;

% Script directory
basepath = fileparts(mfilename('fullpath'));

% Uninstallation
if (nargin > 0 && any(strcmp('uninstall',varargin)))
    disp('Uninstall EBSDAM')
    
    if ispref('ebsdam'), rmpref('ebsdam'); end;
    
    mm = regexp(mpath, '[^;]+', 'match');
    n = length(basepath);
    ind = cellfun(@(x) strncmp(x,basepath,n), mm);
    cellfun(@(x) rmpath(x), mm(ind));
    return;
end

% Read version from version file
try
  fid = fopen('version.txt','r');
  EBSDAMversion = fgetl(fid);
  fclose(fid);
catch
  EBSDAMversion = 'EBSDAM';
end
disp([upper('Startup ') EBSDAMversion]);

% Check instalation
if install_ebsdam(mpath,basepath), return; end;

% Additional dirs
dirs = {'\func', '\func\dev', '\func\recon', '\func\misc', '\func\OR', '\func\third_party',...
    '\load', '\tcode', '\ui'};
dirs = cellfun(@(x) [basepath x], dirs, 'UniformOutput', false);
addpath(dirs{:},'-end');

%rmpref('ebsdam');
setpref('ebsdam', 'version', EBSDAMversion);
setpref('ebsdam', 'src_dir', basepath);

% Setup working direstories
if exist('EBSDAM_settings.m','file')
	EBSDAM_settings;
else
	disp('Cann''t find ''EBSDAM_settings.m'' file. Run ''setupWorkDirs''.');
end

end



function err = install_ebsdam( mpath, basepath )
% Install EBSD Analysis Module to MATLAB.
%   Install EBSDAM by added base dir to MATLAB search path. At start MATLAB
%   run 'startup' from search path. To use more then one module write
%   general 'startup' and cal 'startup_ebsdam' in it.

err = 0;

% Find basepath is in search path
if strfind(mpath,basepath), return; end

% Find old installation in another dir 
if strfind(mpath,'ebsdam')
    disp('Find another EBSDAM dir in search path. Please delete previous version.')
    err = 1;
    return;
end

% Remove old prefs
if ispref('ebsdam'), rmpref('ebsdam'); end

% Installation
disp('Installing EBSD Analysis Module: ');

addpath(basepath,'-end');

if ~savepath
    disp('Done');
else
    disp('!!! Failed !!!');
end

end
