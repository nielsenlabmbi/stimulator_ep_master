function Displaycb(obj,event)
%Callback function from Stimulus PC

global DcomState

n=get(DcomState.serialPortHandleReceiver,'BytesAvailable');
if n > 0
    inString = fread(DcomState.serialPortHandleReceiver,n);
    inString = char(inString');
else
    return
end

inString = inString(1:end-1);  %Get rid of the terminator
fprintf('\t'); disp(['Message received from slave: ' inString]);
    
%'nextT' is the string sent after stimulus is played
if strcmp(inString,'nextT')
    %if get(GUIhandles.main.daqflag,'value')  %Flag for the link with acquisition programs
    %    finishAcqTrial;
    %end
    run2    
end
