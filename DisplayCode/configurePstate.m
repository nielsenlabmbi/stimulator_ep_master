function configurePstate(modID,listtype)
% This function sets the global variable Pstate by calling the correct
% config function. It also initializes/sets the global variable 
% PstateHistory.
% Accepts:
%   modID:      Module number
%   listtype:   p-list ('p') or m-list ('m')
% Returns:
%   Nothing

global Pstate PstateHistory SelectedModId

Mlist = moduleListMaster(listtype);

% If the module exists in PstateHistory, then update Pstate with the one in
% the history. Otherwise configure it and then save it in PstateHistory.

eval(Mlist{modID}{3});
Pstate.type=Mlist{modID}(1);
if isempty(PstateHistory)
    PstateHistory = cell(1,length(Mlist));
    SelectedModId = 1;
elseif isempty(PstateHistory{modID})
    PstateHistory{modID} = Pstate;
else  
    Pstate = PstateHistory{modID};    
end
