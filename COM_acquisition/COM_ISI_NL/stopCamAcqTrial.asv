function stopCamAcqTrial

global trialno cam camInfo camMeta;

% disp('Acquisition stopped');
% stop(cam);

%get data from camera
[dt, ~, camMeta{trialno}.camMetadata] = getdata(cam, cam.FramesAvailable);
camMeta{trialno}.events = cam.EventLog;

%resize for faster saving                        
dt2 = imresize(dt, camInfo.resizeScale, 'nearest');
%embedd trialno
dt2(:, :, 1, end) = trialno;
         
%save data
writeVideo(camInfo.writerObj, dt2);
                            
camMeta{trialno}.prop = size(dt2);

disp(['Trial ' num2str(trialno) ' saved']);