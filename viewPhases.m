function out = viewPhases( sid, rid, region, ebsd, tasks, varargin ) %#ok<INUSL,INUSD>
%Draw phase map and individual oreantation map for phase
%   Draw phase map and individual oreantation map for phase
%
% Syntax
%   viewPhases( sid, rid, region, ebsd, tasks, varargin )
%
% Input
%   sid     - sample id: 's01', 's02', 's03', 's04' , 't01'
%   ebsd    - EBSD data if 0, try load useing function "[sid '_load']"
%   saveres - save image to disk
%
% History
% 07.12.12  Add description of the function.
% 14.04.13  Add saveing of comment.
% 05.04.14  New input system.

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

% plot phase map
figure();
plotspatial(ebsd,'property','phase');
saveimg( saveres, 1, OutDir, sid, [rid '_phases'], 'png', comment );

% Get phases
phases = get(ebsd,'minerals');

for i = 1:length(phases)
    if (strcmp(phases{i},'notIndexed') == 0)
        if (size(ebsd(phases{i}), 1) ~= 0)
            % plot orientation map
            figure();
            plotspatial(ebsd(phases{i}), 'antipodal', 'r',zvector);
            saveimg( saveres, 1, OutDir, sid, ['phases_' phases{i}], 'png', comment );

            % plot individual oreantation
            figure();
            plotpdf(get(ebsd(phases{i}),'orientation'),Miller(1,0,0), 'antipodal', 'r',zvector);
            saveimg( saveres, 1, OutDir, sid, ['io_' phases{i}], 'png', comment );
        end
    else
        plot(ebsd('notIndexed'),'facecolor','r');
    end
end

end

