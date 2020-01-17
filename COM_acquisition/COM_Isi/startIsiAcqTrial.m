function startIsiAcqTrial

%send necessary parameters to isi setup

global  IsiComState trialno

msg = 'T';

msg = sprintf('%s;%s=%d',msg,'trialno',trialno);

msg = [msg ';~'];  %add the "Terminator"

fwrite(IsiComState.serialPortHandle,msg);
%disp('Sending MainWindow values.');
