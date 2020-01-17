function waitforIsiResp

global IsiComState 

%Clear the buffer
n = get(IsiComState.serialPortHandle,'BytesAvailable');
if n > 0
    fread(IsiComState.serialPortHandle,n); %clear the buffer
end

%Wait...
n = 0;  %Need this, or it won't enter next loop (if there were leftover bits)!!!!
while n == 0 
    n = get(IsiComState.serialPortHandle,'BytesAvailable'); %Wait for response
end
pause(.5) %Hack to finish the read

n = get(IsiComState.serialPortHandle,'BytesAvailable');
if n > 0
    fread(IsiComState.serialPortHandle,n); %clear the buffer
end

