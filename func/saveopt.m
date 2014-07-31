function saveopt( x, f, names, saveres, odir, prefix, fname, comment )
% Save opt OR data to file
%   Save opt OR data to 'csv' file
%
% Syntax
%   saveopt( x, f, names, saveres, odir, prefix, fname, comment )
%
% Input
%   x - x data
%   f - f data
%   names - names of OR
%   saveres - see main function
%   odir - output directory
%   prefix - file name prefix
%   fname - file name
%   ltitle - data title (name 'title' is used)
%   comment - comment
%
% History
% 03.12.12 Original implementation
% 14.04.13  Add saveing of comment

    if saveres
        [np, nv] = size(f);
        fname = [odir '\' prefix '_' fname '.csv'];
        [fid, err] = fopen(fname,'w');
        if (fid ~= -1)
            
            % Head
            fprintf(fid, '%s;\r\n', comment);
            fprintf(fid, ';');
            for i = 1 : nv
                fprintf(fid, '%s;', names{i});
            end
            
            fprintf(fid, '\r\n');
            
            % Data
            for i = 1 : np
                fprintf(fid, '%f;', x(i));
                for j = 1 : nv
                    fprintf(fid, '%f;', f(i,j));
                end
                fprintf(fid, '\r\n');
            end
            
            fclose(fid);
        end
    end
end
