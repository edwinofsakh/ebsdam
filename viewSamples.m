function viewSamples( samples, regions, rxy, skip, tasklist, varargin)
% Collect information about samples
%   Collect information about samples, some of them can be skipped. Divide 
%   samples on part by Y.
%
% Syntax
%   viewSamples( samples, regions, rxy, skip, thr, mgsum, epsilon, tasklist, varargin)
%
% Input
%   samples   - cell array with sample ids (chars)
%   regions   - cell array with region ids (chars)
%   rxy       - regions (polygon) coordinates
%   skip      - array with skipping flag (1 - skip, 0 - process)
%   tasklist  - task list
%
% Options
%   thrd        - grain detection threshold in degree
%   mgs | mgsum - grain detection minimal grain size (MGS) (in point | in um^2)
%   epsd        - KOG threshold
%
% History
% 16.11.12  Original implementation.
% 04.12.12  Add resizing of EBSD data.
% 07.12.12  Fix parting of resized data. Modify desc.
% 28.12.12  Add printing of EBSD data size and step. Makeup output info.
%           Change dimension of MGS, now it is 'mgsum' in um^2.
% 16.04.13  Modify calculation of cell area (correcting results for hex).
% 26.03.14  Remove 'saveres' input, now use setpref. Remake parts to
%           regions, more general. Remove 'gtasklist', now custom tasks
%           saved in task list.

n1 = length(samples);
n2 = length(regions);
n3 = length(skip);
n4 = length(rxy);

if ~(n1 == n2 && n1 == n3 && n1 == n4)
    warning('Check script!'); %#ok<WNTAG>
    return;
end

%% Processing
% Divide data
for i = 1:length(samples)
    
    % Sample id
    sid = samples{i};
    rid = regions{i};
    
    disp('.');
    disp('+---------------------');

    % Skip sample
    if (skip(i) == 1)
        disp(['| Skip ' sid]);
        continue;
    else
        disp(['| Process ' sid]);
    end

    % Create new varargin
    varargin1 = varargin;
        
    % Get EBSD data
    ebsd = eval([sid '_load']);
    
    % Get step size
    [ dx, dy, nx, ny ] = getStep( ebsd );
    ca = getCellArea( ebsd );
    fprintf(1,['Original Size of EBSD Data\n',...
        'Step: %f x %f um\n',...
        'Number %d x %d\n',...
        'Point area: %f um^2\n\n'], dx,dy, nx,ny, ca);
    
    % Calc MGS in point
    if check_option(varargin1, 'mgs') || check_option(varargin1, 'mgsum')
        if check_option(varargin1, 'mgs')
            mgs = get_option(varargin1, 'mgs', 2, 'double');
            varargin1 = delete_option(varargin1, 'mgs');
        elseif check_option(varargin1, 'mgsum')
            mgsum = get_option(varargin1, 'mgsum', 1, 'double');
            varargin1 = delete_option(varargin1, 'mgsum');
            if mgsum > 1
                warning('EBSDAM:TooBigMGS', 'Now ''mgs'' is in um^2, check ''mgs'' or comment this lines in ''viewSamples''')
                pause(5);
            end
            mgs = fix(mgsum/ca);
        end
        
        fprintf(1,'MGS in point: %d\n', mgs);
        varargin1 = [varargin1 'mgs' mgs]; %#ok<AGROW>
    end
    
    % Add THRD
    if check_option(varargin1, 'thrd')
        thrd = get_option(varargin1, 'thrd', 2, 'double');
        varargin1 = delete_option(varargin1, 'thrd');
        fprintf(1,'THR in degree: %d\n', thrd);
        varargin1 = [varargin1 'thrd' thrd]; %#ok<AGROW>
    end
    
    % Add EPSD
    if check_option(varargin1, 'epsd')
        epsd = get_option(varargin1, 'epsd', 4, 'double');
        varargin1 = delete_option(varargin1, 'epsd');
        fprintf(1,'EPS in point: %d\n', epsd);
        varargin1 = [varargin1 'epsd' epsd]; %#ok<AGROW>
    end
 

    % Resize EBSD data
    if iscell(rxy)
        region = rxy{i};
        ebsd = getRegion(ebsd, region);
    else
        region = 0;
    end
                
    viewAll(sid, rid, region, ebsd, tasklist, varargin1{:});

end
