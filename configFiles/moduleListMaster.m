function outlist = moduleListMaster(listtype)

%list of all modules on the master
%Plist is the list for the paramSelect window, Mlist for the mapper window
%the first one is the module that is automatically loaded when starting
%stimulator
%we don't use the config files for the mapper (causes issues with
%switching from mapper to paramSelect)

% Plist format: Module ID - Module name - Pstate config function - Module specific config requirements method name
% Mlist format: Module ID - Module name

Plist{1}  = {'PG' 'BW Grating'        		'configPstate_PerGrating'   		''};
Plist{2}  = {'RD' 'Random Dot'        		'configPstate_RDK'          		''};
Plist{3}  = {'RG' 'RC 1 Grating'      		'configPstate_RCGrating'    		''};
Plist{4}  = {'RT' 'RC 2 Gratings'     		'configPstate_RC2Gratings'  		''};
Plist{5}  = {'RP' 'RC Grat Plaid'     		'configPstate_RCGratPlaid'  		''};
Plist{6}  = {'RN' 'RC N Gratings'     		'configPstate_RCNGratings'  		''};
Plist{7}  = {'OF' 'Optic Flow'        		'configPstate_OpticFlow'    		''};
Plist{8}  = {'IM' 'Images'             		'configPstate_Img'          		''};
Plist{9}  = {'GA' 'GA'                		'configPstate_GA'           		'initializeModule_GA'};
Plist{10} = {'AD' 'Adaptation'        		'configPstate_Adapt'        		''};
Plist{11} = {'RA' 'RC Adapt'          		'configPstate_RCAdaptGrating'       ''};
Plist{12} = {'PC' 'Color Grating'     		'configPstate_PerGratingColor'   	''};
Plist{13} = {'BP' 'Barber Pole'       		'configPstate_BarberPole'   		''};
Plist{14} = {'TP' 'Transparent Plaid' 		'configPstate_TransparentPlaid'   	''};
Plist{15} = {'BR' 'Bar'               		'configPstate_Bar'   				''};
Plist{16} = {'BK' 'Kalatsky'          		'configPstate_Kalatsky'   			''};
Plist{17} = {'RB' 'RC Bars'           		'configPstate_RCBars'   			''};
Plist{18} = {'FR' 'Radial Freq'       		'configPstate_RadialFreq'   		''};
Plist{19} = {'PM' 'V4 Pacman'         		'configPstate_Pacman'   			''};
Plist{20} = {'GL' 'Glass'             		'configPstate_Glass'   				''};
Plist{21} = {'CK' 'Checkerboard'      		'configPstate_CheckerBoard'   		''};
Plist{22} = {'CG' 'Counter Grating'      	'configPstate_CounterBar'   		''};
Plist{23} = {'WG' 'Warped Grating'    		'configPstate_WarpedGrating'   		''};
Plist{24} = {'WC' 'Warperd Checkerb'        'configPstate_WarpedChecker'   		''};
Plist{25} = {'PW' 'Piecewise' 				'configPstate_Piecewise' 			''};
Plist{26} = {'PR' 'Piecewise Retinotopy'	'configPstate_PiecewiseRetinotopy'	''};
Plist{27} = {'IG' '3D Grating'	            'configPstate_ImgGrating'	        ''};


Mlist{1}  = {'MG' 'BW Grating'};
Mlist{2}  = {'MM' 'Bar'};
Mlist{3}  = {'MR' 'RDK'};
Mlist{4}  = {'MI' 'Images'};
Mlist{5}  = {'MP' 'Pacman'};
Mlist{6}  = {'MC' 'Piecewise'};

if strcmp(listtype,'P')
    outlist=Plist;
else
    outlist=Mlist;
end