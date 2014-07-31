function [ OR, ORr, V, CP, B, in_cp, out_cp, in_b, out_b ] = getORVarInfo( )
%Get information about variants CP and Bain group.
%   From alpha to gamma.
%   Data from 'N. Takayama, G. Miyamoto, T. Furuhara. Effets of 
%   transformation temperature on variant pairing of bainitic ferrite in 
%   low carbon steel'.
%
% Output
%   OR      -
%   ORr     -
%   V       -
%   CP      -
%   B       -
%   dis_in  -
%   dis_out -

% History
% 15.11.12 Original implementation
% 21.11.12 Add comments.
% 22.11.12 Add cacheing

% Settings
doPlotting = 0;

% Load data director from preference
CacheDir = getpref('ebsdam','cache_dir');

% Name of MAT file with saveing variables 
matfile = [CacheDir '\VarInfo.mat'];

% Information about variants from paper
variants = {...
    % V  plane_g     plane_a     dir_g       dir_a      CP  B
    { 1, [ 1  1  1], [ 0  1  1], [-1  0  1], [-1 -1  1], 1, 1},...
    { 2, [ 1  1  1], [ 0  1  1], [-1  0  1], [-1  1 -1], 1, 2},...
    { 3, [ 1  1  1], [ 0  1  1], [ 0  1 -1], [-1 -1  1], 1, 3},...
    { 4, [ 1  1  1], [ 0  1  1], [ 0  1 -1], [-1  1 -1], 1, 1},...
    { 5, [ 1  1  1], [ 0  1  1], [ 1 -1  0], [-1 -1  1], 1, 2},...
    { 6, [ 1  1  1], [ 0  1  1], [ 1 -1  0], [-1  1 -1], 1, 3},...
    ...
    { 7, [ 1 -1  1], [ 0  1  1], [ 1  0 -1], [-1 -1  1], 2, 2},...
    { 8, [ 1 -1  1], [ 0  1  1], [ 1  0 -1], [-1  1 -1], 2, 1},...
    { 9, [ 1 -1  1], [ 0  1  1], [-1 -1  0], [-1 -1  1], 2, 3},...
    {10, [ 1 -1  1], [ 0  1  1], [-1 -1  0], [-1  1 -1], 2, 2},...
    {11, [ 1 -1  1], [ 0  1  1], [ 0  1  1], [-1 -1  1], 2, 1},...
    {12, [ 1 -1  1], [ 0  1  1], [ 0  1  1], [-1  1 -1], 2, 3},...
    ...
    {13, [-1  1  1], [ 0  1  1], [ 0 -1  1], [-1 -1  1], 3, 1},...
    {14, [-1  1  1], [ 0  1  1], [ 0 -1  1], [-1  1 -1], 3, 3},...
    {15, [-1  1  1], [ 0  1  1], [-1  0 -1], [-1 -1  1], 3, 2},...
    {16, [-1  1  1], [ 0  1  1], [-1  0 -1], [-1  1 -1], 3, 1},...
    {17, [-1  1  1], [ 0  1  1], [ 1  1  0], [-1 -1  1], 3, 3},...
    {18, [-1  1  1], [ 0  1  1], [ 1  1  0], [-1  1 -1], 3, 2},...
    ...
    {19, [ 1  1 -1], [ 0  1  1], [-1  1  0], [-1 -1  1], 4, 3},...
    {20, [ 1  1 -1], [ 0  1  1], [-1  1  0], [-1  1 -1], 4, 2},...
    {21, [ 1  1 -1], [ 0  1  1], [ 0 -1 -1], [-1 -1  1], 4, 1},...
    {22, [ 1  1 -1], [ 0  1  1], [ 0 -1 -1], [-1  1 -1], 4, 3},...
    {23, [ 1  1 -1], [ 0  1  1], [ 1  0  1], [-1 -1  1], 4, 2},...
    {24, [ 1  1 -1], [ 0  1  1], [ 1  0  1], [-1  1 -1], 4, 1},...
    };
    
if exist(matfile,'file')
    % Load saveing data
    load(matfile, 'OR', 'ORr', 'V', 'CP', 'B', 'in_cp', 'out_cp', 'in_b', 'out_b');
%     load_struct = load(matfile, {'OR', 'ORr', 'V', 'CP', 'B', 'in_cp', 'out_cp', 'in_b', 'out_b'});
%     ebsd = load_struct.ebsd;
else
    OR = cell(1,24);
    ORr = rotation();
    V = cell(1,24);
    CP = cell(1,24);
    B = cell(1,24);
    % vec1 = zeros(24*6,3);
    % vec2 = zeros(24*6,3);
    % vv = [1,0,0; 0,1,0; 0,0,1; -1,0,0; 0,-1,0; 0,0,-1];
    for i = 1:24
        vdata = variants{i};
        % ??? problem with transformation direction
        OR{i} = makeOR(vdata{3}',vdata{2}', vdata{5}',vdata{4}', 'a2g');
        ORr(i) = rotation('matrix', OR{i});
        V{i} = ['V' num2str(vdata{1})];
        CP{i} = ['CP' num2str(vdata{6})];
        B{i} = ['B' num2str(vdata{7})];
    %     for j = 1:6
    %         k = 6*(i-1)+j;
    %         vec1(k,:) = OR{i}'*vv(j,:)';
    %         vec2(k,:) = OR{i}*vv(j,:)';
    %     end
    end

    % uv1 = unique(vec1,'rows');
    % length(uv1)
    % scatter3(uv1(:,1),uv1(:,2),uv1(:,3));
    % 
    % uv2 = unique(vec2,'rows');
    % length(uv2)
    % return

    [in_cp, out_cp] = misprop(ORr, CP, 'CP', 4);
    [in_b,  out_b ] = misprop(ORr,  B,  'B', 3);

    save(matfile, 'OR', 'ORr', 'V', 'CP', 'B', 'in_cp', 'out_cp', 'in_b', 'out_b');
