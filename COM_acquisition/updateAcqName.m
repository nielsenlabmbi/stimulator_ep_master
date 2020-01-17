function updateAcqName

global setupDefault Mstate

if ~isempty(strfind(setupDefault.setupID,'2P')) && Mstate.acqConnect(Mstate.acqIdx2P)==1
    update_sbname   %Send expt info to 2P server
end

if ~isempty(strfind(setupDefault.setupID,'EP')) && Mstate.acqConnect(Mstate.acqIdxEP)==1
    update_intanname %send expt info to intan
end

if ~isempty(strfind(setupDefault.setupID,'ISI')) && Mstate.acqConnect(Mstate.acqIdxIsi)==1
    update_isiname
end
