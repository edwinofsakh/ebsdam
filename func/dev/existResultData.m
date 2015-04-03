function ret = existResultData( filename, varargin )
% Check data in output directory
%
% Syntax
%   existData( filename, varargin );
%
% Input
%   filename - name of file for saving result
%   varargin - set of variables for saving (not names like in func 'save')
%
% Example
%   if (existData( "result01.mat" ))
% 
% History
% 03.04.15  Original implementation

outdir = fullfile(getpref('ebsdam','output_dir'), 'data');

if ~exist(outdir, 'dir')
    mkdir(outdir);
end

if exist(fullfile(outdir, filename), 'file') == 2
    ret = 1;
else
    ret = 0;
end

end
