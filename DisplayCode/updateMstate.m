function updateMstate

global Mstate GUIhandles

%This only contains the string 'edit text' fields.  This function is called
%as a precaution if the user has not pressed enter after entering new
%values/strings.

Mstate.anim = get(GUIhandles.main.animal,'string');
Mstate.hemi = get(GUIhandles.main.hemisphere,'string');
Mstate.screenDist = str2num(get(GUIhandles.main.screendistance,'string'));
Mstate.analyzerRoot = get(GUIhandles.main.analyzerRoots,'string');

mTmp=get(GUIhandles.main.monitor,'string');
mVal=get(GUIhandles.main.monitor,'value');
Mstate.monitorName = mTmp{mVal};

updateMonitorValues