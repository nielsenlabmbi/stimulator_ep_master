function updateMstate

global Mstate AppHdl

%This only contains the string 'edit text' fields.  This function is called
%as a precaution if the user has not pressed enter after entering new
%values/strings.

Mstate.anim = AppHdl.main.EAnimal.Value;
Mstate.screenDist = AppHdl.main.EScreenDist.Value; 
Mstate.analyzerRoot = AppHdl.main.EAnaRoots.Value;

Mstate.monitorName = app.DMonitor.Value;
updateMonitorValues