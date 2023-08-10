function updateLstate
%Lstate combines variables from both the looper and the reference stim GUI
%since both are relevant for constructing the trials list

global Lstate AppHdl

%Lstate variables from looper window
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

%Lstate variables from reference stim window
Lstate.refstim = AppHdl.refstim.SStim.Value;
Lstate.refperiod = AppHdl.refstim.ENStim.Value;

Ldum{1} = {[AppHdl.refstim.ESymbol1.Value] [AppHdl.refstim.EValue1.Value]}; 
Ldum{2} = {[AppHdl.refstim.ESymbol2.Value] [AppHdl.refstim.EValue2.Value]}; 
Ldum{3} = {[AppHdl.refstim.ESymbol3.Value] [AppHdl.refstim.EValue3.Value]}; 
Ldum{4} = {[AppHdl.refstim.ESymbol4.Value] [AppHdl.refstim.EValue4.Value]}; 
Ldum{5} = {[AppHdl.refstim.ESymbol5.Value] [AppHdl.refstim.EValue5.Value]}; 

Lstate.refParam = cell(1,1);  %initialize
k = 1;
for i = 1:length(Ldum)
    if ~isempty(Ldum{i}{1})
        Lstate.refParam{k} = Ldum{i};        
        k = k+1;
    end
end

