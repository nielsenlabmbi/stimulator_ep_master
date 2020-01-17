function stopAcqTrial

global setupDefault Mstate

if ~isempty(strfind(setupDefault.setupID,'ISI')) && Mstate.acqConnect(Mstate.acqIdxIsi)==1
    stopIsiAcqTrial
    waitforIsiResp;
end
