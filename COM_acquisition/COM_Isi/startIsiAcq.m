function startIsiAcq

%send necessary parameters to isi setup

global  IsiComState

msg = 'S';

predelay = getParamVal('predelay');
stim_time = getParamVal('stim_time');

msg = sprintf('%s;%s=%.4f',msg,'pre',predelay);
msg = sprintf('%s;%s=%.4f',msg,'pre',stim_time);


msg = [msg ';~'];  %add the "Terminator"

fwrite(IsiComState.serialPortHandle,msg);
%disp('Sending MainWindow values.');
