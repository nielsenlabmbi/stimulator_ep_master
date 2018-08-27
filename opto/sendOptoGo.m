function sendOptoGo(pulseType)

%pulseType: 1 - one pulse, 2 - pulse train

global DcomState

msg=['O;' num2str(pulseType) ';~'];
disp(msg)
fwrite(DcomState.serialPortHandle,msg);
    