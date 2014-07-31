function [ out1, out2 ] = test_func_comment( in1, in2, in3 )
% Template of function description.
%   Short description of function (What it do?) and information about input
%   and output data.
%
% Input
%   in1 - input argument 1: 'v1', 'v2', 'v3' (possible values)
%   in2 - input argument 2, if 0 do somwthing
%   in3 - input argument 3
% 
% Syntax
%   [ out1, out2 ] = test_func_comment( in1, in2, in3 )
%
% History
% 23.11.12  Original implementation
%           Function description

%% Prepare
% Do something
r = rand();

%% Processing
% Do something
out1 = in1 + in2 + r;
out2 = in2 + in3 + r;

end

function [ out ] = func( in1 )
% Template
%   Desc
%
% Input
%   in1 - desc
%
% Output
%   out1 - desc
%
% Syntax
%   [ out ] = func( in1 )
%
% History
% 23.11.12  Desc