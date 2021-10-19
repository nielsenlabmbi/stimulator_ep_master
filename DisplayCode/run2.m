function run2


%This function now gets called for play sample, as well. Hence the global
%conditional of Mstate.runnind

global AppHdl  Mstate trialno setupDefault shutterInfo

if Mstate.running
    nt = Sgetnotrials;
end



if Mstate.running && trialno<=nt
    
    AppHdl.main.TProgress.Value=['Trial ' num2str(trialno) ' of ' num2str(nt)];
    

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
        updateSyncV(AppHdl.main.SSyncVent.Value);
        waitforDisplayResp;
    end
    
    %run any trial-dependent code for the acquisition
    if AppHdl.main.BStimDAQ.Value==1
        startAcqTrial;
    end
    
    %%%Organization of commands is important for timing in this part of loop
    tic
    disp('Building and sending stimulus.');
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

    %run any trial-dependent code for the acquisition
    if AppHdl.main.BStimDAQ.Value==1
        stopAcqTrial;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    
    %This is executed at the end of experiment and when abort button is hit
    if AppHdl.main.BStimDAQ.Value==1
        pause(5);
        stopAcq;
    end
    
    saveAbort; %add abort flag to analyzer file
    
    Mstate.running = 0;
    AppHdl.main.BRun.Text='Run';
    
end


