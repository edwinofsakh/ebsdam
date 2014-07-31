function [ngv] = parent_v2_analyze(sid, grains, OR_name, eps)
%Find prior austenite grains useing info about grains pair.
%   Compare misoreantion of mean grains' orientation with misorientation
%   between variants of oreantation relatinon.
%	Arguments:
%   	type - compare mechanism.
%           1 - angle only ( eps1 );
%           2 - angle and axe (eps1 and eps2);
%           3 - disorientation.
%

load([sid '_v_maps.mat'],'v_maps', 'pairs');

% Number of grains
n = numel(grains);

% Number of pairs
n2 = length(pairs);

% Calculate misorenation between variants of oreintation relation.
[~,~,dis,~] = calcKOG_new(OR_name);

% Number of variants
nv = length(dis);

% Minumal frequency
d_nav = 0.2;

% Frequency for good variant
d_ngv = 0.9999;

% Number of good variants per pair
ngv = zeros(n2,1);

test1 = 0;
test2 = 0;
testm = 0;
testg = 0;
maxo = 0;

h = waitbar(0,'Please wait...');
for i = 1:n2
    % Variants' frequency
    v_f = zeros(nv,1);
    
    v_map = v_maps{i};
    
    nm = size(v_map,1);
    
    % Find match with OR's misorientation
    for j = 1:nv
        ind = v_map(:,j) > cos(eps/2);
        v_f(j) = length(find(ind))/nm;
    end
    
%     % Number of acvite variants
%     nav = length(find(v_f > d_nav));
%     
    % Number of good variants
    ngv(i) = length(find(v_f > d_ngv));
    
    if ngv(i) > 8
        test2 = test2 + 1;
    end
    
    if ngv(i) > 0
        testg = testg + 1;
    end
    
    if nm < 2
        test1 = test1 + 1;
    end
    
    if nm > 30
%         ngv(i) = 0;
        testm = testm + 1;
        if maxo < nm
            maxo = nm;
        end
    end
    
%     if ngv(i) == 0
%         test = test + 1;
%         
%         v_map_i = v_map > cos(eps/2);
%         v_c = sum(v_map_i(:,v_f > d_nav),2);
%         v_fm = length(find(v_c))/nm;
%         
%         % Find multi variantsfind(v_fm - min(v_fm));
%         if ((v_fm > d_ngv) )
%             test = test - 1;
%             ngv(i) = 2;
%         end
%     end
    
%     if ngv(i) > 5
%         test = 1;
%     end
    
    waitbar(i/n2, h);
end
delete(h);

disp(['<  2 orientations :' num2str(test1) '/' num2str(n2)]);
disp(['> 30 orientations :' num2str(testm) '/' num2str(n2)]);

disp(['good variants :' num2str(testg) '/' num2str(n2)]);
disp(['> 8  variants :' num2str(test2) '/' num2str(n2)]);
disp(['maxo :' num2str(maxo)]);

[group, cmap] = merge_grains( pairs(ngv > 0,:), n );

disp(['max group :' num2str(max(group))]);

plot(grains, 'property',cmap(group,:));
hold on, plotBoundary(grains,'property','angle','linewidth',1.5,'extern');
colorbar
hold off