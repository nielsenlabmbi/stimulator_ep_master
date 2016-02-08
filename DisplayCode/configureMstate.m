function configureMstate

global Mstate

Mstate.anim = 'xxxx0';
Mstate.unit = '000';
Mstate.expt = '000';

Mstate.hemi = 'left';
Mstate.screenDist = 25;

% initialize setup specific Mstate values
if strcmp(getSetup,'EP')
    Mstate.monitor = 'VSN';  %This should match the default value in Display
    Mstate.analyzerRoot = 'C:\VStimFiles\AnalyzerFiles; Z:\Ephys\AnalyzerFiles';
else
    Mstate.monitor = 'LCD';  %This should match the default value in Display
    Mstate.analyzerRoot = 'C:\VStimFiles\AnalyzerFiles; Z:\2P\Analyzer';
end

updateMonitorValues

Mstate.syncSize = 4;  %Size of the screen sync in cm

Mstate.running = 0;
Mstate.dataRoot='c:\data';
