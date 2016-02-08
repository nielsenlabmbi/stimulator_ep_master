function Stimulator2

%Initialize stimulus parameter structures
configurePstate(1,'P') %this updates the parameters to the first module selected in paramSelect
configureMstate
configureLstate

%Host-Host communication
configDisplayCom    %stimulus computer

[setup,~]=getSetup;
if strcmp(setup,'2P') %2p
    open_sbserver    %2p acquisition
end



%Open GUIs
hm = MainWindow;
movegui(hm,[10,500]);

hl = Looper ;
movegui(hl,[365,445]);

hp = paramSelect;
movegui(hp,[10,110]);

hmm = manualMapper;
movegui(hmm,[365,275]);