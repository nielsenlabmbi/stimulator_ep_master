function setShutter(cond)

%sets the shutter correctly for a particular condition

global looperInfo  


bflag = strcmp(looperInfo.conds{cond}.symbol{1},'blank');

if bflag==0  %if it is not a blank condition - shutter will not be moved in blanks
    
    %execute any shutter related parameter settings
    Nparams = length(looperInfo.conds{cond}.symbol);
    for i = 1:Nparams
        pval = looperInfo.conds{cond}.val{i};
        psymbol = looperInfo.conds{cond}.symbol{i};
        eval([psymbol '=' num2str(pval) ';'])  %May be used to evaluate formula below (dependencies);
        
        eyefunc(psymbol,pval)  %This moves the eye shutters if its the right symbol
    end
    
    %execute shutter commands in the formula
    fmla = looperInfo.formula;
    id = find(fmla == ' ');
    fmla(id) = [];
    if ~isempty(fmla)
        fmla = [';' fmla ';'];
        ide = find(fmla == '=');
        ids = find(fmla == ';'); % | fmla == ',');

        for e = 1:length(ide);

            delim1 = max(find(ids<ide(e)));
            delim1 = ids(delim1)+1;
            delim2 = min(find(ids>ide(e)));
            delim2 = ids(delim2)-1;

            try
                eval([fmla(delim1:delim2) ';'])  %any dependencies should have been established above
            catch ME

                if strcmp(ME.message(1:30),'Undefined function or variable')
                    
                    varname = ME.message(33:end-2);
                    pval = getParamVal(varname);  %get the value from Pstate
                    eval([varname '=' num2str(pval) ';']) 
                    eval([fmla(delim1:delim2) ';'])  %try again   
                end
            end
            
            psymbol_Fmla = fmla(delim1:ide(e)-1);
            pval_Fmla = eval(psymbol_Fmla);
            
            eyefunc(psymbol_Fmla, pval_Fmla)  %This moves the eye shutters if its the right symbol
            
        end
    end
    
end



function eyefunc(sym,bit)

if strcmp(sym,'Leye_bit')
    moveShutter(1,bit);
    waitforDisplayResp;
elseif strcmp(sym,'Reye_bit')
    moveShutter(2,bit);
    waitforDisplayResp;
elseif strcmp(sym,'eye_bit')
    switch bit
        case 0
            moveShutter(1,1);
            waitforDisplayResp
            moveShutter(2,0);
            waitforDisplayResp
        case 1
            moveShutter(1,0);
            waitforDisplayResp
            moveShutter(2,1);
            waitforDisplayResp
        case 2
            moveShutter(1,1);
            waitforDisplayResp
            moveShutter(2,1);
            waitforDisplayResp
        otherwise
    end
end
    



