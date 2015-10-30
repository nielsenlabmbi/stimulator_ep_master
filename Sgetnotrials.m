function nt = Sgetnotrials

global looperInfo

nc = Sgetnoconds;

nt = 0;
for c = 1:nc
    nr = length(looperInfo.conds{c}.repeats);
    nt = nt+nr;
end