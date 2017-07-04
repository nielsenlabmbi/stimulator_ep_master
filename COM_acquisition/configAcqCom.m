function configAcqCom

global setupDefault

switch setupDefault.setupID
    
    case '2P'  %scanbox
        open_sbserver  
        
    case 'ISI' %intrinsic imaging rig
        configSyncInput
        
    case 'ISI_NL'
        configCam4Preview
end
