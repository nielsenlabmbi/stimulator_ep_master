function startCamAcq
global Mstate camInfo camMeta cam;

%%%%%%%%%%%% Set file name
title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];
%open file for movie acquisition
dd = [Mstate.dataRoot '\' Mstate.anim ...
    '\' sprintf('u%s',Mstate.unit) '_' Mstate.expt ...
    '\' title '.avi'];
fprintf('Video path and filename : %s\n\n', dd);

%%%%%%%%%%%% Make video file
camInfo.writerObj = VideoWriter(dd); 
camInfo.writerObj.FrameRate = camInfo.Fps;
open(camInfo.writerObj);

camMeta = {};

%%%%%%%%%%%% Set up camera

% set camera trigger for the experiment params (overwrite preview)
P = getParamStruct;
framesPerTrigger = ceil((1 + P.stim_time + P.postdelay)*camInfo.Fps); 
cam.FrameGrabInterval = 2;          % save every other frame
cam.FramesPerTrigger = framesPerTrigger / cam.FrameGrabInterval;
cam.TriggerFrameDelay = (P.predelay>=1)*floor((P.predelay - 1)*camInfo.Fps/cam.FrameGrabInterval);% only record the last 1s of the preDelay
cam.TriggerSelector = 'FrameBurstStart';
triggerconfig(cam,'hardware','DeviceSpecific','DeviceSpecific');
set(cam, 'TriggerFcn', @camTriggerOccurred);
% set(cam, 'TriggerMode', 'On');
