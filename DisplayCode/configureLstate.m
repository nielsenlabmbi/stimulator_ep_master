function configureLstate

global Lstate

%looper parameters
Lstate.reps = 1;
Lstate.rand = 1;

Lstate.blanks = 1;
Lstate.blankperiod = 1;

Lstate.formula = '';

for i=1:5
    Lstate.param{i} = {[] [] []}; %param value block
end


%ref stim parameters
Lstate.refstim = 0;
Lstate.refperiod = 1;

for i=1:5
    Lstate.refParam{i} = {[] []}; %param value
end
