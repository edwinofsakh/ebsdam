function [ ebsd ] = af04s_load( varargin )
%Load EBSD data from 'Austenite_frag\1-4_ang\4_small area.ang'
%  Supplier : Prometey
%  Material : austenite steel
%  Phases   : austenite
%  Columns  : j1; F; j2; x; y; IQ; CI; Phase ID; Detector Intensity; V2;
%  Points   : 525723 (???x???)
%  Size     : ??? x ??? um
%  Step     : ??? x ??? nm
%  Comments :
%   Ingnore phase. For more details see file "N/A"

%% Settings

% File name
fname = '.\Austenite_frag\1-4_ang\4_small area.ang';

% Specify crystal and specimen symmetry
cs = symmetry('m-3m','mineral','Fe'); % crystal symmetry phase ferrite
  
if (check_option(varargin, 'odf'))
    ss = symmetry('222');   % specimen symmetry
else
    ss = symmetry('-1');   % specimen symmetry
end


%% Loading

% ebsd = a_prometey_load( fname, cs, ss, 97, 1,  0,1);
ebsd = a_load( fname, cs, ss, 'prometey', 97, 0,'flipY');

end
