function startAcq

global setupDefault

if strcmp(setupDefault.setupID,'EP')  %Blackrock acquisition (runs on same machine)
    startBlackrockAcq
    
elseif strcmp(setupDefault.setupID,'2P')  %scanbox acquisition (on separate machine)
    updateAcqName   %Send expt info to acquisition
    send_sbserver('G'); %start microscope

end