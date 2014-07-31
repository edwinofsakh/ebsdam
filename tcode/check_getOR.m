% Check getOR

checkPlottiing = 1;
checkEulerAngles = 1;
checkORDirection = 1;
viewORAxis = 1;

ss = symmetry('1');
cs = symmetry('m-3m');

cb = [0.5 0.5 0.5];
 
plotx2south;

%% Check by plotting
if checkPlottiing 
    names = {'KS', 'NW', 'M1', 'M2', 'B1', 'B2', 'B3'};
    n = length(names);
    o = cell(1,n);

    for i = 1:n
        o{i} = orientation('matrix',getOR(names{i}),cs,ss);
    end

    % {100} {010} {001}
    figure();
    cmap = colormap(hsv(n));
    
    plotOR(o,0, cmap);
    
%     plot([vector3d(1,0,0) vector3d(0,1,0) vector3d(0,0,1)],...
%         'label', {'100\gamma','010\gamma','001\gamma'},...
%         'antipodal','grid_res',30*degree, 'MarkerColor', cb), hold on;
% 
%     plot(o{1}, 'antipodal','all',...
%         'MarkerSize',5, 'MarkerColor',cmap(1,:)), hold on;
% 
%     for i = 2:n
%         plot(o{i}, 'label',0, 'antipodal','all',...
%             'MarkerSize',5, 'MarkerColor',cmap(i,:)), hold on;
%     end
    legend({'(100)\gamma', names{:}}, 'Location', 'EastOutside');
    hold off;


    % all
    figure();
    cmap = colormap(hsv(n));
    
    plotOR(o,1, cmap);
    
%     plot([vector3d(1,0,0) vector3d(0,1,0) vector3d(0,0,1)],...
%         'label', {'100\gamma','010\gamma','001\gamma'},...
%         'antipodal','grid_res',30*degree, 'MarkerColor', cb), hold on;
% 
%     for i = 1:n
%         ORo = rotation(o{i});
%         ORoa = rotation(cs) * ORo;
%         v = unique(ORoa*rotation(cs)*vector3d(1,0,0));
%         plot(v, 'label',0, 'antipodal',...
%             'MarkerSize',5, 'MarkerColor',cmap(i,:)), hold on;
%     end
    legend({'(100)\gamma', names{:}}, 'Location','EastOutside');
    hold off;
end
 
%% Check euler angles
if checkEulerAngles
    % To get matrix from euler angle use:
    %   matrix(orientation('euler',e1,e2,e3,cs,ss))

    e = zeros(n,3);
    for i = 1:n
        e(i,:) = Euler(o{i});
    end

    disp(' ');
    disp('  OR order:');
    disp(names);
    disp(' ');
    disp('  Bunge Euler angles in degree');
    disp('     phi1     Phi    phi2');
    disp(e/degree);
end

%% Check transformation direction
if checkORDirection
    names = {'KS', 'NW'};
    n = length(names);
    o = cell(1,n);

    for i = 1:n
        o{i} = orientation('matrix',getOR(names{i}),cs,ss);
    end

    for i = 1:n
        figure();
    %     plot([vector3d(1,0,0) vector3d(0,1,0) vector3d(0,0,1)],...
    %         'label', {'100\gamma','010\gamma','001\gamma'},...
    %         'antipodal','grid_res',30*degree, 'MarkerColor', cb), hold on;
    % 
    %     ORo = rotation(o{i});
    %     ORoa = rotation(cs) * ORo;
    %     v = unique(ORoa*rotation(cs)*vector3d(1,0,0));
    %     plot(v, 'label',0, 'antipodal',...
    %         'MarkerSize',5, 'MarkerColor','k'), hold on;
        plotOR( o{i}, 0, 'k');

        u = axis(rotation(o{i}))
        a = angle(rotation(o{i}))/degree
        plot(u); hold on;
        plot(rotation(cs)*vector3d(1,1,2)); hold on;
        tKS = orientation('axis',vector3d(1,1,2),'angle',90*degree,cs,ss);
        plotOR( tKS, 1, 'k');

        title(names{i}, 'FontWeight','bold');
        hold off;
    end

    for i = 1:n
        o{i} = orientation('matrix',transpose(getOR(names{i})),cs,ss);
    end

    for i = 1:n
        figure();
    %     plot([vector3d(1,0,0) vector3d(0,1,0) vector3d(0,0,1)],...
    %         'label', {'100\gamma','010\gamma','001\gamma'},...
    %         'antipodal','grid_res',30*degree, 'MarkerColor', cb), hold on;
    % 
    %     ORo = rotation(o{i});
    %     ORoa = rotation(cs) * ORo;
    %     v = unique(ORoa*rotation(cs)*vector3d(1,0,0));
    %     plot(v, 'label',0, 'antipodal',...
    %         'MarkerSize',5, 'MarkerColor','k'), hold on;
        plotOR( o{i}, 0, 'k');

        u = axis(rotation(o{i}))
        a = angle(rotation(o{i}))/degree
        plot(u); hold on;
        plot(rotation(cs)*vector3d(1,1,2)); hold on;
        plotOR( tKS, 1, 'k');

        title([names{i} ' Transpose'], 'FontWeight','bold');
        hold off;
    end
end

% View Axis
if viewORAxis
    ORo = rotation(o{i});
    ORoa = rotation(cs) * ORo;
    axis(ORoa)
end

plotx2north;