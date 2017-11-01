function sendOptoPar

global DcomState optoInfo

optoPar=fieldnames(optoInfo);

msg='OP';

for i=1:length(optoPar)
    msg = sprintf('%s;%s=%d',msg,optoPar{i},optoInfo.(optoPar{i}));
end

msg = [msg ';~'];  %add the "Terminator"
disp(msg)
fwrite(DcomState.serialPortHandle,msg);
    