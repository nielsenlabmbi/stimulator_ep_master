function stopIsiAcq

global  IsiComState

msg = 'X';
msg = [msg ';~'];  %add the "Terminator"

fwrite(IsiComState.serialPortHandle,msg);
