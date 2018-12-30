function getSetup

%get the default parameters for this setup
%format of setupDefault.txt for master:
%setupID: setup identification
%slaveIP: slave IP
%defaultMonitor: default monitor (long string or 3 letter code)
%alternativeMonitor: list of other monitors available
%analyzerRoot: location for saving analyzer file
%analyzerRoot: in case there are more than one analyzer directories
%acqIP: acquisition IP in a 3 computer case
%MstateHistoryFile: path to mstate history file
%ExperimentMasterFile: path to database file
%useDatabase: use database
%
%do not change the names of these fields!!!

global setupDefault
setupDefault=struct;

%location of setup file
if isunix~=1
    filePath='c:/setupDefault/';
else
    filePath='/usr/local/';
end
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
    else %this covers the case of multiple analyzer files and the monitor list
        tmp=setupDefault.(pn);
        setupDefault.(pn)=[tmp '; ' vn];
    end
    
end

%parameter conversion where necessary
if isfield(setupDefault,'useDatabase')
    setupDefault.useDatabase=str2num(setupDefault.useDatabase);
end

if isfield(setupDefault,'useMCDaq')
    setupDefault.useMCDaq=str2num(setupDefault.useMCDaq);
end

if isfield(setupDefault,'useVentilator')
    setupDefault.useVentilator=str2num(setupDefault.useVentilator);
end

if isfield(setupDefault,'useShutter')
    setupDefault.useShutter=str2num(setupDefault.useShutter);
end

if isfield(setupDefault,'useOpto')
    setupDefault.useOpto=str2num(setupDefault.useOpto);
end

fclose(fId);


        
        

