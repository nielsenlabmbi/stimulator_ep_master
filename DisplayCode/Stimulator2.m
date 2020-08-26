function Stimulator2

global AppHdl;

getSetup;

%host-host communication
configDisplayCom_tcp    %stimulus computer
%configAcqCom %acquisition machine

%Initialize stimulus parameter structures
configurePstate(1,'P') %this updates the parameters to the first module selected in paramSelect
configureMstate %this will update the monitor as well
configureLstate



%Open general GUIs
hm = MainWindow;
movegui(hm,[10 1500])

AppHdl.looper = LooperNew ;
%movegui(hl,[1000 1500])

AppHdl.params = paramSelectNew;
%movegui(hp,[500 1500])

hmm = manualMapper;
movegui(hmm,[500 1300])

%setup specific configuration of parameters and GUIs
configureSetup;
openSetupGui;

disp('Stimulator ready.')