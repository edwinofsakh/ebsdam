function o1 = setOriDev(o0, dev, varargin)
% Add noise to orientation data
%

%% Get input orientation
cs = get(o0, 'CS');
ss = get(o0, 'SS');

r0 = rotation(o0);
a0 = Euler(r0);

%% Calculate noise
if (check_option(varargin, 'uniform'))
    ad = dev*(0.5-rand(length(o0),3));
else
    ad = dev.*randn(length(o0),3);
end

%% Find modyfied orientations
a1 = a0 + ad;
o1 = orientation('Euler', a1(:,1), a1(:,2), a1(:,3), cs, ss);
        
end