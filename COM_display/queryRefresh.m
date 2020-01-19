function queryRefresh

global DcomState


msg = ['F;1;~']; %we're adding the 1 just to make the parsing on the slave side easier to handle

fwrite(DcomState.serialPortHandle,msg);

