function updateSyncV(syncVflag)

global DcomState

msg = ['V;' num2str(syncVflag) ';~'];

fwrite(DcomState.serialPortHandle,msg);