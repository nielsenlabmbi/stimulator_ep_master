function stopAcq

global setupDefault

%This is executed at the end of experiment and when abort button is hit
if strcmp(setupDefault.setupID,'EP')  %Blackrock acquisition (runs on same machine)
    stopBlackrockAcq;

elseif strcmp(setupDefault.setupID,'2P')  %scanbox acquisition (on separate machine)
    send_sbserver('S'); %stop microscope

end