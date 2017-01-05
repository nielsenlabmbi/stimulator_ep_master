
function send_sbserver(s)

global sbudp sb_mmap_udp;

fprintf(sbudp,s);
fprintf(sb_mmap_udp,s);

