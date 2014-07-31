function [ gl ] = test( np, i )
gl = [];            % grain list
ig = np(i,1);       % graind id

gl = [gl, ig];

gl = addN(np, gl,ig);

end

function [ gl_o ] = addN (np, gl, ig) 

ind = np(:,1) == ig;
nl = np(ind,2); % neighbours list

gl_i = gl;
    
if any(ind) == 0
    gl_o = gl_i;
else
    for i = 1:length(nl)
        in = nl(i);
        gl_i = [gl_i, in];
        gl_i = addN(np, gl_i, in);
    end

    gl_o = gl_i;
end

end

