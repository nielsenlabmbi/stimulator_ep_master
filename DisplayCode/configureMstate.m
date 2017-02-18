function configureMstate

global Mstate setupDefault

if exist('C:\stimulator_master\MstateHistory.mat','file')
    load('C:\stimulator_master\MstateHistory.mat');
else
    Mstate.anim = 'xxxx0';
    Mstate.unit = '000';
    Mstate.expt = '000';

    Mstate.hemi = 'left';
    Mstate.screenDist = 25;
    
    Mstate.syncSize = 4;  %Size of the screen sync in cm

    Mstate.running = 0;
    
    if isfield(setupDefault,'acqDataRoot')
        Mstate.dataRoot=setupDefault.acqDataRoot;
    else
        Mstate.dataRoot='';
    end
    
    if isfield(setupDefault,'isiOnlineRoot')
        Mstate.isiOnlineRoot=setupDefault.isiOnlineRoot;
    else
        Mstate.isiOnlineRoot='';
    end
    
    % initialize setup specific Mstate values
    Mstate.monitorName=setupDefault.defaultMonitor;
    Mstate.analyzerRoot=setupDefault.analyzerRoot;
    
    save('C:\stimulator_master\MstateHistory.mat','Mstate');
end
    
updateMonitorValues



