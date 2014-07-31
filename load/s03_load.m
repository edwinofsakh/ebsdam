function [ ebsd ] = s03_load( varargin )
%s03_load Load EBSD data from 'X90-4.txt'
%  Supplier : FTIM
%  Material : bainite steel
%  Phases   : austenite, ferrite!, cementite.
%  Columns  : Phase ; x ; y ; Euler 1 ; Euler 2 ; Euler 3 ; Mad ; BC
%  Points   : 292681 (541x541)
%  Size     : 216 x 216 um
%  Step     : 400 nm
%  Comments :
%

%% Settings

% File name
fname = '.\Exp FTIM\X90-4.txt';

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

% ebsd = ftim_load( fname, cs, ss, 0, 0, 0, 1 );
ebsd = a_load( fname, cs, ss, 'ftim', 0, 0,'flipY');

end

