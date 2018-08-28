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
% get info from gui
global GUIhandles
camInfo.Fps = str2num(GUIhandles.ISI_NL.FrameRate);  % Hz
camInfo.resizeScale = str2num(GUIhandles.ISI_NL.Compression);
cam.FrameGrabInterval = str2num(GUIhandles.ISI_NL.FrameGrabInterval);

% set camera trigger for the experiment params (overwrite preview settings)
P = getParamStruct;
framesPerTrigger = ceil(P.stim_time*camInfo.Fps); 
cam.FramesPerTrigger = framesPerTrigger / cam.FrameGrabInterval;
cam.TriggerFrameDelay = floor(P.predelay*camInfo.Fps/cam.FrameGrabInterval);% only record the last 1s of the preDelay
cam.TriggerSelector = 'FrameBurstStart';
triggerconfig(cam,'hardware','DeviceSpecific','DeviceSpecific');
set(cam, 'TriggerFcn', @camTriggerOccurred);
set(cam, 'TriggerMode', 'On'); %comment?
