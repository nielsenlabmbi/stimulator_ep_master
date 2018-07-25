function stopCamAcqTrial

global trialno cam camInfo camMeta;

disp('Acquisition stopped');
stop(cam);

%configure the previewGUI
global GUIhandles
%acquisition flag
axes(GUIhandles.ISI_NL.acqYN); set(GUIhandles.ISI_NL.acqYN,'XTick',[],'YTick',[]); axis tight;
x = [0 1 1 0];
y = [0 0 1 1];
patch(x,y,'red','parent',GUIhandles.ISI_NL.acqYN);
    
%get data from camera
[dt, ~, camMeta{trialno}.camMetadata] = getdata(cam, cam.FramesAvailable);
camMeta{trialno}.events = cam.EventLog;

%resize for faster saving                        
dt2 = imresize(dt, camInfo.resizeScale, 'nearest');
%embed trialno
dt2(:, :, 1, end) = trialno;
         
%save data
writeVideo(camInfo.writerObj, dt2);
                            
camMeta{trialno}.prop = size(dt2);

%note the fps
camMeta{trialno}.fps = camInfo.fps;

disp(['Trial ' num2str(trialno) ' saved']);