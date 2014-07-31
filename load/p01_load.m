function [ ebsd ] = p01_load( varargin )
%p01_load Load EBSD data from 'Prometey\Prometey_01.txt'
%  Supplier : Prometey
%  Material : bainite steel
%  Phases   : austenite, ferrite!, cementite
%  Columns  : Phase ; x ; y ; Euler 1 ; Euler 2 ; Euler 3 ; Mad ; BC
%  Points   : 148996 (386x386)
%  Size     : 308 x 308 um
%  Step     : 800 nm
%  Comments :
%   37% of points not indexed.  

%% Settings

% File name
fname = '.\Prometey\Prometey_01.txt';

% Specify crystal and specimen symmetry
cs = {...
  'notIndexed',...
  symmetry('m-3m','mineral','Au'),... % crystal symmetry phase austenite
  symmetry('m-3m','mineral','Fe'),... % crystal symmetry phase ferrite
  symmetry('m-3m','mineral','Cm')};   % crystal symmetry phase cementite

if (check_option(varargin, 'odf'))
    ss = symmetry('222');   % specimen symmetry
else
    ss = symmetry('-1');   % specimen symmetry
end


%% Loading

ebsd = a_load( fname, cs, ss, 'ftim', 0, 0,'flipY');

end

