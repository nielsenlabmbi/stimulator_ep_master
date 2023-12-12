function configurePstate(modID,listtype)
% This function sets the global variable Pstate by calling the correct
% config function. It also initializes/sets the global variable 
% PstateHistory.
% Accepts:
%   modID:      Module number
%   listtype:   p-list ('p') or m-list ('m')
% Returns:
%   Nothing

global Pstate PstateHistory Pdoc stereoFlag

%hack until all modules have documentation
Pdoc=struct;

if stereoFlag==0
    Mlist = moduleListMaster(listtype);
else
    Mlist = moduleListStereo(listtype);
end

% If the module exists in PstateHistory, then update Pstate with the one in
% the history. Otherwise configure it and then save it in PstateHistory.

eval(Mlist{modID}{3}); %this generates Pstate and Pdoc
Pstate.type=Mlist{modID}(1);

if isempty(PstateHistory)
    PstateHistory = cell(1,length(Mlist));
end

if isempty(PstateHistory{modID})
    PstateHistory{modID} = Pstate;
else  
    Pstate = PstateHistory{modID};    
end
