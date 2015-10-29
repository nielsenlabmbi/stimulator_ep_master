function IP=getWindowsIP

%returns Windows IP address

[~,result]=system('ipconfig');

c1=strfind(result,'IPv4');
c2=strfind(result,'Subnet');
strtmp=deblank(result(c1:c2-1));

c3=strfind(strtmp,':');
IP=deblank(strtmp(c3+2:end));
