function getSetup

%get the default parameters for this setup
%format of setupDefault.txt for master:
%setupID: XXX
%slaveIP: XXX
%defaultMonitor: XXX
%analyzerRoot: XXX
%analyzerRoot: XXX (in case there are more than one analyzer directories)
%acqIP: XXX (in a 3 computer case)
%
%do not change the names of these fields!!!

global setupDefault
setupDefault=struct;

%location of setup file
filePath='c:/';
fileName='setupDefault.txt';

%open file
fId=fopen(fullfile(filePath,fileName));

%read the text (logic: parameter name: parameter setting)
c=textscan(fId,'%s %s');

%transform into structure

for i=1:length(c{1})
    %get parameter name minus the trailing colon
    pn=c{1}{i}(1:end-1);
    
    %get parameter value
    vn=c{2}{i};
    
    if isfield(setupDefault,pn)==0
        setupDefault.(pn)=vn;
    else %this mostly covers the case of multiple analyzer files
        tmp=setupDefault.(pn);
        setupDefault.(pn)=[tmp '; ' vn];
    end
    
end

fclose(fId);


        
        

