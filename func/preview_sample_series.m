function preview_sample_series(series_name, start)
% Preview orientation maps for sample series
%   Create simple report with orientation maps for all samples in series
%
% Syntax
%   preview_sample_series('p', start)
%
% Output
%   ***     - ***
%
% Input
%   ***     - ***
%
% Options
%   ***     - ***
%
% Example
%   ***
%
% History
% 12.04.13  Original implementation
% 09.02.15  Move to Linux


% Get list of all samples 
listing = dir('load');
ld = struct2cell(listing);

% Create output directory
outdir = checkDir('', 'maps', 1, 'flat_save');

% Prepare html file
htmlreport(series_name, 'start');


if start == 0
    st = 1;
else
    st = 0;
end

% Process each sample
cellfun(@(x) load_current_sample(x, series_name, outdir, start, st), ld(1,:));

% Finalize html file
htmlreport(series_name, 'end');
end

function load_current_sample(filename, series_name, outdir, start, st)

n = length(series_name);

if (start  ~= 0 || strncmp(filename,start, length(start)))
    st = 1;
end
    
if (strncmp(filename,series_name, n) && st)
    [~,name,~] = fileparts(filename);
    try
        filename = fullfile(outdir, ['_' name '.png']);
        if (~exist(filename, 'file'))
            ebsd = eval(name);
            figure;
            plot(ebsd, 'antipodal', 'r',zvector, 'name', name);
            ipath = saveimg( 1, 1, outdir, '', name, 'png', getComment());
            
            if ~strcmp(filename, ipath)
                error('Problem with path');
            end
        end
        htmlreport(series_name, 'add', 'img', 'path', filename, 'title', name);
    end
end

end