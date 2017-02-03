function runNextTrialAcq

global setupDefault

switch setupDefault.setupID
    
    case 'ISI'
        run2; %all other setups handle this through the displaycb function
end
        