close all;

% �������� ������
ebsd = s01_load();

% ���������� �������: ����� ������� � �������
x = 0; y = 0;
dx = 100; dy = 100;

% �������� ������ �������
ebsd = cutEBSD(ebsd, x, y, dx, dy);

% ���������� �����
grains = getGrains(ebsd, 3*degree, 8);

% ��������� ����� ��� ��������
plot(grains);