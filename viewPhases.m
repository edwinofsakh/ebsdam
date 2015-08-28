function out = viewPhases( sid, rid, region, ebsd, tasks, varargin ) %#ok<INUSL,INUSD>
% Draw phase map and individual oreantation map for phase
%
% Syntax
%   out = viewPhases( sid, rid, region, ebsd, tasks, varargin )
%
% Output
%   out - not used
%
% Input
%   sid      - sample id: 's01', 's02', 's03', 's04', 't01', 'p01', 'p02'
%   rid      - region id
%   region   - region coordinate
%   ebsd     - EBSD (all phases) data if 0, try load useing function "[sid '_load']"
%   tasks    - list of tasks
%
% History
% 07.12.12  Add description of the function.
% 14.04.13  Add saveing of comment.
% 05.04.14  New input system.
% 17.08.15  Makeup. Write wiki. Add titles.

out = {};

saveres = getpref('ebsdam','saveResult');

OutDir = checkDir(sid, 'phases', saveres);

ebsd = checkEBSD(sid, ebsd, 0);

phases = get(ebsd,'minerals');
if  length(phases) == 1
    warning('One phase. Nothing to do!'); %#ok<WNTAG>
    return;
end
        
comment = getComment();

% Plot phase map
figure();
plotspatial(ebsd,'property','phase');
title('Phase map');
saveimg( saveres, 1, OutDir, sid, [rid '_phases'], 'png', comment );

% Get phases
phases = get(ebsd,'minerals');

for i = 1:length(phases)
    if (strcmp(phases{i},'notIndexed') == 0)
        if (size(ebsd(phases{i}), 1) ~= 0)
            % Plot orientation map
            figure();
            plotspatial(ebsd(phases{i}), 'antipodal', 'r',zvector);
            title(['Orientation map for phase ''' phases{i} '''']);
            saveimg( saveres, 1, OutDir, sid, [rid '_phases_' phases{i}], 'png', comment );

            % Plot individual orientation
            figure();
            plotpdf(get(ebsd(phases{i}),'orientation'),Miller(1,0,0), 'antipodal', 'r',zvector);
            title(['Pole figure for phase ''' phases{i} '''']);
            saveimg( saveres, 1, OutDir, sid, [rid '_io_' phases{i}], 'png', comment );
        end
    else
        plot(ebsd('notIndexed'),'facecolor','r');
    end
end

end

