% Just example
function [ ebsd ] = sid_load( varargin )
%Load EBSD data from 'Path\to\file.ang'
%  Supplier : Description
%  Material : of 
%  Phases   : sample
%  Columns  : Columns name for text file
%  Points   : ??? (???x???)
%  Size     : ??? x ??? um
%  Step     : ??? x ??? nm
%  Comments :
%   Some comments.

%% Settings

% File name
fname = '.\Path\to\file.ang.ang';

% Specify crystal and specimen symmetry
cs = symmetry('m-3m','mineral','Fe'); % crystal symmetry phase ferrite
ss = symmetry('-1');                  % specimen symmetry


%% Loading

ebsd = load_patterns( fname, cs, ss, 'pattern_name', 97, 0,'flipY');

end