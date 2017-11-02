function openSetupGui

global setupDefault


switch setupDefault.setupID
    
    case 'ISI' %intrinsic imaging rig
        h1 = IsiAnalysisGui;
        %movegui(hmm,[365,275]);
end

if setupDefault.useShutter
    h2=shutterSetting;
    movegui(h2,[575,170]);
end

if setupDefault.useOpto
    h3=optoStim;
    %movegui(h3,[575,170]);
end
    
