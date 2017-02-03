function startAcq

global setupDefault

switch setupDefault.setupID
    case 'EP' %Blackrock acquisition (runs on same machine)
        startBlackrockAcq 
    
    case '2P' %scanbox acquisition (on separate machine)
        updateAcqName   %Send expt info to acquisition
        send_sbserver('G'); %start microscope

    case 'ISI' %intrinsic imaging (on same machine)
        startIsiAcq
    
end