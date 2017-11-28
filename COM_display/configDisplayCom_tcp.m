function configDisplayCom_tcp

%configures communication with the stimulus slave

global DcomState setupDefault


% % close all open udp port objects on the same port and remove
% % the relevant object form the workspace
% port = instrfindall('RemoteHost',setupDefault.slaveIP);
% if ~isempty(port); 
%     fclose(port); 
%     delete(port);
%     clear port;
% end

% this is the port that sends messages to the slave
DcomState.serialPortHandle = tcpip(setupDefault.slaveIP, 30000, 'NetworkRole', 'server');
DcomState.serialPortHandle.BytesAvailableFcnMode = 'Terminator';
DcomState.serialPortHandle.Terminator = '~';
DcomState.serialPortHandle.OutputBufferSize = 5120;

% this is the port that receives messages from the slave
DcomState.serialPortHandleReceiver = tcpip(setupDefault.slaveIP, 30001, 'NetworkRole', 'client');
DcomState.serialPortHandleReceiver.BytesAvailableFcnMode = 'Terminator';
DcomState.serialPortHandleReceiver.Terminator = '~';
DcomState.serialPortHandleReceiver.InputBufferSize = 5120;
DcomState.serialPortHandleReceiver.Timeout = 5;
DcomState.serialPortHandleReceiver.BytesAvailableFcn = @Displaycb;  

% open and check status 
fopen(DcomState.serialPortHandle);
stat=get(DcomState.serialPortHandle, 'Status');
if ~strcmp(stat, 'open')
    disp('Communication Error: Trouble opening port for master server.');
    DcomState.serialPortHandle=[];
    return;
end

pause(2);

% open and check status 
fopen(DcomState.serialPortHandleReceiver);
stat=get(DcomState.serialPortHandleReceiver, 'Status');
if ~strcmp(stat, 'open')
    disp('Communication Error: Trouble opening port for master client.');
    DcomState.serialPortHandleReceiver=[];
    return;
end



