function sendMonitor

global Mstate DcomState

%This updates the gamma table and screen size at the display.

msg = ['MON;' Mstate.monitorID ';~'];

fwrite(DcomState.serialPortHandle,msg);
