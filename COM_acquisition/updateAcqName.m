function updateAcqName

global setupDefault

switch setupDefault.setupID
    case '2P'
        update_sbname   %Send expt info to 2P server
        
    case 'ISI'
        update_isiname  %set fields in imager
end