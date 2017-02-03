function saveSyncInfo(syncInfo)

global Mstate trialno

title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];

roots = strtrim(strsplit(Mstate.analyzerRoot,';'));  

eval(['syncInfo' num2str(trialno) '=syncInfo;'])
clear syncInfo

%Save each root:
for i = 1:length(roots)

    dd = [roots{i} '\' Mstate.anim];

    if(~exist(dd))
        mkdir(dd);  %if there is a new animal
    end

    dd = [dd '\' title '.analyzer'];

    disp(['Appending sync info to .analyzer file at location:  ' dd])

    save(dd ,['syncInfo' num2str(trialno)],'-append')    
end

