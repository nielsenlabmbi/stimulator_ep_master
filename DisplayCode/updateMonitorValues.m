function updateMonitorValues

global Mstate setupDefault

%get the important monitor parameters; we largely do this here because we
%may need correct settings for the computation of parameters in the looper
%(e.g. retinotopy experiments) 

monitorPar=feval(setupDefault.monitorList,Mstate.monitorName);


Mstate.monitorID=monitorPar.ID;
Mstate.screenXcm = monitorPar.screenXcm;
Mstate.screenYcm = monitorPar.screenYcm;
Mstate.xpixels = monitorPar.xpixels;
Mstate.ypixels = monitorPar.ypixels;
        
