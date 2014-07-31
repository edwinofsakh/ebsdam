function plotRot( rot, complete, cmap, label )
% Plot pole figure for orientation relationship
%   Detailed explanation goes here
%   o - Orientation Realtion by MTEX::orientation
%   complete - if 1 draw full figure, else  only {100}, {010}, {111}

from = '\gamma';
showBase = 1;
cb = [0.5 0.5 0.5];

% n = length(rot);

% if (iscell(cmap))
%     if (length(cmap) ~= n)
%         error('Size of OR set and color map is not equal.')
%     end
% else
%     cmap = repmat(cmap, n,1);
% end

if (showBase)
    plot([vector3d(1,0,0) vector3d(0,1,0) vector3d(0,0,1)],...
        'label', {['100' from],['010' from],['001' from]},...
        'antipodal','grid_res',15*degree, 'MarkerColor', cb);
    hold on;
end
   
% for i = 1:n
    if (complete == 1)
        plot(rot, 'antipodal', 'label', label), hold on;
    else
        plot(rot*vector3d(0,0,1), 'antipodal', 'label', label, 'MarkerColor',cmap), hold on;
        plot(rot*vector3d(0,1,1), 'antipodal', 'label', label, 'MarkerColor',cmap), hold on;
        plot(rot*vector3d(1,0,0), 'antipodal', 'label', label, 'MarkerColor',cmap), hold on;
    end
% end

end

