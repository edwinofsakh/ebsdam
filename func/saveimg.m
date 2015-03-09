function [filename] = saveimg( saveres, fclose, outdir, prefix, desc, ext, comment )
% Save image to disk
%   Save image to output directory on disk, with specific name. Can close
%   figure.
%
% Syntax
%   saveimg( saveres, fclose, outdir, prefix, desc, ext, comment )
%
% Output
%   filename- name of the file where the image was saved
%
% Input
%   saveres - save results to disk (1 - yes, 0 - no)
%   fclose  - close all figure after saving (1 - yes, 0 - no)
%   outdir  - output directory
%   prefix  - file name prefix
%   desc    - file name description
%   ext     - file extension: 'png'
%   comment - image comment
%
% History
% 23.11.12  Rename from 'save2disk' to 'saveimg'
%           Add function description
% 14.04.13  Add saveing of image comment
% 07.10.13  Problem with 'saveres'. Add patch for normal working.
% 19.11.13  Return file name
% 09.02.15  Move to Linux

% Set defualt extension
if (ext == 0)
    ext = 'png';
end

filename = fullfile(outdir, [prefix '_' desc '.' ext]);

% Save image to disk
if (saveres == 1 || getpref('ebsdam', 'saveResult') == 1)
    savefigure(filename);
    % Close all figure
    if(fclose)
        close all;
    end
    
    % Add image comment. It can be read calling 'imfinfo'
    I = imread(filename);
    imwrite(I, filename, 'Comment', comment);
end

