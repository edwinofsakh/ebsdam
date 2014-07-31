function saveResult( state )
%Set state of saveing result to disk
%   Detailed explanation goes here

if strcmpi(state, 'on')
    setpref('ebsdam','saveResult',1)
else
    if strcmpi(state, 'off')
        setpref('ebsdam','saveResult',0)
    else
        warning('Unknown state of saveing result to disk.'); %#ok<WNTAG>
    end
end
end

