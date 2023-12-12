function saveAbort

global Mstate trialno

%Save abort flag to the analyzer file

title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];

roots = strtrim(strsplit(Mstate.analyzerRoot,';'));

nt = Sgetnotrials;

abortFlag=1;

%Save each root:
for i = 1:length(roots)

    dd = fullfile(roots{i},Mstate.anim);

    %if(~exist(dd))
    %    mkdir(dd);  %if there is a new animal
    %end

    dd = strtrim(fullfile(dd,[title '.analyzer']));

    
    if trialno<nt
        disp(['Adding abort to analyzer file at location:  ' dd])
        save(dd ,'abortFlag','-append')
    end
    
end

