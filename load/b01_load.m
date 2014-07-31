function [ ebsd ] = b01_load( varargin )
%b01_load Load EBSD data from 'Zolot_beinit\12.txt'
%  Supplier : Prometey
%  Material : bainite steel
%  Phases   : ferrite!, austenite
%  Columns  : j1; F; j2; x; y; IQ; CI; Phase ID; Detector Intensity; V2;
%  Points   : 136290 (324.5x420)
%  Size     : 22.64500 x 25.40053 um
%  Step     : 70.0000 x 60.0625 nm
%  Comments :
%   Ingnore phase. For more details see file ".\Zolot_beinit\12.doc"

%% Settings

% File name
fname = '.\Zolot_beinit\12.txt';

% Specify crystal and specimen symmetry
cs = symmetry('m-3m','mineral','Fe'); % crystal symmetry phase ferrite
  
if (check_option(varargin, 'odf'))
    ss = symmetry('222');   % specimen symmetry
else
    ss = symmetry('-1');   % specimen symmetry
end


%% Loading

% ebsd = a_prometey_load( fname, cs, ss, 124, 1, 0,1);
ebsd = a_load( fname, cs, ss, 'prometey', 124, 0,'flipY');

end


