function [ str ] = exportData( data, type, style, varargin )
% Export Data

switch(type)
    case 'euler'
        str = exportEuler(data, style);
    case 'matrix'
        str = exportMatrix(data, style);
    case 'ori'
        eul = Euler(data);
        str = exportEuler(eul/degree, style);
    otherwise
        error('Unknown type.')
end

end

function [ str ] = exportEuler(eul, style)

switch(style)
    case 'csv'
        str = printVector(eul, '%f', '; ', 'lastSpace');
    case 'disp'
        %str = printVector(eul, '%f', '\t');
        str = num2str(eul);
    case 'matlab'
        str = printVector(eul, '%f', ', ');    
        str = sprintf('[ %s]*degree', str);
    otherwise
        error('Unknown style.')
end

end

function [ str ] = exportMatrix(mtr, style)

switch(style)
    case 'csv'
        str = printVector(mtr, '%f', '; ', 'lastSpace');
    case 'disp'
        %str = printMatrix(mtr, '%f', '\t', '', 1);
        str = num2str(mtr);
    case 'matlab'
        str = printMatrix(mtr, '%f', ', ', '; ...', 1);    
        str = sprintf('[\n%s ]', str);
    otherwise
        error('Unknown style.')
end

end
%%
%   '%u' - int
%   '%f' - float
%
function [ str ] = printMatrix(matrix, format, spacer1, spacer2, retcar)
str = [];
s = size(matrix);
for i = 1:s(1)-1
    stri = printVector(matrix(i,:), format, spacer1);
    stri = sprintf('\t %s%s', stri, spacer2);
    if retcar
        stri = sprintf('%s\n', stri);
    end
    str = [str stri]; %#ok<AGROW>
end

stri = printVector(matrix(i+1,:), format, spacer1);
stri = sprintf('\t %s', stri);
str = [str stri];
    
end

function [ str ] = printVector(vector, format, spacer, varargin)
% Print vector element with spacer between. Last spacer can be skipped.
str = [];

if check_option(varargin, 'lastSpace')
    for i = 1:numel(vector)
        stri = sprintf([format spacer], vector(i));
        str = [str stri]; %#ok<AGROW>
    end
else
    for i = 1:numel(vector)-1
        stri = sprintf([format spacer], vector(i));
        str = [str stri]; %#ok<AGROW>
    end
        stri = sprintf(format, vector(i+1));
        str = [str stri];
end

end

% function getType(type)
% switch(type)
%     case 'int'
%         str = '%u';
%     case 'float'
%         str = '%f';
%     otherwise
%         error('Unknown type.')
% end
% end

