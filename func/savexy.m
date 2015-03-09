function savexy( x, y, saveres, odir, prefix, fname, ltitle, comment )
% Save xy data to file
%   Save x and y data to 'csv' file
%
% Syntax
%   savexy( x, y, saveres, odir, prefix, fname, ltitle, comment )
%
% Input
%   x       - x data
%   y       - y data
%   saveres - see main function
%   odir    - output directory
%   prefix  - file name prefix
%   fname   - file name
%   ltitle  - data title (name 'title' is used)
%   comment - comment
%
% History
% 03.12.12  Original implementation
% 14.04.13  Add saveing of comment
% 09.02.15  Move to Linux

    if saveres
        fname = fullfile(odir, [prefix '_' fname '.csv']);
        [fid, err] = fopen(fname,'w');
        if (fid ~= -1)
            
            fprintf(fid, '%s;\r\n', comment);
            fprintf(fid, '%s;%f;\r\n', ltitle, sum(y));
            for i = 1 : length(y)
                fprintf(fid, '%f;%f;\r\n', x(i), y(i));
            end
            fclose(fid);
        end
    end
end
