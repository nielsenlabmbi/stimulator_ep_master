function update_intanname

global Mstate IcomState 


name = [Mstate.anim '_u' Mstate.unit '_' Mstate.expt];

dd = fullfile(Mstate.dataRoot,Mstate.anim,name);

name = ['basefilename ' dd];
fwrite(IcomState.msg, name)