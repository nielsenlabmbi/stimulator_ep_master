function runIsiAcq

global analogIN trialno syncInfo onlineIsiAnalysis

sendtoImager(sprintf(['S %d' 13],trialno-1))  %Matlab now enters the frame grabbing loop (I will also save it to disk)
        
%%%Timing is not crucial for this last portion of the loop (both display and frame grabber/saving is inactive)...
        
stop(analogIN)  %Stop sampling acquistion and stimulus syncs

[syncInfo.dispSyncs,syncInfo.acqSyncs,syncInfo.dSyncswave] = getSyncTimes;
syncInfo.dSyncswave = [];  %Just empty it for now
saveSyncInfo(syncInfo)  %append .analyzer file
        

if onlineIsiAnalysis
    [c,r] = Sgetcondrep(trialno);
    onlineAnalysis(c,r,syncInfo)     %Compute F1
end