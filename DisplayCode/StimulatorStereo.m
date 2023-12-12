function StimulatorStereo

global AppHdl stereoFlag;

stereoFlag=1;

getSetup;

%host-host communication
configDisplayCom_tcp    %stimulus computer
%configAcqCom %acquisition machine

%Initialize stimulus parameter structures
configurePstate(1,'P') %this updates the parameters to the first module selected in paramSelect
configureMstate %this will update the monitor as well
configureLstate



%Open general GUIs
AppHdl.main = MainWindowNew;
%movegui(hm,[10 1500])

AppHdl.looper = LooperNew ;
%movegui(hl,[1000 1500])

AppHdl.params = paramSelectNew;
%movegui(hp,[500 1500])

AppHdl.manual = manualMapperNew;
%movegui(hmm,[500 1300])

AppHdl.refstim = ReferenceStim;

%AppHdl.ga = GaGen;

%setup specific configuration of parameters and GUIs
configureSetup;
openSetupGui;

disp('Stimulator ready.')