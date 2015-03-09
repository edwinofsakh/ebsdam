if (ispref('ebsdam','isdirs') && getpref('ebsdam','isdirs') == 1)
    setpref('ebsdam','data_dir','path\to\data\');
    setpref('ebsdam','output_dir','path\to\output\');
    setpref('ebsdam','cache_dir','path\to\cache\');
    setpref('ebsdam','doc_dir','path\to\doc\');
    % after setup type and evaluate:
    % getpref('ebsdam','isdirs',1)
else
    disp('Setup directories!');
end

setpref('ebsdam','caching', 1);
setpref('ebsdam','saveResult', 1);
setpref('ebsdam', 'maxProbParents', 2000);
