function modID = getmoduleID

%this only returns moduleIDs for the parameter window, not the mapper

global AppHdl;

paramModule=AppHdl.params.DModule.Value;

mList=moduleListMaster('P');

modID=mList{paramModule}{1};
