function buildStimulus(cond,trial)

%Sends stimulus information for the current trial to the slave

global DcomState looperInfo Mstate Pstate Lstate AppHdl

bflag = strcmp(looperInfo.conds{cond}.symbol{1},'blank');
refflag = strcmp(looperInfo.conds{cond}.symbol{1},'refstim');


if bflag
    %in the blanks, no stimulus needs to be built
    msg = ['L;' num2str(trial)];
    
elseif refflag
    %build reference stimulus
    Mod = getmoduleID;
    msg = ['B;' Mod ';' num2str(trial)];

    %evaluate parameters - these are fixed, saved in Lstate
    Nparams = length(Lstate.refParam);
    for i = 1:Nparams
        psymbol = Lstate.refParam{i}{1}; %parameter name
        eval(['pval = ' Lstate.refParam{i}{2} ';']); %
        msg = updateMsg(pval,psymbol,msg);		
    end
else
    Mod = getmoduleID;
    
    msg = ['B;' Mod ';' num2str(trial)];
    
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
        %disp(msg)
        eval([psymbol '=' num2str(pval) ';'])
        eval(['AppHdl.looper.TTrial' num2str(i) '.Text="' num2str(pval) '";']);
		
    end
    
    %evaluate the formula - we're using the entire formula here so that we
    %can use if statements etc
    if ~isempty(looperInfo.formula{1})
        
        %formula can now be entered in multiple lines - gets returned as
        %char array
        %first transform into cell array to make things easier
        fmla=cellstr(looperInfo.formula);
        %remove empty lines
        fmla=fmla(~cellfun('isempty',fmla));
        
        %check to see whether there are 2 statements in 1 line - break up
        %for further processing
        %should have a ; in the middle of the statement, not at the end of
        %the line
        ids=strfind(fmla,';');
        for i=1:length(ids)
            if ~isempty(ids{i})
                if ids{i}<length(fmla{i})
                    %split the line with the semicolon
                    fmlaPart=strsplit(fmla{i},';');
                    
                    %need to insert into formula - shift everything else
                    %down, then insert
                    nLines=length(fmlaPart);
                    nOrig=length(fmla);
                    fmla(i+nLines:nOrig+nLines-1)=fmla(i+1:nOrig);
                    for j=1:nLines
                        fmla(i+j-1)=fmlaPart(j);
                    end
                end
            end
        end
                    
        
        %evaluate formula - this will set the variables to their
        %correct values, which is necessary before sending them
        %(extra ; seem not to matter, so no further check)
        efmla=[];
        for i=1:length(fmla)
            efmla=[efmla fmla{i} ';'];
        end
        %disp(efmla);
        eval(efmla);
    
        %now build message for the slave
        %go through and find variables in the formula; append them with
        %their values to the message to the slave 
        
        %find equal signs (variables are before them)
        %returns a cell array of the same size as fmla
        ide=strfind(fmla,'=');
        %disp(ide)
        
        %remove = in logical statements; these are instances in which there
        %is not a letter or number before the 
        for i=1:length(ide)            
            fmlaL=fmla{i}(max(ide{i})-1);
           % disp(fmlaL)
            if ~isstrprop(fmlaL,'alphanum') && ~isspace(fmlaL)
                ide{i}=[];
            end
        end
              
        %now loop through = and get variable names
        % to deal with if statements correctly, first find all names here
        for i=1:length(fmla)
            %disp(fmla{i})
            if ~isempty(ide{i})
                fmlaPart=strsplit(fmla{i},'=');                
                fmlaSymbol{i} = strtrim(fmlaPart{1});
                %disp(fmlaSymbol{i})
            end
        end
        fmlaUSymbol=unique(fmlaSymbol(~cellfun('isempty',fmlaSymbol)));
        
        %add names and value to message
        for i=1:length(fmlaUSymbol)
            psymbol_Fmla=fmlaUSymbol{i};
            pval_Fmla = eval(psymbol_Fmla);
                   
            %update message - this checks whether the symbol actually
            %appears in Pstate
           % disp(pval_Fmla)
           % disp(psymbol_Fmla)
            msg = updateMsg(pval_Fmla,psymbol_Fmla,msg);
            %disp(msg);
        end
        
    end %isempty formula
    
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
if ~isempty(idx)  %its possible that looper variable is not a stimulus parameter
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


% if psymbol contains multiple variables, like: [ori,x_pos,y_pos]
% this only works if the values corresponding to these variables are single
% numbers. not strings or matrices.
if (psymbol(1) == '[' && psymbol(end) == ']')
    psymbol = psymbol(2:end-1);
    commas = strfind(psymbol,',');
    vars = textscan(psymbol,repmat('%s',1,length(commas)+1),'delimiter',',');
    if length(vars) == length(pval)
        for ii=1:length(vars)
            %Find parameter in Pstruct
            idx = [];
            for j = 1:length(Pstate.param)
                if strcmp(vars{ii}{1},Pstate.param{j}{1})
                    idx = j;
                    break;
                end
            end

            %change value based on looper
            if ~isempty(idx)  %its possible that looper variable is not a grating parameter
                prec = Pstate.param{idx}{2};  %Get precision
                switch prec
                    case 'float'
                        msg = sprintf('%s;%s=%.4f',msg,vars{ii}{1},pval(ii));
                    case 'int'
                        msg = sprintf('%s;%s=%d',msg,vars{ii}{1},round(double(pval(ii))));
                end
            end
        end
    else
        disp('Could not parse variables in the formula. Please debug.');
    end
end

