function htmlreport(name, action, varargin)

global reportfile

switch action
    case 'start'
        odir = getpref('ebsdam','output_dir');
        fname = [odir '\rep_' name '.html'];

        reportfile = fopen(fname, 'w');

        fprintf(reportfile, '<html><head><title> Report</title></head><body>');
    
    case 'end'
        fprintf(reportfile, '</body></html>');
        fclose(reportfile);
    
    case 'add'
        if check_option(varargin, 'img')
            ipath = get_option(varargin, 'path', '', 'char');
            ititle = get_option(varargin, 'title', '', 'char');
            fwrite(reportfile, ['<br/>' ititle '<br/><img src="' ipath '" alt="' ititle '" height="20%"/>']);
        end
        if check_option(varargin, 'text')
            txt = get_option(varargin, 'text', '', 'char');
            fwrite(reportfile, ['<br/>' txt '"<br/>']);
        end
        if check_option(varargin, 'table')
            tdata  = get_option(varargin, 'data', 0);
            ttitle = get_option(varargin, 'title', '', 'char');
            thead  = get_option(varargin, 'head', '');
            
            fwrite(reportfile, ['<br/>' ttitle '"<br/>']);
        end
end

