function openSetupGui

global setupDefault  AppHdl;


if setupDefault.useShutter
    AppHdl.shutter=shutterSettingNew;
    %movegui(h2,[575,170]);
end

%if setupDefault.useOpto
    %h3=optoStim;
    %movegui(h3,[575,170]);
%end
    
