
function close_sbserver

global sbudp;

if(~isempty(sbudp))
    fclose(sbudp);
    sbudp = [];
end

