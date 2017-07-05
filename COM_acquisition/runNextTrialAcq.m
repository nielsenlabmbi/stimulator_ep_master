function runNextTrialAcq

global setupDefault

switch setupDefault.setupID
    
    case 'ISI'
        run2; %all other setups handle this through the displaycb function
        
    case 'ISI_NL'
        run2
end
        