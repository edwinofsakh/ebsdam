%>>Образец файла загрузки EBSD данный с комментариями.
%>>За основу для написания нового файла лучше взять рабочий файл, например
%>>'s01_load()', сохранить его под новым именем и затем править.
%>>Для правильно загрузки данных нужно знать положение нужных колонок: 
%>> 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3'
%>>Если это неизвестно зарание, нужно открыть файл с данными в matlab'е
%>>(нестоит даже пробовать открыть файлы с данными в notepad/блокноте) и
%>>визуально найти нужные колонки.

%>>Название функции в формате [prefix + '_load']
%>>  prefix - начинается с буквы (правила названия функций), далее любые
%>>      символы
function [ ebsd ] = p01_load( varargin )
%>> Краткий комментарий к функции
%p01_load Load EBSD data from 'Prometey\Prometey_01.txt'
%>> Информация о образце
%  Supplier : Prometey >> поставщик
%  Material : bainite steel >> материал
%  Phases   : austenite, ferrite!, cementite >> фазы
%  Columns  : Phase ; x ; y ; Euler 1 ; Euler 2 ; Euler 3 ; Mad ; BC  >> порядок следования данных в файле 
%  Points   : 148996 (386x386)  >> кол-во точек
%  Size     : 308 x 308 um >> размеры образца
%  Step     : 800 nm >> шаг
%  Comments :  >> комментарий к образцу, можно указать термо обработку состав
%   37% of points not indexed.  

%% Settings >> Настройки окружения

% File name >> имя файла с данными (относительно директории с данными)
fname = '.\Prometey\Prometey_01.txt';

% Specify crystal and specimen symmetry >> Симметрия образца и фаз
CS = {...
  'notIndexed',...
  symmetry('m-3m','mineral','Au'),... % crystal symmetry phase austenite
  symmetry('m-3m','mineral','Fe'),... % crystal symmetry phase ferrite
  symmetry('m-3m','mineral','Cm')};   % crystal symmetry phase cementite

SS = symmetry('-1');   % specimen symmetry

% Load data director from preference >> директория с данными (меняется в другом месте)
DataDir = getpref('ebsdam','data_dir');


%% Loading >> Загрузка данных

% Load data
disp(['Loading EBSD data from "' fname '": ']);

% >> Для новых данных нужно изменить название колонок и их порядок.
% >> обязательно должны быть указаны колонки:
% >> 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3'
ebsd = loadEBSD(...
    [DataDir '\' fname],...%>> путь к файлу с данными
    CS, SS,...%>> симметрии
    'interface','generic',...
    'ColumnNames', { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3' 'MAD' 'BC'},...%>> колонки данных пресутстующие в файле с данными
    'Columns', [1 2 3 4 5 6 7 8],...%>> их порядок
    'Bunge');

disp('Done');

display(ebsd);


%% Processing >> Обработка

% Rotate data
plotx2east;%>> направляем ось х на восток
ebsd = flipud(ebsd);%>> переворачиваем верх в низ

end

