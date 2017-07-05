function stopAcq

global setupDefault

switch setupDefault.setupID
    
    case 'EP' %Blackrock acquisition (runs on same machine)
        stopBlackrockAcq;

    case '2P' %scanbox acquisition (on separate machine)
        send_sbserver('S'); %stop microscope
        
    case 'ISI' %isi acquisition (on same machine)
        stopIsi
    
    case 'ISI_NL'
        stopCamAcq
    

end