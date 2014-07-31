function [ ebsd ] = ak01s_load( varargin )
% Load EBSD data from 'Ak32 - EBSD\1_small.ang'
%  Supplier : Prometey
%  Material : bainite steel
%  Phases   : iron-alpha
%  Columns  : Euler 1 ; Euler 2 ; Euler 3 ; x ; y ; IQ ; CI ; Phase ; SEM ; Fit
%  Points   : ?? (??x??)
%  Size     : ?? x ?? um
%  Step     : ?? nm
%  Comments :
%   ***  

%% Settings

% File name
fname = '.\Ak32 - EBSD\1_small.ang';

% Specify crystal and specimen symmetry
cs = {symmetry('m-3m','mineral','Fe'),...   % crystal symmetry phase ferrite
    symmetry('m-3m','mineral','Au')};       % crystal symmetry phase ferrite

if (check_option(varargin, 'odf'))
    ss = symmetry('222');   % specimen symmetry
else
    ss = symmetry('-1');   % specimen symmetry
end


%% Loading

ebsd = a_load( fname, cs, ss, 'prometey', 206, 0,'flipY');

end

