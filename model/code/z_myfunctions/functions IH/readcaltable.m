function [d] = readcaltable(filename,nskip)

[fid,message]	= fopen(filename);
if fid == -1
    error(message);
end

if nskip > 0                           % to skip header
    for p=1:nskip
        fgetl(fid);
    end
end

dummy           = textscan(fid,'%f%f','delimiter','\t');
fclose(fid);

d.angle         = dummy{:,1};        % hoek
d.dist          = dummy{:,2};        % afstand

disp(' ');
disp(sprintf('%d lines read from %s',length(d.angle),makeshortpath(filename)));
disp(' ');