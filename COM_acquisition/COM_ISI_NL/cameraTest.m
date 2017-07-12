%%% Code for testing the ISI camera

% create camera 
cam = videoinput('gige', 1);
src = getselectedsource(cam);
stop(cam);

% set camera trigger 
triggerconfig(cam,'manual');
framesPerTrigger = 15; % We're counting on a software stop
cam.FrameGrabInterval = 2;          % save every other frame
cam.FramesPerTrigger = framesPerTrigger / cam.FrameGrabInterval;
src.TriggerSelector = 'FrameBurstStart';
% triggerconfig(cam,'hardware','DeviceSpecific','DeviceSpecific');
%set(cam, 'TriggerFcn', @camTriggerOccurred);

% make sure Jumbo Frames are set to 9k in the GigE NIC adapter settings
src.PacketSize = 9000;

%set details of movie acquisition
camInfo.Fps = 15;  % Hz
camInfo.resizeScale = 0.25;  % 0.5;    reduce frame size

%% 
start(cam)
trigger(cam)
pause(2)
trigger(cam)
stop(cam)
%%
events = cam.EventLog;
[~,~,metadata] = getdata(cam,cam.FramesAvailable);