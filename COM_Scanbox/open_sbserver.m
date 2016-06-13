
function open_sbserver

global sbudp sb_mmap_udp

if(~isempty(sbudp))
    fclose(sbudp);
end

sbudp  = udp('172.30.11.132', 'RemotePort', 7000);
fopen(sbudp);

if(~isempty(sb_mmap_udp))
    fclose(sb_mmap_udp);
end

sb_mmap_udp  = udp('172.30.11.132', 'RemotePort', 8000);
fopen(sb_mmap_udp);


