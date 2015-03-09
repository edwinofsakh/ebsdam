function savedist(x, f, title, saveres, wtype, outdir, prefix, desc, comment)
% Save distribition to disk
%   Save distribition to 'csv' file into output directory on disk.
% 
% Syntax
%   savedist(x, f, title, saveres, wtype, outdir, prefix, desc, comment)
%
% Input
%   x       - edges
%   f       - frequency
%   title   - title
%   saveres - save results to disk (1 - yes, 0 - no)
%   wtype   - write type 'w' or 'a', (see 'fopen')
%   outdir  - output directory
%   prefix  - file name prefix
%   desc    - file name description
%   comment - comment
%
% History
% 23.11.12  Original implementation
%           Function description
% 14.04.13  Add saveing of comment
% 09.02.15  Move to Linux

% Save distribition to disk
if saveres
    fname = fullfile(outdir, [prefix '_' desc '.csv']);
    [fid, err] = fopen(fname, wtype);
    fprintf(fid, '%s; \r\n', comment);
    fprintf(fid, '%s; \r\n', title);
    for i = 1 : length(f)
        fprintf(fid, '%d;%d; \r\n', x(i), f(i));
    end
    fclose(fid);
end

