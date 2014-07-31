% clear all;
% close all;
% 
% p = path;
% path(p,'func');
% 
% MisAng = 5;
% SmallGrain = 25;
% PrAng = 10;
% 
% % load data
% ebsd = s01_load();
% 
% ind = inpolygon(ebsd,[0 0; 0 4; 4 4; 4 0; 0 0]);
% ebsd = ebsd(ind)
% l = sqrt(numel(ebsd));
% 
% 
% o  = get(ebsd('Fe'),'orientations');
% 
% x = get(ebsd('Fe'),'x')/0.5 + 1;
% y = get(ebsd('Fe'),'y')/0.5 + 1;
% 
% omap = cell(l,l);
% for i =1:length(o)
%     omap{x(i),y(i)} = o(i);
% end
% 
% nx = l;
% ny = l;
% 
% % i -  x    y   i -  x    y
% % 1 - 0.0, 0.0; 2 - 0.5, 0.0
% 
% 
% % symmetry
% cs = symmetry('m-3m');
% ss = symmetry('-1');
% 
% % orientaion relation
% OR_V1 = [ 0.7174  -0.6952  -0.0450;
%           0.6837   0.7150  -0.1464;
%           0.1340   0.0742   0.9882; ];
%       
% Vfb = rotation('matrix', OR_V1);
% 
% step  = 3;
% shift = 3;
% np = step^2;
% 
% nxi = floor ((nx-(step-shift)) / shift);
% nyi = floor ((ny-(step-shift)) / shift);
% 
% % x0 = Euler(Vfb \ Mbcc{1}{1},'Bunge');
% % Mfcc = orientation ('Euler', x(1),x(2),x(2), cs,ss);

Sym = symmetrise (orientation ('Euler', 0,0,0, cs,ss));
nSym = length (Sym);

ThetaMap = zeros(nxi,nyi);
for xi = 1:nxi
    for yi = 1:nyi
        Mbcc = cell(1, np);
        zeros
        ii = 1;
        for i = 1:step
            for j = 1:step
                % points(ii) = o( (xi-1)*shift + (yi-1)*shift*nx + i + (j-1)*nx );
                if ~isempty(omap( (xi-1)*shift + i, (yi-1)*shift + j ))
                    Mbcc{ii} = omap( (xi-1)*shift + i, (yi-1)*shift + j );
                    ii = ii + 1;
                end
            end
        end
        
        if (ii < 5)
            Theta = 0;
        else
            Mfcc0 = Vfb \ Mbcc{1}{1};
            x0 = Euler(Mfcc0,'Bunge');
            [N, T] = minSym (Vfb, Mfcc0, Mbcc, ii-1, Sym, nSym );
            Theta = optimizeTheta( x0, ii-1, Mbcc, Vfb, cs, ss, N );
        end

        ThetaMap(xi,yi) = Theta;
        
        disp([num2str(xi) '-' num2str(yi)]);
    end
end


path(p);


