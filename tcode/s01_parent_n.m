close all;

angAng = 5;
angAxe = 5;

% load data
if ~exist('grains','var')
    strCmd = 'grains = getGrains(ebsd)';
    error('Variable "grains" is not init. Init Grains data useing command "%s"', strCmd);
end

figure();
plot(grains, 'antipodal');

% OR
OR = getOR('V1'); 

CS = symmetry('m-3m');
SS = symmetry('1');

[n, pairs] = neighbors(grains);

[~,upairs] = calcKOG('V1');
uaxe = vector3d(upairs(:,2),upairs(:,3),upairs(:,4));

h = waitbar(0,'Initializing waitbar...');

np = [];
GrainsGroup = [];
GrainsGroup = [GrainsGroup ; 1 1];
ngg = 2;

for ig = 1:numel(grains)

    % find grain in list
    ind = GrainsGroup(:,1) == ig;
    
    if (ind == 0)
        % for new grain and new group
        igg = ngg;
        ngg = ngg + 1;
        GrainsGroup = [GrainsGroup; ig igg];
    else
        igg = GrainsGroup(ind,2);
        igg = igg(1);
    end
    
    o1 = get(grains(ig),'meanOrientation');
    ind = pairs(:,1) == ig;
    ipairs = pairs(ind,:);
    
    for i = 1:size(ipairs,1);
        in = ipairs(i,2);
        o2 = get(grains(in),'meanOrientation');
        ang = angle(o1\o2) / degree;
        axe = axis(o1\o2);
        
        testAng = abs(upairs(:,1)-ang);
        testAxe = angle(axe,uaxe(:)) / degree;
        tAng = (testAng < angAng);
        tAxe = (testAxe < angAxe);
        if (any(tAng & tAxe))
            disp([num2str(ig) ' - ' num2str(in)]);

            GrainsGroup = [GrainsGroup; in igg];
            
            np = [np; ig in];
        end
    end
    
    waitbar(ig/numel(grains),h,'Find parent...')
end

close(h);

