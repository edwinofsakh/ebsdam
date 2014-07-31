mtr = getOR('KS');

ORr = rotation('matrix', mtr);
vgp = vector3d(1,1,1);
vgd = vector3d(-1,0,1);

vap = vector3d(0,1,1);
vad = vector3d(-1,-1,1);

ORr*vgp
ORr*vgd

ORr*vap
ORr*vad

CS = symmetry('m-3m');
SS = symmetry('m-3m');

ORr = rotation('matrix', mtr);
ORoa = rotation(CS) * ORr;

MM = matrix(ORoa);

mtr1 = makeOR([0,1,1]',[1,1,1]',[-1,-1,1]',[-1,0,1]','a2g');
mtr14 = makeOR([0,1,1]',[-1,1,1]',[-1,1,-1]',[0,-1,1]','a2g');
mtr1

c = 0;
for i = 1:size(MM,3)
    MM(:,:,i)
    if norm(MM(:,:,i)-mtr1) < 0.1
        ii = i;
        c = c+1;
    end
end

ii
c

mtr14

c = 0;
for i = 1:size(MM,3)
    if norm(MM(:,:,i)-mtr14) < 0.1
        ii = i;
        c = c+1;
    end
end