function updatePstate

global AppHdl Pstate PstateHistory

%get table data from paramSelect
tblVal=AppHdl.params.TblParam.Data;

%update all Pstate entries to the ones in the table
%this double checks names, rather than assuming that things are saved in
%the same order
for i=1:height(tblVal)

    for p=1:length(Pstate.param)
        if strcmp(tblVal.Var1{i},Pstate.param{p}{1})
            %found match, now update Pstate
            %this needs to take into account the type of Pstate
            %all entries in tblVal are strings
            switch Pstate.param{p}{2}
                
                case 'float'
                    Pstate.param{p}{3} = str2num(tblVal.Var2{i});
                case 'int'
                    Pstate.param{p}{3} = str2num(tblVal.Var2{i});
                case 'string'
                    Pstate.param{p}{3} = tblVal.Var2{i};
            end
            
            break;
        end
    end
            
end

 PstateHistory{AppHdl.params.DModule.Value} = Pstate;
   


