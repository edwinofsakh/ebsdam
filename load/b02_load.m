function [ ebsd ] = b02_load( varargin )
%b01_load Load EBSD data from 'Zolot_beinit\12_pole.txt'
%  Supplier : Prometey
%  Material : bainite steel
%  Phases   : ferrite!, austenite
%  Columns  : j1; F; j2; x; y; IQ; CI; Phase ID; Detector Intensity; V2;
%  Points   : 479447 (???x???)
%  Size     : ??? x ??? um
%  Step     : ??? x ??? nm
%  Comments :
%   Ingnore phase. For more details see file ".\Zolot_beinit\12_pole.doc"

%% Settings

% File name
fname = '.\Zolot_beinit\12_pole.txt';

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


