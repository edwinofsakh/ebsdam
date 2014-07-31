clear all;
close all;

ebsd = af03_load;
ebsd = fliplr(ebsd);
plotx2north;
ebsd_c = cutEBSD(ebsd, 0,0,100.5,100.5);
o = get(ebsd_c, 'orientation');

plot(ebsd_c, 'antipodal');

X = get(ebsd_c, 'X');
Y = get(ebsd_c, 'Y');

Yu = unique(fix(Y*1000)/1000);
Xu = unique(fix(X*1000)/1000);

Xm1 = X(abs(Y -  Yu(2)) < 0.01);

nx = length(Xm1);
ny = length(Yu);

dx = abs(Xm1(2)-Xm1(1));
dy = abs(Yu(2)-Yu(1));

Xm = repmat(Xm1, ny,1);
Ym = repmat(Yu(end:-1:1), 1,nx);
Ym = reshape(Ym', nx*ny,1);

for i = 1:ny
    if mod(i,2) == 0
        ind = abs(Y -  Yu(i)) < 0.01;
        qm = [qm; o(ind)];
    else
        ind = find(abs(Y -  Yu(i)) < 0.01);
        if length(ind) ~= nx+1
            a = t;
        end
        
        i1 = ind(1:end-1);
        i2 = ind(2:end);
        qm1 = (o(i1) + o(i2))/2;
        
        for j = 1:length(i1)
            qm1(j) = mean([o(i1(j)) o(i2(j))]);
        end
        
        if (i == 1)
            qm = qm1;
        else
            qm = [qm; qm1];
        end
    end
end

CS = get(ebsd, 'CS');
SS = get(ebsd, 'SS');

om = orientation(qm, CS,SS);

ebsd_cm = EBSD(om);
ebsd_cm = set(ebsd_cm,'x',Xm(:));
ebsd_cm = set(ebsd_cm,'y',Ym(:));
ebsd_cm = set(ebsd_cm,'unitCell',[0 0; dx 0; dx dy; 0 dy]);
ebsd_cm = flipud(ebsd_cm);

figure;
plot(ebsd_cm, 'antipodal');