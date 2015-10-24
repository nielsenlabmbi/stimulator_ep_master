function configurePstate(modID,listtype)
%this function sets the global variable Pstate by calling the correct
%config function

global Pstate PstateHistory SelectedModId

%modID: number of module
Mlist=moduleListMaster(listtype);

% If the module exists in PstateHistory, then update Pstate with the one in
% the history. Otherwise configure it and then save it in PstateHistory.

eval(Mlist{modID}{3});
if isempty(PstateHistory)
    PstateHistory = cell(1,length(Mlist));
    SelectedModId = 1;
elseif isempty(PstateHistory{modID})
    PstateHistory{modID} = Pstate;
else  
    Pstate = PstateHistory{modID};
end
