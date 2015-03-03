function [ ebsd ] = s04_load4( varargin )
%s04_load Load EBSD data from 'X100-2_4.txt'
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
fname = '.\Exp FTIM\X100-2_4.txt';

% Specify crystal and specimen symmetry
cs = {...
  crystalSymmetry('m-3m','mineral','Au'),... % crystal symmetry phase austenite
  crystalSymmetry('m-3m','mineral','Fe'),... % crystal symmetry phase ferrite
  crystalSymmetry('m-3m','mineral','Cm')};   % crystal symmetry phase cementite

if (check_option(varargin, 'odf'))
    ss = specimenSymmetry('222');   % specimen symmetry
else
    ss = specimenSymmetry('-1');   % specimen symmetry
end
%% Loading

% ebsd = ftim_load( fname, cs, ss, 0, 0, 0, 1 );
ebsd = a_load( fname, cs, ss, 'ftim', 0, 0,'flipY');

end

