function startAcqTrial

global setupDefault

if ~isempty(strfind(setupDefault.setupID,'ISI')) 
    startCamAcqTrial
end