function saveOutput( fname, out, varargin )     %#ok<INUSL>
% Save output data 

outdir = getpref('ebsdam','output_dir');
fname = [fname '.mat'];

cmt = get_option(varargin, 'comment', '');      %#ok<NASGU>
env = get_option(varargin, 'enviroment', {});   %#ok<NASGU>

save(fullfile(outdir,fname), 'out', 'cmt', 'env');

end