function startAcq

global setupDefault

if ~isempty(strfind(setupDefault.setupID,'2P'))
    updateAcqName   %Send expt info to acquisition
    send_sbserver('G'); %start microscope
end

if ~isempty(strfind(setupDefault.setupID,'EP')) 
    updateAcqName %Send expt info to acquisition
    startIntanAcq
end

if ~isempty(strfind(setupDefault.setupID,'ISI')) 
    
end
