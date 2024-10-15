function makeLoop

%this function generates the looper structure for the experiment; it takes
%Lstate, which is set in updateLstate
%returns:
%changes in the global variable looperInfo

global Lstate looperInfo

looperInfo = struct;  %reset 
rng('shuffle')

Nparam = length(Lstate.param); %number of looper parameters

%Produces a cell array 'd', with each element corresponding to a different
%looper variable (parameter).  Each element contains a multidimensional array from
%ndgrid with as many elements as there are conditions. They are id's, not
%actually variable values.
nc = 1; %nr of conditions
for i = 1:Nparam
    eval(['paramV = ' Lstate.param{i}{2} ';']);
    nc = nc*length(paramV);
    blockpar(i)=Lstate.param{i}{3};
    if i == 1
        istring = ['1:' num2str(length(paramV))]; %input string for 'meshgrid'
        ostring = ['d{' num2str(i) '}'];  %output string for meshgrid
    else
        istring = [istring ',1:' num2str(length(paramV))]; %istring takes the form [1:length(param1),1:length(param2),...]
        ostring = [ostring ',' 'd{' num2str(i) '}']; %ostring takes the form [d{1},d{2},...]
    end
    
end

istring = ['ndgrid(' istring ')'];
ostring = ['[' ostring ']'];
eval([ostring ' = ' istring ';']); %this translates to eval([d{1},d{2},...]=ndgrid(1:length(param1),1:length(param2),...)
%d contains the combinations of indices into the different parameters for
%each condition

%blanks?
bflag = Lstate.blanks;
bPer = Lstate.blankperiod; %blanks per repeat

%reference stim? (interleaved like blanks)
refflag = Lstate.refstim;
refPer = Lstate.refperiod;

%randomization and repeats
nrep = Lstate.reps;
randomflag = Lstate.rand;

%save basic condition info (symbol and value) in looper structure
%cond has as many entries as conditions (cross between parameters plus
%blanks plus ref stim)
for c = 1:nc
    for p = 1:Nparam
        idx = d{p}(c); %index to get the parameter value for condition c

        paramS = Lstate.param{p}{1}; %parameter name
        eval(['paramV = ' Lstate.param{p}{2} ';']);  %all parameter values for the parameter

        looperInfo.conds{c}.symbol{p} = paramS;
        looperInfo.conds{c}.val{p} = paramV(idx);
    end
end

%add the blanks
if bflag==1
    for p = 1:Nparam
        looperInfo.conds{nc+1}.symbol{p} = 'blank';
        looperInfo.conds{nc+1}.val{p} = [];
    end
end

%add the fullfield stimuli
if refflag==1
    for p=1:Nparam
        looperInfo.conds{nc+bflag+1}.symbol{p} = 'refstim'; %specifics of refstim are saved in L
        looperInfo.conds{nc+bflag+1}.val{p} = [];
    end
end


%Put the formula in looperInfo
looperInfo.formula = Lstate.formula;

%now generate the actual trials structure
if ~any(blockpar) %no blocking
    
    tv=[1:nc]; %condition vector
    if bflag
        tv(end+1:end+bPer)=nc+1; %add blanks
    end
    if refflag
        tv(end+1:end+refPer)=nc+bflag+1; %add reference stim
    end
    
    for r=1:nrep
        if randomflag %full randomization
            trep=tv(randperm(length(tv)));
        else %no randomization
            trep=tv;
        end
        
        for c=1:nc+bflag+refflag
            idx=find(trep==c);
            looperInfo.conds{c}.repeats{r}.trialno = length(tv)*(r-1) + idx;
        end
    end
    
else %blocking
   
    %determine which parameter(s) are blocked
    blockidx=find(blockpar==1); 
    
    %determine number and parameter list for the blocked parameters
    valblock={};
    nblock=[];
    for b=1:length(blockidx)
        valblock{b}=unique(d{blockidx(b)}); %parameter values of the blocked parameter
        nblock(b)=length(valblock{b}); %nr of parameter values for the blocked parameter
    end
    
    %generate list of block conditions - this only contains all
    %combinations of the parameters that are blocked
    blocklist=[];
    for b=1:length(blockidx)
        %figure out how many element repeats we need (this decreases with
        %the level in the hierarchy)
        nerep=1;
        for i=b+1:length(blockidx)
            nerep=nerep*nblock(i);
        end
        
        %figure out how many vector repeats we need (this increases with
        %the hierarchy level)
        nvrep=prod(nblock)/(nblock(b)*nerep);
        
        %now build list, randomizing element order if necessary
        tmplist=[];
        for i=1:nvrep
            if randomflag
                blist=valblock{b}(randperm(length(valblock{b})));
            else
                blist=valblock{b};
            end
            tmplist=[tmplist;repelem(blist,nerep)];
        end
         
        blocklist(:,b)=tmplist;
    end
    
    %now generate actual trial structure
    for n=1:prod(nblock) 
        
        %determine which conditions contain the correct value for the
        %blocked parameters
        teststr='find(d{blockidx(1)}==blocklist(n,1)';
        for b=2:length(blockidx)           
            teststr=[teststr ' & d{' num2str(blockidx(b)) '}==blocklist(n,' num2str(b) ')'];
        end
        teststr=[teststr ')'];
        tv=eval(teststr); 
                
        if bflag
           tv(end+1:end+bPer)=nc+1; %add blanks
        end
        if refflag
            tv(end+1:end+refPer)=nc+bflag+1; %add reference stim
        end
        
        tvunique=unique(tv); %this is necessary because of possible multiple blanks
        
        for r=1:nrep
            if randomflag 
                trep=tv(randperm(length(tv)));
            else 
                trep=tv;
            end
        
            for c=tvunique'
                idx=find(trep==c);
                if n>1 && c==nc+1 %need to deal with the fact that blanks in different chunks share the same repeat (
                    %repeat is correct for the other conditions)
                    looperInfo.conds{c}.repeats{r}.trialno = [looperInfo.conds{c}.repeats{r}.trialno ...
                        (r-1)*length(tv)+(n-1)*nrep*length(tv)+ idx];
                elseif n>1 && c==nc+bflag+1 %same for refstim
                    looperInfo.conds{c}.repeats{r}.trialno = [looperInfo.conds{c}.repeats{r}.trialno ...
                        (r-1)*length(tv)+(n-1)*nrep*length(tv)+ idx];
                else
                    looperInfo.conds{c}.repeats{r}.trialno = (r-1)*length(tv) +(n-1)*nrep*length(tv) + idx;
                end
            end
        end
     end %for n
end

