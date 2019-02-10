function startCamAcq
global Mstate camInfo camMeta cam GUIhandles Pstate;

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
camInfo.Fps = str2num(GUIhandles.ISI_NL.FrameRate);  % Hz
camInfo.resizeScale = str2num(GUIhandles.ISI_NL.Compression);
cam.FrameGrabInterval = str2num(GUIhandles.ISI_NL.FrameGrabInterval);

%determine timing
strDur=strsplit(GUIhandles.ISI_NL.AcqDur,'+');
acqDur=0;
for i=1:length(strDur)
    for j = 1:length(Pstate.param)
        if strcmp(strDur{i},Pstate.param{j}{1})
            acqDur=acqDur+Pstate.param{j}{3};
            break;
        end
    end
end
framesPerTrigger = ceil(acqDur*camInfo.Fps); 

% set camera trigger for the experiment params (overwrite preview settings)
cam.FramesPerTrigger = framesPerTrigger / cam.FrameGrabInterval;
cam.TriggerFrameDelay = floor(P.predelay*camInfo.Fps/cam.FrameGrabInterval);% only record the last 1s of the preDelay
cam.TriggerSelector = 'FrameBurstStart';
triggerconfig(cam,'hardware','DeviceSpecific','DeviceSpecific');
set(cam, 'TriggerFcn', @camTriggerOccurred);
set(cam, 'TriggerMode', 'On'); %comment?
