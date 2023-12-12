function modID = getmoduleID

%this only returns moduleIDs for the parameter window, not the mapper

global AppHdl stereoFlag;

paramModule=AppHdl.params.DModule.Value;

if stereoFlag==0
    mList=moduleListMaster('P');
else
    mList=moduleListStereo('P');
end
modID=mList{paramModule}{1};
