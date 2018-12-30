function run2


%This function now gets called for play sample, as well. Hence the global
%conditional of Mstate.runnind

global GUIhandles  Mstate trialno setupDefault shutterInfo

if Mstate.running
    nt = Sgetnotrials;
end



if Mstate.running && trialno<=nt
    
    set(GUIhandles.main.showTrial,'string',['Trial ' num2str(trialno) ' of ' num2str(nt)] ), drawnow

    [c,~] = Sgetcondrep(trialno);  %get cond and rep for this trialno

    %set eye shutter (only if daq is being used; otherwise this is
    %pointless)
    if setupDefault.useShutter==1 
        setShutter(c)
        pause(shutterInfo.waitTime/1000);
    end
    
    
    %send breathing info (independent of whether or not it was selected ->
    %this allows us to turn it off during the experiment if necessary)
    if setupDefault.useVentilator && setupDefault.useMCDaq
        updateSyncV(get(GUIhandles.main.syncVflag,'Value'));
        waitforDisplayResp;
    end
    
    %%%Organization of commands is important for timing in this part of loop
    tic
    disp(['Building and sending stimulus.']);
    buildStimulus(c,trialno)    %Tell stimulus to buffer the images
    waitforDisplayResp;
%     cerr=waitforDisplayResp(10);   %Wait for serial port to respond from display
%     if cerr==1 %communication timed out
%         %try again
%         cerrCount=1;
%         while cerrCount<5 && cerr==1
%             disp('Comm error at build stimulus; resending!')
%             cerr=waitforDisplayResp(10);
%             cerrCount=cerrCount+1;
%         end
%     end 
    buildSendTime = toc;
    fprintf('\t'); disp(['Computation/communication time: ' num2str(buildSendTime) 's.']) 
    mod = getmoduleID;
    fprintf('\t'); disp('Playing stimulus...');
    startStimulus(mod)      %Tell Display to show its buffered images. 
    %waitforDisplayResp
    
    
    trialno = trialno+1;

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    
    %This is executed at the end of experiment and when abort button is hit
    if get(GUIhandles.main.daqflag,'value');
        pause(5);
        stopAcq;
    end
    
    Mstate.running = 0;
    set(GUIhandles.main.runbutton,'string','Run')

    
end


