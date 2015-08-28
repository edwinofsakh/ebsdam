close all;

% Загрузка данных
ebsd = s01_load();

% Вырезаемая область: точка отсчета и размеры
x = 0; y = 0;
dx = 100; dy = 100;

% Вырезаем нужный участок
ebsd = cutEBSD(ebsd, x, y, dx, dy);

% Определяем зерна
grains = getGrains(ebsd, 3*degree, 8);

% Оторажаем зерна для проверки
plot(grains);