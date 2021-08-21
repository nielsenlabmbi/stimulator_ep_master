function connectZaber(status)

%connect or disconnect function generator

global DcomState

msg=['ZS;' num2str(status) ';~'];

fwrite(DcomState.serialPortHandle,msg);
%disp('Connecting func gen');

    