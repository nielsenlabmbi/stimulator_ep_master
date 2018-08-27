function configAcqCom

global setupDefault

switch setupDefault.setupID
    
    case '2P'  %scanbox
        open_sbserver  
     
    case 'EP'   %intan - is now handled by button in MainWindow
       % configIntanCom
            
    case 'ISI' %intrinsic imaging rig
        configSyncInput
        
<<<<<<< HEAD
    case 'ISI_NL'
        configCam4Preview
=======
        
>>>>>>> master
end
