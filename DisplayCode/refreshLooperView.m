function refreshLooperView
    global Lstate GUIhandles

    clearLooperView
    
    set(GUIhandles.looper.repeats,'string',Lstate.reps)
    set(GUIhandles.looper.randomflag,'value',Lstate.rand)
    set(GUIhandles.looper.blankflag,'value',Lstate.blanks)

    if Lstate.blanks==1
        set(GUIhandles.looper.blankPeriod,'string',Lstate.blankperiod)
        set(GUIhandles.looper.blankPeriod,'enable','on')
    else
        set(GUIhandles.looper.blankPeriod,'enable','off')
    end
    
    set(GUIhandles.looper.formula,'string',Lstate.formula)

    for i = 1:length(Lstate.param)
        eval(['symhandle = GUIhandles.looper.symbol' num2str(i) ';'])
        eval(['valhandle = GUIhandles.looper.valvec' num2str(i) ';'])

        set(symhandle,'string',Lstate.param{i}{1})
        set(valhandle,'string',Lstate.param{i}{2})
    end
end

function clearLooperView
    global GUIhandles

    set(GUIhandles.looper.repeats,'string','1')
    set(GUIhandles.looper.randomflag,'value',1)
    set(GUIhandles.looper.blankflag,'value',1)
    
    set(GUIhandles.looper.blankPeriod,'string','')
    set(GUIhandles.looper.blankPeriod,'enable','on')

    for ii = 1:5
        eval(['symhandle = GUIhandles.looper.symbol' num2str(ii) ';'])
        eval(['valhandle = GUIhandles.looper.valvec' num2str(ii) ';'])
        eval(['currtrihandle = GUIhandles.looper.currtri' num2str(ii) ';'])

        set(symhandle,'string','')
        set(valhandle,'string','')
        set(currtrihandle,'string','') 
    end
end