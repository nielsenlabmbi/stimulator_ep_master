function configIntanCom

global IcomState

%connect to intan app running on the same machine
rhost = '172.30.11.143';
role = 'client';
localPort = 1234;
remotePort = 1234;
    
msg = tcpip(rhost, remotePort, 'NetworkRole', role);
if(strcmp(msg.Status, 'closed'))
    fprintf(['\nTcpMessenger connecting to ' rhost '\n']);
    fopen(msg);
end

IcomState.msg = msg;
IcomState.role = role;
IcomState.rhost = rhost;