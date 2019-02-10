function finishAcqTrial

global setupDefault

if ~isempty(strfind(setupDefault.setupID,'ISI')) 
    stopCamAcqTrial
end