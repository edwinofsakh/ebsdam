function cleanCache( )

cacheDir = getpref('ebsdam','cache_dir');
rmdir(cacheDir,'s');
mkdir(cacheDir);

end