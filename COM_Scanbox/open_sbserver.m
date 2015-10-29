
function open_sbserver

global sbudp;

if(~isempty(sbudp))
    fclose(sbudp);
end

sbudp  = udp('172.30.11.132', 'RemotePort', 7000);
fopen(sbudp);



