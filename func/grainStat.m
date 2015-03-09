function [err] = grainStat( grains, saveres, odir, prefix )
%Get grains statistic
%
% Syntax
%   grainStat( grains, saveres, odir, prefix )
%
% Output
%   err - file opening error
%
% Input
%   grains  - grains
%   saveres - save results to disk (1 - yes, 0 - no)
%   odir    - output directory
%   prefix  - file name prefix
%
% History
% 07.12.12  Add description of the function. Add size info and EBSD steps.
% 09.02.15  Move to Linux

% Get area and size information
ar = area(grains);
sz = grainSize(grains);
r = equivalentradius(grains);

% Display stat
disp(['Mean area     :' num2str(mean(ar))]);
disp(['Variance area :' num2str(var(ar))]);
disp(['Deviation area:' num2str(std(ar))]);
disp(['Min area      :' num2str(min(ar))]);
disp(['Max area      :' num2str(max(ar))]);
disp(['N grains      :' num2str(numel(grains))]);

% Get step to link area and size
[dx, dy] = getStep( get(grains, 'ebsd'));

% Save stat to disk
if saveres
    fname = fullfile(odir, [prefix '_area_stat.csv']);
    [fid, err] = fopen(fname,'w');
    if (fid ~= -1)
        fprintf(fid, '%s;;\r\n', 'Grains area statistic');
        
        fprintf(fid, '%s;%f;\r\n', 'N grains', numel(grains));
        fprintf(fid, '%s;%f;\r\n', 'Neighors per grain', numel(neighbors(grains)));
        fprintf(fid, '%s;%f;\r\n', 'X step', dx);
        fprintf(fid, '%s;%f;\r\n', 'Y step', dy);
                
        fprintf(fid, '%s;%f;\r\n', 'Mean area', mean(ar));
        fprintf(fid, '%s;%f;\r\n', 'Variance area', var(ar));
        fprintf(fid, '%s;%f;\r\n', 'Deviation area', std(ar));
        fprintf(fid, '%s;%f;\r\n', 'Min area', min(ar));
        fprintf(fid, '%s;%f;\r\n', 'Max area', max(ar));
        
        fprintf(fid, '%s;%f;\r\n', 'Mean size', mean(sz));
        fprintf(fid, '%s;%f;\r\n', 'Variance size', var(sz));
        fprintf(fid, '%s;%f;\r\n', 'Deviation size', std(sz));
        fprintf(fid, '%s;%f;\r\n', 'Min size', min(sz));
        fprintf(fid, '%s;%f;\r\n', 'Max size', max(sz));

                        
        fprintf(fid, '%s;%f;\r\n', 'Mean radius', mean(r));
        fprintf(fid, '%s;%f;\r\n', 'Variance radius', var(r));
        fprintf(fid, '%s;%f;\r\n', 'Deviation radius', std(r));
        fprintf(fid, '%s;%f;\r\n', 'Min radius', min(r));
        fprintf(fid, '%s;%f;\r\n', 'Max radius', max(r));
        
        fclose(fid);
    end
end

err = 0;

end

