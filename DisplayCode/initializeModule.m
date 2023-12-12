function initializeModule(modID)
% This function calls the module specific function, if it exists.
% Accepts:
%   modID: module number
% Returns:
%   Nothing.

global stereoFlag

% get the list of all module parameters for the plist (non-manual params)
if stereoFlag==0
    Mlist = moduleListMaster('P');
else
    Mlist = moduleListStereo('P');
end


% if the seleced module has a specific initialize function then call it.
if ~isempty(Mlist{modID}{4})
    eval(Mlist{modID}{4});
end
