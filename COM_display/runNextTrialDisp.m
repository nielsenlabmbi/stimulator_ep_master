function runNextTrialDisp

global setupDefault GUIhandles

switch setupDefault.setupID
    
    case 'EP'
        run2; 
        
    case '2P'
        run2;
        
    case 'ISI'
        if get(GUIhandles.main.daqflag,'value')==0 %using the ISI system without collecting data
            run2;
        end
        
end
        