end

%% Plotting
if doPlotting
    %% Plotting options
    % Axis options
    from = '\gamma';
    cb = [0.5 0.5 0.5];

    % Markers type
    mt = {'o','^','s','p'};

    %% Plot CP group

    % Plot axis
    figure('Name', 'CP Group');
    plot([vector3d(1,0,0) vector3d(0,1,0) vector3d(0,0,1)],...
        'label', {['100' from],['010' from],['001' from]},...
        'antipodal','grid_res',15*degree, 'MarkerColor', cb);
    hold on;

    % Plot variants
    for i = 1:4
        id = ['CP' num2str(i)];
        ind = cellfun( @(x) strcmp(x,id), CP);
        rot = ORr(ind);
        p = [rot*vector3d(0,0,1); rot*vector3d(0,1,0); rot*vector3d(1,0,0)];
        % plot(p, 'antipodal', 'label', ['CP' num2str(i)], 'Marker',mt{i}); hold on;
        plot(p, 'antipodal', 'Marker',mt{i}); hold on;

    end
    legend('{100}_\gamma', 'CP1', 'CP2', 'CP3', 'CP4')
    hold off;

    %% Plot Bain group

    % Plot axis
    from = '\gamma';
    cb = [0.5 0.5 0.5];
    figure('Name', 'Bain Group');
    plot([vector3d(1,0,0) vector3d(0,1,0) vector3d(0,0,1)],...
        'label', {['100' from],['010' from],['001' from]},...
        'antipodal','grid_res',15*degree, 'MarkerColor', cb);
    hold on;

    % Plot variants
    for i = 1:3
        id = ['B' num2str(i)];
        ind = cellfun( @(x) strcmp(x,id), B);
        rot = ORr(ind);
        p = [rot*vector3d(0,0,1); rot*vector3d(0,1,0); rot*vector3d(1,0,0)];
        % plot(p, 'antipodal', 'label', ['CP' num2str(i)], 'Marker',mt{i}); hold on;
        % plot(p, 'antipodal', 'label', [V(ind) V(ind) V(ind)], 'Marker',mt{i}); hold on;
        plot(p, 'antipodal', 'Marker',mt{i}); hold on;

    end
    legend('{100}_\gamma', 'B1', 'B2', 'B3');
    hold off;
end

% % Check
% [~,~,umi1] = getAA(dis(dis_in));
% [~,~,umo1] = getAA(dis(dis_out));
% 
% umi1 = unique(umi1, 'rows')
% umo1 = unique(umo1, 'rows')
% 
% umi
% umi1
% umo
% umo1

% angle(umi)/degree
% angle(umo)/degree


end

function [dis_in, dis_out] = misprop( ORr, prop, name, nn )
%% Prepare
mis_in = rotation;
mis_out = rotation;
cs = symmetry('m-3m');
% ss = symmetry('-1');

%% Misorientation inside and outside package
% For all package calculate misorientation between in and out variants
for i = 1:nn
    % Select variants of i-th package 
    id = [name num2str(i)];
    ind_in = cellfun( @(x) strcmp(x,id), prop);
    rot_in = ORr(ind_in);
    n_in = length(rot_in);
    
    % Another variants is out package
    ind_out = ~ind_in;
    rot_out = ORr(ind_out);
    n_out = length(rot_out);
    
	% Misorientation between first and other variants in package
    oi1 = rot_in(1);
    for j = 2:n_in
        oi = rot_in(j);
        mis_in = horzcat(mis_in, oi \ oi1);
    end

    % Misorientation between all in package and all out package variants
    for j = 1:n_in
        oi = rot_in(j);
        for k = 1:n_out
            oo = rot_out(k);
            mis_out = horzcat(mis_out, oo \ oi);
        end
    end
end

% Convert to orientation to delete duplicate
mis_in1 = orientation(mis_in, cs,cs);
mis_out1 = orientation(mis_out, cs,cs);

% Transform to pairs of axis and angle. Description of misorientation as
% pair of axis and angle is very general (symmetry free)
[~,~,umi] = getAA(mis_in1);
[~,~,umo] = getAA(mis_out1);

% Find unique pairs ('unique' don't work with misorientation SS = CS ) 
umi = unique(umi, 'rows')
umo = unique(umo, 'rows')

% Get uniqie pairs of axis and angles by MTEX method ('pi' - correspondence
% between all and unique pairs)
[~, upairs, dis, ~, pi] = calcKOG3('KS');
upairs
dis

% Find unique pairs in package
upin = zeros(1,size(upairs,1));
for i = 1:size(umi,1)
    for j = 1:size(upairs,1)
        if (sum(abs(upairs(j,:) - umi(i,:))) < 0.1)
                upin(j) = 1; 
        end
    end
end

% Find misorentation in package (all, not only unique)
dis_in = zeros(1,length(dis));

upin = find(upin);

for i = 1:length(upin)
    dis_in(pi == upin(i)) = 1;
end
dis_out = ~dis_in;

dis_in = find(dis_in)
dis_out = find(dis_out)
end