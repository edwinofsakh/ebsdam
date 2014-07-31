function parent_merge(grains, OR_name)
%parent_merge Find prior austenite grains useing MTEX::GrainSet::merge.
%	Function merge grains if misorientation between them is the same as between 
%   different variants of orientation relation.


% getOR('V1');
[~,~,dis,udis] = calcKOG_new(OR_name);

% merged_grains = cell(1,24);
% merged_grains{1} = grains;
% 
% figure();
% plot(grains);
% 
% for i=2:24
%     m_grains = merge(merged_grains{i-1},dis(i));
%     merged_grains{i} = m_grains;
%     disp(num2str(i));
%     
%     figure();
%     plot(merged_grains{i});
% end

%grains = grains;

figure();
plot(grains);

merged_grains = merge(grains,rotation(rotation(dis)));

figure();
plot(merged_grains);

% spy(I_PC)
% xlabel('child (index)'), ylabel('parent (index)')