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
disp(['Message received from slave: ' inString]);
    
%'nextT' is the string sent after stimulus is played
%If it just played a stimulus, and scanimage is not acquiring, then run
%next trial...
if strcmp(inString,'nextT')    
    runNextTrialDisp    
end
