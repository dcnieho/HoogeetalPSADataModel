function [shortpath] = makeshortpath(filenaam)

slashindex = strfind(filenaam,filesep);         % search for '/'
if ~isempty(slashindex)
    lastslash  = slashindex(end);
    shortpath  = filenaam(lastslash+1:end); % pak alles achter de laatste slash
else
    shortpath  = filenaam;
end
