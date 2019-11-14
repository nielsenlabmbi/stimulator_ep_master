function configPstate_BarberPole

%periodic grater

global Pstate

Pstate = struct; %clear it

Pstate.param{1} = {'predelay'  'float'      2       0                'sec'};
Pstate.param{2} = {'postdelay'  'float'     2       0                'sec'};
Pstate.param{3} = {'stat_time'  'float'     0.5       0                'sec'};
Pstate.param{4} = {'stim_time'  'float'     1       0                'sec'};

Pstate.param{5} = {'x_pos'       'int'      600       0                'pixels'};
Pstate.param{6} = {'y_pos'       'int'      400       0                'pixels'};
Pstate.param{7} = {'x_size'      'float'      3       1                'deg'};
Pstate.param{8} = {'y_size'      'float'      3       1                'deg'};

Pstate.param{9} = {'contrast'    'float'     100       0                '%'};
Pstate.param{10} = {'ori'         'int'        0       0                'deg'};
Pstate.param{11} = {'phase'         'float'        0       0                'deg'};
Pstate.param{12} = {'s_freq'      'float'      1      -1                 'cyc/deg'};
Pstate.param{13} = {'s_profile'   'string'   'sin'       0                ''};
Pstate.param{14} = {'s_duty'      'float'   0.5       0                ''};
Pstate.param{15} = {'t_period'    'int'       20       0                'frames'};

Pstate.param{16} = {'useFrame'    'int'        0       0             'binary'};
Pstate.param{17} = {'frame_width'    'float'        1       0             'deg'};

Pstate.param{18} = {'useOccluder1'    'int'        0       0             'binary'};
Pstate.param{19} = {'o1x_pos'    'int'        700       0             'pixels'};
Pstate.param{20} = {'o1y_pos'       'int'      400       0                'pixels'};
Pstate.param{21} = {'o1x_size'      'float'      3       1                'deg'};
Pstate.param{22} = {'o1y_size'      'float'      3       1                'deg'};
Pstate.param{23} = {'o1_angle'      'float'      0       1                'deg'};

Pstate.param{24} = {'useOccluder2'    'int'        0       0             'binary'};
Pstate.param{25} = {'o2x_pos'    'int'        900       0             'pixels'};
Pstate.param{26} = {'o2y_pos'       'int'      400       0                'pixels'};
Pstate.param{27} = {'o2x_size'      'float'      3       1                'deg'};
Pstate.param{28} = {'o2y_size'      'float'      3       1                'deg'};
Pstate.param{29} = {'o2_angle'      'float'      0       1                'deg'};




