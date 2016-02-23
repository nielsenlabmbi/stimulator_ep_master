function configureMstate

global Mstate

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
    Mstate.dataRoot='c:\data';
    
    % initialize setup specific Mstate values
    if strcmp(getSetup,'EP')
        Mstate.monitor = 'VSN';  %This should match the default value in Display
        Mstate.analyzerRoot = 'C:\VStimFiles\AnalyzerFiles; Z:\Ephys\AnalyzerFiles';
    else
        Mstate.monitor = 'LCD';  %This should match the default value in Display
        Mstate.analyzerRoot = 'C:\VStimFiles\AnalyzerFiles; Z:\2P\Analyzer';
    end
    
    save('C:\stimulator_master\MstateHistory.mat','Mstate');
end
    
updateMonitorValues



