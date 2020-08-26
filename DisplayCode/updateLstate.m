function updateLstate

global Lstate AppHdl

Lstate.reps = AppHdl.looper.ENReps.Value;
Lstate.rand = AppHdl.looper.SRand.Value;
Lstate.blanks = AppHdl.looper.SBlanks.Value;
Lstate.blankperiod = AppHdl.looper.ENBlanks.Value;

Ldum{1} = {[AppHdl.looper.ESymbol1.Value] [AppHdl.looper.EValue1.Value] [AppHdl.looper.SBlock1.Value]}; 
Ldum{2} = {[AppHdl.looper.ESymbol2.Value] [AppHdl.looper.EValue2.Value] [AppHdl.looper.SBlock2.Value]}; 
Ldum{3} = {[AppHdl.looper.ESymbol3.Value] [AppHdl.looper.EValue3.Value] [AppHdl.looper.SBlock3.Value]}; 
Ldum{4} = {[AppHdl.looper.ESymbol4.Value] [AppHdl.looper.EValue4.Value] [AppHdl.looper.SBlock4.Value]}; 
Ldum{5} = {[AppHdl.looper.ESymbol5.Value] [AppHdl.looper.EValue5.Value] [AppHdl.looper.SBlock5.Value]}; 

%Get rid of blank rows...
Lstate.param = cell(1,1);  %initialize
k = 1;
for i = 1:length(Ldum)
    if ~isempty(Ldum{i}{1})
        Lstate.param{k} = Ldum{i};        
        k = k+1;
    end
end

Lstate.formula = AppHdl.looper.EFormula.Value;