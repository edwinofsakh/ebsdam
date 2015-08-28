function [S, varargout] = loadResultData( fname, varargin )
% Load data to output directory
%
% Syntax
%   S = loadData( filename, varargin );
%
% Output
%   S - output structure
%
% Input
%   see function 'load'
%
% History
% 13.08.14  Original implementation
% 09.02.15  Move to Linux

fpath = fullfile(getpref('ebsdam','output_dir'), 'data', fname);

S = load(fpath, varargin{:});

if nargout > nargin
	error('Bad');
end

if nargin > 1
    for i = 2:nargin
        varargout{i-1} = S.(varargin{i-1});
    end
end

end