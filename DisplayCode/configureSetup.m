function configureSetup

global setupDefault

if setupDefault.useShutter
    global shutterInfo
    
    shutterInfo.LEch=1;
    shutterInfo.LEopen=1;
    shutterInfo.REch=2;
    shutterInfo.REopen=1;
    shutterInfo.waitTime=100;
    
end