function connectFuncGen(status)

%connect or disconnect function generator

global DcomState

msg=['FG;' num2str(status) ';~'];

fwrite(DcomState.serialPortHandle,msg);
%disp('Connecting func gen');

    