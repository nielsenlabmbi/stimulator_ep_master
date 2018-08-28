function updateAcqName

global setupDefault

if ~isempty(strfind(setupDefault.setupID,'2P'))
    update_sbname   %Send expt info to 2P server
end

if ~isempty(strfind(setupDefault.setupID,'EP')) 
    update_intanname %send expt info to intan
end

if ~isempty(strfind(setupDefault.setupID,'ISI')) 
    
end
