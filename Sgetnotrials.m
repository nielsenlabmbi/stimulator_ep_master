function nt = Sgetnotrials

global looperInfo

nc = Sgetnoconds;

nt = 0;
for c = 1:nc
    nr= Sgetnoreps(c);
    for r=1:nr
        nt = nt+ length(looperInfo.conds{c}.repeats{r}.trialno); %necessary to allow for multiple blanks per repeat
    end
end