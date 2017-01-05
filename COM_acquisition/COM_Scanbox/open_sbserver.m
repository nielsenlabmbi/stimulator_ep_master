
function open_sbserver

global sbudp sb_mmap_udp setupDefault

if(~isempty(sbudp))
    fclose(sbudp);
end

sbudp  = udp(setupDefault.acqIP, 'RemotePort', 7000);
fopen(sbudp);

if(~isempty(sb_mmap_udp))
    fclose(sb_mmap_udp);
end

sb_mmap_udp  = udp(setupDefault.acqIP, 'RemotePort', 8000);
fopen(sb_mmap_udp);


