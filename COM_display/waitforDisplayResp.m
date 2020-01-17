function comerr=waitforDisplayResp(varargin)   

global DcomState 
comhandle = DcomState.serialPortHandleReceiver;
%Clear the buffer
n = get(comhandle,'BytesAvailable');
if n > 0
    fread(comhandle,n); %clear the buffer
end
%Wait...
n = 0;  %Need this, or it won't enter next loop (if there were leftover bits)!!!!
t1=clock;
if nargin==0
    while n == 0 
        n = get(comhandle,'BytesAvailable'); %Wait for response
    end
    comerr=0;
else
    v=zeros(1,6);
    %disp(varargin{1})
    while n == 0 && v(6)<varargin{1}
        n = get(comhandle,'BytesAvailable'); %Wait for response
        t2=clock;
        v=t2-t1;
        %disp(v(6))
    end
    if n==0
        comerr=1;
    else
        comerr=0;
    end
end
pause(.5) %Hack to finish the read

n = get(comhandle,'BytesAvailable');
if n > 0
    fread(comhandle,n); %clear the buffer
end
