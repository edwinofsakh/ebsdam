function f = progressStatus( i, n, part )
%Return true if progress has reached a specified value.

if (mod(i,fix(n/part)) == 0)
    f = true;
else
    f = false;
end

