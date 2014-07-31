function [ o ] = getORo_c( OR_name )
%getORo_c Return MTEX orientation for OR (Orientation relationship)
%   Return MTEX orientation for OR
%   OR_name - name of OR

ss = symmetry('1');
cs = symmetry('m-3m');

o = orientation('matrix',getOR(OR_name),cs,ss);

end

