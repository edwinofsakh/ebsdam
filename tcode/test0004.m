close all;

ebsd = ses01_load;

% find coordiantes limits
x = get(ebsd,'x');
y = get(ebsd,'y');
minX = min(x); maxX = max(x);
minY = min(y); maxY = max(y);

% Size searching area and step
st = 10; % step
ss = 20; % size of searching area

% Calculate max X and Y for good stepping
ixmax = fix((maxX-minX-ss)/st) - 1;
iymax = fix((maxY-minY-ss)/st) - 1;


par = {'iq','ci','fit'};
md   = [   0,   0,    1];
    
for iy = 0:iymax
    for ix = 0:ixmax
        ebsd_c = cutEBSD(ebsd, ix*st,iy*st,ss,ss);
        
        ebsd_cf = simpleFilter( ebsd_c, cr )

        o = get(ebsd_cf, 'orientation')
        plotAllOrientations(o);
        saveimg(1,1,...
            'E:\Sergey\Dropbox\Projects\EBSD\селедки 2013\img\ss1\',...
            'a', ['s_' int2str(iy) '_' int2str(ix)],'png','aaa');
    end
end