function [S, varargout] = loadResultData( filename, varargin )
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

outdir = [getpref('ebsdam','output_dir') '\data'];

S = load([outdir '\' filename], varargin{:});

if nargout > nargin
	error('Bad');
end

if nargin > 1
    for i = 2:nargin
        varargout{i-1} = S.(varargin{i-1});
    end
end

end