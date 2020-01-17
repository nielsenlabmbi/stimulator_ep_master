function stopIsiAcqTrial

global  IsiComState

msg = 'U';
msg = [msg ';~'];  %add the "Terminator"

fwrite(IsiComState.serialPortHandle,msg);
