function startAcq

global setupDefault Mstate

if ~isempty(strfind(setupDefault.setupID,'2P')) && Mstate.acqConnect(Mstate.acqIdx2P)==1
    updateAcqName   %Send expt info to acquisition
    send_sbserver('G'); %start microscope
end

if ~isempty(strfind(setupDefault.setupID,'EP')) && Mstate.acqConnect(Mstate.acqIdxEP)==1
    updateAcqName %Send expt info to acquisition
    startIntanAcq
end

if ~isempty(strfind(setupDefault.setupID,'ISI')) && Mstate.acqConnect(Mstate.acqIdxIsi)==1
    updateAcqName %Send expt info to acquisition
    startIsiAcq
end
