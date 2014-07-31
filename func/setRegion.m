function [x, y] = setRegion(sid, ebsd)

ebsd = checkEBSD(sid, ebsd, 0);

plot(ebsd, 'antipodal', 'r', zvector);

[x,y] = ginput();

disp('  X    Y');
disp([x y]);
end