% Test Noise

%%
ebsd = af01s_load();
ebsd1 = cutEBSD(ebsd, 0,0, 100,100);
plot(ebsd1, 'antipodal')

grains1 = getGrains(ebsd1, 2*degree, 4);

mis = get(grains1, 'mis2mean');
figure; hist(angle(mis)/degree,24)

%%
ebsd = af04s_load();
ebsd1 = cutEBSD(ebsd, 0,0, 100,100);
plot(ebsd1, 'antipodal')

grains1 = getGrains(ebsd1, 2*degree, 4);

mis = get(grains1, 'mis2mean');
figure; hist(angle(mis)/degree,24)

for i = 1:10
    mis = get(grains1(i), 'mis2mean');
    a = angle(mis)/degree;
    figure; hist(a(a<1.5),0.1:0.1:1.5);
end

%%
ebsd = af04_load();
ebsd1 = cutEBSD(ebsd, 0,0, 500,500);
plot(ebsd1, 'antipodal')

grains1 = getGrains(ebsd1, 2*degree, 4);

mis = get(grains1, 'mis2mean');
figure; hist(angle(mis)/degree,24)
