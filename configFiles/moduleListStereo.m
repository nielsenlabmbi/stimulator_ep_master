function outlist = moduleListStereo(listtype)

%list of all modules on the master
%Plist is the list for the paramSelect window, Mlist for the mapper window,
%Glist for the GA window
%the first one is the module that is automatically loaded when starting
%stimulator
%we don't use the config files for the mapper (causes issues with
%switching from mapper to paramSelect)

% Plist format: Module ID - Module name - Pstate config function - Module specific config requirements method name
% Mlist format: Module ID - Module name


Plist{1}  = {'SG' 'BW Grating'        		    'configPstate_PerGrating_Stereo'   		''};
Plist{end+1}  = {'SD' 'Random Dot'        		'configPstate_RDK_Stereo'          		''};
Plist{end+1}  = {'SR' 'RC 1 Grating'      		'configPstate_RCGrating_Stereo'    		''};
Plist{end+1}  = {'RT' 'RC 2 Gratings'     		'configPstate_RC2Gratings'  		''};
Plist{end+1}  = {'RP' 'RC Grat Plaid'     		'configPstate_RCGratPlaid'  		''};
Plist{end+1}  = {'RN' 'RC N Gratings'     		'configPstate_RCNGratings'  		''};
Plist{end+1}  = {'OF' 'Optic Flow'        		'configPstate_OpticFlow'    		''};
Plist{end+1} = {'BR' 'Bar'               		'configPstate_Bar'   				''};
Plist{end+1} = {'SK' 'Kalatsky'          		'configPstate_Kalatsky_Stereo'   			''};
Plist{end+1} = {'SB' 'RC Bars'           		'configPstate_RCBars_Stereo'   			''};
Plist{end+1} = {'CK' 'Checkerboard'      		'configPstate_CheckerBoard'   		''};
Plist{end+1} = {'MS' 'M sequence'               'configPstate_MSeq'                 ''};


Mlist{1}  = {'MG' 'BW Grating'};
Mlist{2}  = {'MM' 'Bar'};
Mlist{3}  = {'MR' 'RDK'};



switch listtype
    case 'P'
        outlist=Plist;
    case 'M'
        outlist=Mlist;
end