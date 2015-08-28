function [ out, cmt, env ] = loadOutput( fname ) %#ok<STOUT>
% Save output data 

outdir = getpref('ebsdam','output_dir');
fname = [fname '.mat'];

load(fullfile(outdir,fname), 'out', 'cmt', 'env');

if ~exist('out', 'var')
    out = -1;
end

end

