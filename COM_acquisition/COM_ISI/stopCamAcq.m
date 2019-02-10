function stopCamAcq

global Mstate camInfo camMeta cam;

disp('Protocol end.  Closing files and camera.');

%save metadata

title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];
fname = [Mstate.dataRoot '\' Mstate.anim ...
    '\' sprintf('u%s',Mstate.unit) '_' Mstate.expt ...
    '\' title '_meta.mat'];

save(fname, 'camMeta');

%close movie file
close(camInfo.writerObj);

