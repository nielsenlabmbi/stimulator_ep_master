function Stimulator2

getSetup;

%Initialize stimulus parameter structures
configurePstate(1,'P') %this updates the parameters to the first module selected in paramSelect
configureMstate %this will update the monitor as well
configureLstate

%host-host communication
configDisplayCom_tcp    %stimulus computer
configAcqCom %acquisition machine


%Open general GUIs
hm = MainWindow;
movegui(hm,[10,500]);

hl = Looper ;
movegui(hl,[365,445]);

hp = paramSelect;
movegui(hp,[10,110]);

hmm = manualMapper;
movegui(hmm,[365,275]);

%setup specific configuration of parameters and GUIs
configureSetup;
openSetupGui;