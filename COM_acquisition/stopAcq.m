function stopAcq

global setupDefault

switch setupDefault.setupID
    
    case 'EP' %Blackrock acquisition (runs on same machine)
        %stopBlackrockAcq;
        stopIntanAcq;


    case '2P' %scanbox acquisition (on separate machine)
        send_sbserver('S'); %stop microscope
        
    case 'ISI' %isi acquisition (on same machine)
        stopIsi
    

end