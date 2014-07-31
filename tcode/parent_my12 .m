groups = {};
group_id_max = 0;
link = zeros(1,n);
for i = 1:n
    % select group
    group_id = link(i);
    if (group_id == 0)
        % create new group
        group = [];
        group = [group, i];
        group_id_max = group_id_max + 1;
        group_id = group_id_max;
        link(i) = group_id;
    else
        % get group by link
        group_id = link(i);
        group = groups{group_id};
    end
    
    % check heighbors
    indn = neigh{i};
    for j = 1:nnt(i)
        a1 = any(pairs_all(:,1) == i & pairs_all(:,2) == indn(j));
        a2 = any(pairs_all(:,2) == i & pairs_all(:,1) == indn(j));
        if (a1 || a2)
            test = find(group == indn(j));
            if (isempty(test))
                group = [group, indn(j)];
                link(indn(j)) = group_id;
            end
        end
    end
    
    % save group
    groups{group_id} = group;
end

h = waitbar(0,'Please wait...');
i = 1;
new_groups = {};
ni = 1;
list = ones(1,length(groups));
ind = [1:length(groups)];
while any(list)
    if (list(i) == 1)
        list(i) = 0;
        group = groups{i};
        new_group = group;
        
        flag = 1;
        while flag
            flag = 0;
            nn = length(new_group);

            for j = 1:nn
                groups_m = groups(logical(list));
                list_m = list;
                new_group_m = new_group;
                for k = 1:length(groups_m)
                    test = find(groups_m{k} == new_group(j));
                    
                    if (new_group(j) == 72 || new_group(j) == 74)
                        test_D = 1;
                    end
                    
                    if (new_group(j) == 1 || new_group(j) == 16)
                        test_D = 1;
                    end
                    
                    if (~isempty(test))
                        flag = 1;
                        new_group_m = [new_group_m groups_m{k}];
                        new_group_m = unique(new_group_m);
                        ind_m = ind(logical(list));
                        list_m(ind_m(k)) = 0;
                    end
                end
                new_group = new_group_m;
                list = list_m;
            end
        end
        
        new_groups{ni} = new_group;
        ni = ni+1;
    end
    i = i+1;
    waitbar(1-length(find(list))/length(list));
end
close(h);

sum = 0;
for i = 1:length(new_groups)
    sum = sum + length(new_groups{i});
end
disp(num2str(sum));
