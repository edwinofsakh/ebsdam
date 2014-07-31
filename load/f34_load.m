function [ ebsd ] = f34_load( varargin )
%f33_load Load EBSD data from 'FTIM\3-3-500-1.txt'
%  Supplier : FTIM
%  Material : ***
%  Phases   : cementite, ferrite, austenite
%  Columns  : 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3' 'MAD' 'BC' 'RI' 'M11' 'M12' 'M13' 'M21' 'M22' 'M23' 'M31' 'M32' 'M33'
%  Points   : ***
%  Size     : *** x *** um
%  UnitCell : [-0.25 0.25;0.25 0.25;0.25 -0.25;-0.25 -0.25] um
%  Comments :
%   Ingnore phase. For more details see file ".\FTIM\readme.doc"

%% Settings

% File name
fname = '.\FTIM\3-4-500-1.txt';

% Specify crystal and specimen symmetry
cs = {...
  symmetry('m-3m','mineral','Fe'),... % crystal symmetry phase ferrite
  symmetry('m-3m','mineral','Cm'),... % crystal symmetry phase cementite
  symmetry('m-3m','mineral','Au')};   % crystal symmetry phase austenite
  
if (check_option(varargin, 'odf'))
    ss = symmetry('222');   % specimen symmetry
else
    ss = symmetry('-1');   % specimen symmetry
end


%% Loading

ebsd = a_load( fname, cs, ss, 'ftim_f', 0, 0,0);

end


