function openSetupGui

global setupDefault


switch setupDefault.setupID
    
    case 'ISI' %intrinsic imaging rig
        hmm = IsiAnalysisGui;
        %movegui(hmm,[365,275]);
end
