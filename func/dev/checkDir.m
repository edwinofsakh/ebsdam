function [ outdir ] = checkDir( sid, dirname, saveres, varargin)
%Check output dir
%   Make output dir name. Check is it exist, if not make it.
%
% Input
%   sid     - sample id: 's01', 's02', 's03', 's04', 't01', 'p01', 'p02'
%   dirname - last directory name
%   saveres - save result to disk
%
% Options
%   'flat_save' - don'nt create sample directory
%
% Output
%   outdir  - full name of output directory
%
% Syntax
%   [ outdir ] = checkDir( sid, dirname, saveres )
%
% History
% 23.11.12  Add function description

% Make output directory name
outdir = getpref('ebsdam','output_dir');

if (~check_option(varargin, 'flatsave'))
    outdir = [outdir '\img\' sid '\' dirname];
else
    outdir = [outdir '\img\' dirname];
end

% Make directory if results will be saved to disk
if check_option(varargin, 'saveres') || saveres
    if ~exist(outdir, 'dir')
        mkdir(outdir);
    end
end

end

