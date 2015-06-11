%>>������� ����� �������� EBSD ������ � �������������.
%>>�� ������ ��� ��������� ������ ����� ����� ����� ������� ����, ��������
%>>'s01_load()', ��������� ��� ��� ����� ������ � ����� �������.
%>>��� ��������� �������� ������ ����� ����� ��������� ������ �������: 
%>> 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3'
%>>���� ��� ���������� �������, ����� ������� ���� � ������� � matlab'�
%>>(������� ���� ��������� ������� ����� � ������� � notepad/��������) �
%>>��������� ����� ������ �������.

%>>�������� ������� � ������� [prefix + '_load']
%>>  prefix - ���������� � ����� (������� �������� �������), ����� �����
%>>      �������
function [ ebsd ] = p01_load( varargin )
%>> ������� ����������� � �������
%p01_load Load EBSD data from 'Prometey\Prometey_01.txt'
%>> ���������� � �������
%  Supplier : Prometey >> ���������
%  Material : bainite steel >> ��������
%  Phases   : austenite, ferrite!, cementite >> ����
%  Columns  : Phase ; x ; y ; Euler 1 ; Euler 2 ; Euler 3 ; Mad ; BC  >> ������� ���������� ������ � ����� 
%  Points   : 148996 (386x386)  >> ���-�� �����
%  Size     : 308 x 308 um >> ������� �������
%  Step     : 800 nm >> ���
%  Comments :  >> ����������� � �������, ����� ������� ����� ��������� ������
%   37% of points not indexed.  

%% Settings >> ��������� ���������

% File name >> ��� ����� � ������� (������������ ���������� � �������)
fname = '.\Prometey\Prometey_01.txt';

% Specify crystal and specimen symmetry >> ��������� ������� � ���
CS = {...
  'notIndexed',...
  symmetry('m-3m','mineral','Au'),... % crystal symmetry phase austenite
  symmetry('m-3m','mineral','Fe'),... % crystal symmetry phase ferrite
  symmetry('m-3m','mineral','Cm')};   % crystal symmetry phase cementite

SS = symmetry('-1');   % specimen symmetry

% Load data director from preference >> ���������� � ������� (�������� � ������ �����)
DataDir = getpref('ebsdam','data_dir');


%% Loading >> �������� ������

% Load data
disp(['Loading EBSD data from "' fname '": ']);

% >> ��� ����� ������ ����� �������� �������� ������� � �� �������.
% >> ����������� ������ ���� ������� �������:
% >> 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3'
ebsd = loadEBSD(...
    [DataDir '\' fname],...%>> ���� � ����� � �������
    CS, SS,...%>> ���������
    'interface','generic',...
    'ColumnNames', { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3' 'MAD' 'BC'},...%>> ������� ������ ������������� � ����� � �������
    'Columns', [1 2 3 4 5 6 7 8],...%>> �� �������
    'Bunge');

disp('Done');

display(ebsd);


%% Processing >> ���������

% Rotate data
plotx2east;%>> ���������� ��� � �� ������
ebsd = flipud(ebsd);%>> �������������� ���� � ���

end

