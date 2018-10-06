function saveExptParams

global Mstate Pstate Lstate looperInfo setupDefault

%Save the analzer file

Analyzer.M = Mstate;
Analyzer.P = Pstate;
Analyzer.L = Lstate;
Analyzer.loops = looperInfo;
Analyzer.modID = getmoduleID;
Analyzer.date=datestr(now);


title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];

roots = strtrim(strsplit(Mstate.analyzerRoot,';'));

%Save each root:
for i = 1:length(roots)

    dd = fullfile(roots{i},Mstate.anim);

    if(~exist(dd))
        mkdir(dd);  %if there is a new animal
    end

    dd = strtrim(fullfile(dd,[title '.analyzer']));

    disp(['Saving analyzer file at location:  ' dd])

    save(dd ,'Analyzer')
    
end

if setupDefault.useDatabase
    disp(['Saving analyzer to database:  ' setupDefault.dbHost ': ' setupDefault.dbName])
    insertExpIntoDb(Analyzer,setupDefault.dbHost,setupDefault.dbName,setupDefault.dbUser,setupDefault.dbPass)
end