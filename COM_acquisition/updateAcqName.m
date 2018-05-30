function updateAcqName

global setupDefault

switch setupDefault.setupID
    case '2P'
        update_sbname   %Send expt info to 2P server
    
    case 'EP'
        update_intanname %send expt info to intan    
        
    case 'ISI'
        update_isiname  %set fields in imager
end