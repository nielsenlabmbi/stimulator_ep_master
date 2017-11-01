function sendOptoPar

global DcomState optoInfo

optoPar=fieldnames(optoInfo);

msg='OP';

for i=1:length(optoPar)
    v=getfield(optoInfo,optoPar{i});
    msg = sprintf('%s;%s=%d',msg,optoPar{i},v);
end

msg = [msg ';~'];  %add the "Terminator"
disp(msg)
fwrite(DcomState.serialPortHandle,msg);
    