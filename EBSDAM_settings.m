PCname = getComputerName();
switch PCname
    case 'officemse'
        setpref('ebsdam','data_dir','E:\Sergey\TextureStudy\data\ebsd');
        setpref('ebsdam','output_dir','E:\Sergey\TextureStudy\out\ebsdam');
        setpref('ebsdam','cache_dir','E:\Sergey\TextureStudy\out\ebsdam\cache');
        setpref('ebsdam','doc_dir','E:\Sergey\TextureStudy\result\ebsd\doc');
    case 'tania-w7'
        setpref('ebsdam','data_dir','E:\MatLab\EBSDAM\data');
        setpref('ebsdam','output_dir','E:\MatLab\EBSDAM\res0001\out');
        setpref('ebsdam','cache_dir','E:\MatLab\EBSDAM\res0001\cache');
        setpref('ebsdam','doc_dir','E:\MatLab\EBSDAM\res0001\doc');
    case 'edwin-inspiron'
        setpref('ebsdam','data_dir','D:\Projects\TextureStudy\EBSD\data');
        setpref('ebsdam','output_dir','D:\Projects\TextureStudy\EBSD\res0001\out');
        setpref('ebsdam','cache_dir','D:\Projects\TextureStudy\EBSD\res0001\cache');
        setpref('ebsdam','doc_dir','D:\Projects\TextureStudy\EBSD\res0001\doc');
    case 'edwin-w7'
        setpref('ebsdam','data_dir','F:\Projects\TextureStudy\EBSD\data');
        setpref('ebsdam','output_dir','F:\Projects\TextureStudy\EBSD\res0001\out');
        setpref('ebsdam','cache_dir','F:\Projects\TextureStudy\EBSD\res0001\cache');
        setpref('ebsdam','doc_dir','F:\Projects\TextureStudy\EBSD\res0001\doc');
    case 'edwin-latitude-3440'
        setpref('ebsdam','data_dir','~/Work/EBSD/data');
        setpref('ebsdam','output_dir','~/Work/EBSD/out');
        setpref('ebsdam','cache_dir','~/Work/EBSD/cache');
        setpref('ebsdam','doc_dir','~/Work/EBSD/doc');
    otherwise
        disp('Setup directories!');
end

setpref('ebsdam','caching', 1);
setpref('ebsdam','saveResult', 1);
setpref('ebsdam', 'maxProbParents', 2000);