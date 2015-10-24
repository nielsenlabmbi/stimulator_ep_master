function initializeModule(modID)
% This function calls the module specific function, if it exists.
% Accepts:
%   modID: module number
% Returns:
%   Nothing.

% get the list of all module parameters for the plist (non-manual params)
Mlist = moduleListMaster('P');

% if the seleced module has a specific initialize function then call it.
if ~isempty(Mlist{modID}{4})
    eval(Mlist{modID}{4});
end
