function [ ebsd ] = x27_load( )
%f33_load Load EBSD data from 'X100\*.txt'
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
fname = '.\X100\2-7.txt';

% Specify crystal and specimen symmetry
cs = {...
  symmetry('m-3m','mineral','Cm'),... % crystal symmetry phase cementite
  symmetry('m-3m','mineral','Fe'),... % crystal symmetry phase ferrite
  symmetry('m-3m','mineral','Au')};   % crystal symmetry phase austenite
  
ss = symmetry('-1');   % specimen symmetry


%% Loading

ebsd = a_load( fname, cs, ss, 'ftim_f', 0, 0,0);

end


