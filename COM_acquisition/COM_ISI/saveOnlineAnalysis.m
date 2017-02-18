function saveOnlineAnalysis

global F1 Mstate setupDefault

f1m = F1;

A = Mstate.anim;
U = Mstate.unit;
E = Mstate.expt;
UE = [U '_' E];

path=setupDefault.isiOnlineRoot;

filename=fullfile(path,[A '_' UE]);
uisave('f1m',filename)

