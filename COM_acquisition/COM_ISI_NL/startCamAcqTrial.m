function startCamAcqTrial
global trialno cam; 

disp(['Trial ' num2str(trialno) ' start (waiting for trigger)']);
start(cam);
