function update_isiname

%update filename for isi setup

global Mstate IsiComState

msg = 'M';

msg = sprintf('%s;%s=%s',msg,'anim',Mstate.anim);
msg = sprintf('%s;%s=%s',msg,'unit',Mstate.unit);
msg = sprintf('%s;%s=%s',msg,'expt',Mstate.expt);

msg = [msg ';~'];  %add the "Terminator"

fwrite(IsiComState.serialPortHandle,msg);
%disp('Sending MainWindow values.');
