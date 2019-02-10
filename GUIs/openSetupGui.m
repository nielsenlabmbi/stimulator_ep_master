function openSetupGui

global setupDefault


if setupDefault.useShutter
    h2=shutterSetting;
    movegui(h2,[575,170]);
end

if setupDefault.useOpto
    h3=optoStim;
    %movegui(h3,[575,170]);
end

if ~isempty(strfind(setupDefault.setupID,'ISI')) 
    h4=camPreviewGui;
end
    
