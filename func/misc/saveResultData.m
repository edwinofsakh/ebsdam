function saveResultData( filename, varargin )
% Save data to output directory
%
% Syntax
%   saveData( filename, varargin );
%
% Output
%
% Input
%   see function 'save'
%
% History
% 13.08.14  Original implementation

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
