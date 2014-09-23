function saveResultData( filename, varargin )
% Save data to output directory
%
% Syntax
%   saveData( filename, varargin );
%
% Input
%   filename - name of file for saving result
%   varargin - set of variables for saving (not names like in func 'save')
%
% Example
%   saveData( "result01.mat", v1, v2, v3 );
% 
% History
% 13.08.14  Original implementation
% 20.09.14  Fix description

outdir = [getpref('ebsdam','output_dir') '\data'];

if ~exist(outdir, 'dir')
    mkdir(outdir);
end

S = struct;

if nargin > 1
    for i = 2:nargin
        S.(inputname(i)) = varargin{i-1};
    end
    
    save([outdir '\' filename], '-struct','S');
end

end
