close all;

ebsd = ses01_load;

x = get(ebsd,'x');
y = get(ebsd,'y');

minX = min(x); maxX = max(x);
minY = min(y); maxY = max(y);

st = 10;
ss = 20;

ixmax = fix((maxX-minX-ss)/st) - 1;
iymax = fix((maxY-minY-ss)/st) - 1;
        
par = {'iq','ci','fit'};
md   = [   0,   0,    1];
    
for iy = 0:iymax
    for ix = 0:ixmax
        ebsd_c = cutEBSD(ebsd, ix*st,iy*st,ss,ss);
        
        v = cell(1,3);
        vm = cell(1,3);
        h = zeros(1,3);
        l = zeros(1,3);

        for k = 1:length(par)
            v{k} = get(ebsd_c,par{k});
            h(k) = max(v{k});
            l(k) = min(v{k});
            if (md(k) == 1)
                vm{k} = 1-((v{k}-l(k))/(h(k)-l(k)));
            else
                vm{k} = (v{k}-l(k))/(h(k)-l(k));
            end
        end

        q = vm{1}.*vm{2}.*vm{3};

        o = get(ebsd_c(q>0.1), 'orientation');
        plotAllOrientations(o);
        saveimg(1,1,...
            'E:\Sergey\Dropbox\Projects\EBSD\селедки 2013\img\ss\',...
            'a', ['s_' int2str(iy) '_' int2str(ix)],'png','aaa');
    end
end