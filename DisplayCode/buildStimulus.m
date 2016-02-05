function buildStimulus(cond,trial)

global DcomState

%Sends loop information and buffers

global looperInfo Mstate Pstate GUIhandles

bflag = strcmp(looperInfo.conds{cond}.symbol{1},'blank');

if bflag
    %in the blanks, no stimulus needs to be built
    msg = 'L';
    
else
    mod = getmoduleID;
    
    msg = ['B;' mod ';' num2str(trial)];
    
    %evaluate all Mstate parameters locally, in case of dependencies in the
    %formula
    Mf = fields(Mstate);
    for i = 1:length(fields(Mstate))
        eval([Mf{i} '= Mstate.'  Mf{i} ';' ])
    end
    
    %For the same reason, evaluate all parameters in Pstate
    %this needs to happen only locally
    for i = 1:length(Pstate.param)
        eval([Pstate.param{i}{1} '= Pstate.param{i}{3};' ])
    end
    
    %for each parameter in the looper, get value for the current condition
    %this also needs to be sent out to the slave
    Nparams = length(looperInfo.conds{cond}.symbol);
    for i = 1:Nparams
        pval = looperInfo.conds{cond}.val{i};
        psymbol = looperInfo.conds{cond}.symbol{i};
        msg = updateMsg(pval,psymbol,msg);
        eval([psymbol '=' num2str(pval) ';'])  
		eval(['set(GUIhandles.looper.currtri' num2str(i) ',''string'',' num2str(pval) '), drawnow;']);
    end
    
    %evaluate the formula - we're using the entire formula here so that we
    %can use if statements etc
    fmla=looperInfo.formula;
    if ~isempty(fmla)
        if fmla(end)~=';'
            fmla=[fmla ';'];
        end
        eval(fmla);
    
        %now go through and find variables in the formula; append them with
        %their values to the message to the slave 
        %find equal signs (variables are before them)
        ide=strfind(fmla,'=');
        
        %remove == and ~= (for if statements)
        id2=strfind(fmla,'==');
        if ~isempty(id2)
            ide(ide==id2 | ide==id2+1) = [];
        end
        
        id2=strfind(fmla,'~=');
        if ~isempty(id2)
            ide(ide==id2+1)=[];
        end
        
        %now loop through = and get variable names - between equal and
        %previous ;
        ids=strfind(fmla,';');
        
        for e = 1:length(ide);
            
            delim1 = max(find(ids<ide(e)));
            if isempty(delim1)
                delim1=1;
            else
                delim1 = ids(delim1)+1;
            end
               
            psymbol_Fmla = fmla(delim1:ide(e)-1);
            pval_Fmla = eval(psymbol_Fmla);
            
            %update message - this checks whether the symbol actually
            %appears in Pstate
            msg = updateMsg(pval_Fmla,psymbol_Fmla,msg);
        end
    end
    
end

msg = [msg ';~'];  %add the "Terminator"

fwrite(DcomState.serialPortHandle,msg);



function msg = updateMsg(pval,psymbol,msg)

global Pstate

id = find(psymbol == ' ');
psymbol(id) = []; %In case the user put in spaces with the entry

%Find parameter in Pstruct
idx = [];
for j = 1:length(Pstate.param)
    if strcmp(psymbol,Pstate.param{j}{1})
        idx = j;
        break;
    end
end

%change value based on looper
if ~isempty(idx)  %its possible that looper variable is not a grating parameter
    prec = Pstate.param{idx}{2};  %Get precision
    switch prec
        case 'float'
            msg = sprintf('%s;%s=%.4f',msg,psymbol,pval);
        case 'int'
            msg = sprintf('%s;%s=%d',msg,psymbol,round(double(pval)));
        case 'string'
            msg = sprintf('%s;%s=%s',msg,psymbol,pval);
    end
end

