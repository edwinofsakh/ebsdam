function plotAngDist( mori, lmt1, saveres, odir, prefix, fname, ltitle, varargin )
% Plot angle distribution
%   Plot angle distribution for misorientation and save data disk
%
% Syntax
%   plotAngDist( mori, lmt, saveres, odir, prefix, fname, ltitle )
%
% Input
%   mori - misorientation
%   lmt1  - limit angle, in degree
%   saveres - see main function
%   odir - output directory
%   prefix - file name prefix
%   fname - file name
%   ltitle - data title (name 'title' is used)
%
% History
% 19.03.13  Separate from 'viewGrains'.
% 14.04.13  Add saveing of comment.
% 16.09.15  Add low angle limit.

    comment = getComment();
    
    % Get angle less then limit
    ang = angle(mori)/degree;
    ang = ang(ang < lmt1);
    
    % Select histogram step
    if lmt1 > 35
        d = 2;
    else
        d = 0.5;
    end
    
    % Plot histogram
    figure();
    lmt0 = 1;
    edges = lmt0:d:lmt1;
    [n, bin] = histc(ang,edges);
    
    if check_option(varargin, 'normLowAngles')
        n1 = n;
        j = find(n, 1, 'first');
        n1(1:j) = n1(j)/j;
        if sum(n1) == sum(n)
            test = 1;
        end
        n = n1;
    end
    
    np = n/sum(n)*100;
    bar1 = bar(edges,np,'histc');
    set(bar1,'FaceColor',[0.7, 0.78, 1])
    xlabel('Angle, degree');
    ylabel('Frequency, %');
    title(ltitle);
%     title([ltitle ' (amt ' num2str(length(mori)) ')']);
    
    % Save data to disk
    savexy( edges, n, saveres, odir, prefix, fname, ltitle, comment );
    
    % Save image to disk
    saveimg( saveres, 1, odir, prefix, fname, 'png', comment);
end
