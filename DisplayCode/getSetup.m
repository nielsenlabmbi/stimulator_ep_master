function [setupID,slaveIP]=getSetup

setupIP=getWindowsIP;

switch setupIP
    case '172.30.11.131'
        setupID='2P';
        slaveIP='172.30.11.130';
        
    case '172.30.11.140'
        setupID='EP';
        slaveIP='172.30.11.142';
        
    otherwise
        disp('Unknown setup IP');
        setupID='';
        slaveIP='';
end
        
        

