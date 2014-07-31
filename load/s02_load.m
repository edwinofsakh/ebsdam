function [ ebsd ] = s02_load( varargin )
%s02_load Load EBSD data from '1000-300-100.txt'
%  Supplier : Prometey
%  Material : bainite steel
%  Phases   : ferrite!, austenite
%  Columns  : j1; F; j2; x; y; IQ; CI; Phase ID; Detector Intensity; V2;
%  Points   : 555880 (534.5x1040)
%  Size     : 26.70000 x 44.99002 um
%  Step     : 50.0000 x 43.3025 nm
%  Comments :
%   For more details see file "Данные по x y.txt" (renamed to "1000-300-100_help.txt")

%% Settings

% File name
fname = '.\1000-300-100.txt';

% Specify crystal and specimen symmetry
cs = {...
  symmetry('m-3m','mineral','Fe'),... % crystal symmetry phase ferrite
  symmetry('m-3m','mineral','Au')};   % crystal symmetry phase austenite

if (check_option(varargin, 'odf'))
    ss = symmetry('222');   % specimen symmetry
else
    ss = symmetry('-1');   % specimen symmetry
end


%% Loading


ebsd = a_load( fname, cs, ss, 'prometey', 200, 0,'flipY');

end

