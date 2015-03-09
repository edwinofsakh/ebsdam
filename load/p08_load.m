function [ ebsd ] = p08_load( varargin )
% Load EBSD data from 'Prometey\EBSD_11D\11_D.ang'
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
fname = fullfile('.', 'Prometey', 'EBSD_11D','11_D.ang');

% Specify crystal and specimen symmetry
cs = symmetry('m-3m','mineral','Fe'); % crystal symmetry phase ferrite

if (check_option(varargin, 'odf'))
    ss = symmetry('222');   % specimen symmetry
else
    ss = symmetry('-1');   % specimen symmetry
end


%% Loading

ebsd = a_load( fname, cs, ss, 'prometey', 128, 0,'flipY');

end

