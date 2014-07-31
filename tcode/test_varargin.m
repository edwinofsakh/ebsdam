function [ out ] = test_varargin( arg1, varargin )
%test_vararin Test MatLab variable list functions

optargin = size(varargin,2);
stdargin = nargin - optargin;

fprintf('Number of inputs = %d\n', nargin)

fprintf('  Inputs from individual arguments(%d):\n', ...
        stdargin)
if stdargin >= 1
    fprintf('     %s\n', arg1)
end
if stdargin == 2
    fprintf('     %s\n', arg2)
end

fprintf('  Inputs packaged in varargin(%d):\n', optargin)
 for k= 1 : size(varargin,2) 
     fprintf('     %s\n', varargin{k})
 end
 
end

