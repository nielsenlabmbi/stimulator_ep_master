function startManual(modID)

global DcomState


msg = ['MM;' modID ';~'];

fwrite(DcomState.serialPortHandle,msg);

