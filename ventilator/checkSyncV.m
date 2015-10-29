function brOk=checkSyncV

%check whether the duration that the ventilator is off is too long
%returns: 
%  brOk: 0 too long, 1 otherwise

%find all parameters that have to do with timing
pauseDur=0;

t=getParamVal('predelay');
if ~isnan(t)
    pauseDur=pauseDur+t;
end


t=getParamVal('stim_time');
if ~isnan(t)
    pauseDur=pauseDur+t;
end

if pauseDur>10
    brOk=0;
else
    brOk=1;
end