function [ ebsd ] = p03_load( varargin )
%p03_load Load EBSD data from 'Prometey\Prometey_03-2.txt'
%  Supplier : Prometey
%  Material : bainite steel
%  Phases   : austenite, ferrite!, cementite
%  Columns  : Phase ; x ; y ; Euler 1 ; Euler 2 ; Euler 3 ; Mad ; BC ; V1 ; V2 ; V3 ; V4
%  Points   : 114244 (338x338)
%  Size     : 269.6 x 269.6 um
%  Step     : 800 nm
%  Comments :
%   26% of points not indexed.  

%% Settings

% File name
fname = fullfile('.', 'Prometey', 'Prometey_03-2.txt');

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

% % Load data director from preference
% DataDir = getpref('ebsdam','data_dir');


%% Loading

ebsd = a_load( fname, cs, ss, 'ftim_p', 0, 0,'flipY');
% % Load data
% disp(['Loading EBSD data from "' fname '": ']);
% ebsd = loadEBSD([DataDir '\' fname], CS, SS, 'interface','generic',...
%   'ColumnNames', { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3' 'MAD' 'BC' 'V1' 'V2' 'V3' 'V4'},...
%   'Columns', [1 2 3 4 5 6 7 8 9 10 11 12],...
%   'Bunge');
% disp('Done');
% 
% display(ebsd);
% 
% 
% %% Processing
% 
% % Rotate data
% plotx2east;
% ebsd = flipud(ebsd);

end

