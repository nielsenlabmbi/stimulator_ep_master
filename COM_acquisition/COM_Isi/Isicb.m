function Isicb(obj,event)
%Callback function from Stimulus PC

global IsiComState

n=get(IsiComState.serialPortHandleReceiver,'BytesAvailable');
if n > 0
    inString = fread(DcomState.serialPortHandleReceiver,n);
    inString = char(inString');
else
    return
end

inString = inString(1:end-1);  %Get rid of the terminator
fprintf('\t'); disp(['Message received from slave: ' inString]);
    
