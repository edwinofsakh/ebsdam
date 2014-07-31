function [ ebsd ] = s01_load( varargin )
%s01_load Load EBSD data from 'export_bainite_1.txt'
%  Supplier : FTIM
%  Material : bainite steel
%  Phases   : austenite, ferrite!, cementite
%  Columns  : Phase ; x ; y ; Euler 1 ; Euler 2 ; Euler 3 ; Mad ; BC
%  Points   : 187489 (433x433)
%  Size     : 216 x 216 um
%  Step     : 500 nm
%  Comments :
%	For more details see file "report_s01.txt"

%% Settings

% Sample ID
sid = 's01';

% File name
fname = '.\export_bainite_1.txt';

% Specify crystal and specimen symmetry
cs = {...
  symmetry('m-3m','mineral','Au'),... % crystal symmetry phase austenite
  symmetry('m-3m','mineral','Fe'),... % crystal symmetry phase ferrite
  symmetry('m-3m','mineral','Cm')};   % crystal symmetry phase cementite
  
if (check_option(varargin, 'odf'))
    ss = symmetry('222');   % specimen symmetry
else
    ss = symmetry('-1');   % specimen symmetry
end

%% Loading

ebsd = a_load( fname, cs, ss, 'ftim', 0, 0,0);
  
end

