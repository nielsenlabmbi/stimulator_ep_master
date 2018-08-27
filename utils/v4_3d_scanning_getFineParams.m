function [threeD,tilt_angle,ori_inplane] = v4_3d_scanning_getFineParams(id)
    if ~exist('id','var'); id = 1; end
    switch(id)
        case 1;  threeD = 1; tilt_angle =   0; ori_inplane = 0;
        case 2;  threeD = 1; tilt_angle =   0; ori_inplane = 45;
        case 3;  threeD = 1; tilt_angle =   0; ori_inplane = 90;
        case 4;  threeD = 1; tilt_angle =   0; ori_inplane = 135;
        case 5;  threeD = 1; tilt_angle =   0; ori_inplane = 180;
        case 6;  threeD = 1; tilt_angle =   0; ori_inplane = 225;
        case 7;  threeD = 1; tilt_angle =   0; ori_inplane = 270;
        case 8;  threeD = 1; tilt_angle =   0; ori_inplane = 315;
            
        case 9;  threeD = 1; tilt_angle =  45; ori_inplane = 0;
        case 10; threeD = 1; tilt_angle =  45; ori_inplane = 45;
        case 11; threeD = 1; tilt_angle =  45; ori_inplane = 90;
        case 12; threeD = 1; tilt_angle =  45; ori_inplane = 135;
        case 13; threeD = 1; tilt_angle =  45; ori_inplane = 180;
        case 14; threeD = 1; tilt_angle =  45; ori_inplane = 225;
        case 15; threeD = 1; tilt_angle =  45; ori_inplane = 270;
        case 16; threeD = 1; tilt_angle =  45; ori_inplane = 315;
            
        case 17; threeD = 1; tilt_angle = -45; ori_inplane = 0;
        case 18; threeD = 1; tilt_angle = -45; ori_inplane = 45;
        case 19; threeD = 1; tilt_angle = -45; ori_inplane = 90;
        case 20; threeD = 1; tilt_angle = -45; ori_inplane = 135;
        case 21; threeD = 1; tilt_angle = -45; ori_inplane = 180;
        case 22; threeD = 1; tilt_angle = -45; ori_inplane = 225;
        case 23; threeD = 1; tilt_angle = -45; ori_inplane = 270;
        case 24; threeD = 1; tilt_angle = -45; ori_inplane = 315;
            
        case 25; threeD = 1; tilt_angle =  90; ori_inplane = 0;
        case 26; threeD = 1; tilt_angle =  90; ori_inplane = 45;
        case 27; threeD = 1; tilt_angle =  90; ori_inplane = 90;
        case 28; threeD = 1; tilt_angle =  90; ori_inplane = 135;

        case 29; threeD = 1; tilt_angle = -90; ori_inplane = 0;
        case 30; threeD = 1; tilt_angle = -90; ori_inplane = 45;
        case 31; threeD = 1; tilt_angle = -90; ori_inplane = 90;
        case 32; threeD = 1; tilt_angle = -90; ori_inplane = 135;

        case 33; threeD = 0; tilt_angle =   0; ori_inplane = 0;
        case 34; threeD = 0; tilt_angle =   0; ori_inplane = 45;
        case 35; threeD = 0; tilt_angle =   0; ori_inplane = 90;
        case 36; threeD = 0; tilt_angle =   0; ori_inplane = 135;
        case 37; threeD = 0; tilt_angle =   0; ori_inplane = 180;
        case 38; threeD = 0; tilt_angle =   0; ori_inplane = 225;
        case 39; threeD = 0; tilt_angle =   0; ori_inplane = 270;
        case 40; threeD = 0; tilt_angle =   0; ori_inplane = 315;
            
        case 41; threeD = 0; tilt_angle =  45; ori_inplane = 0;
        case 42; threeD = 0; tilt_angle =  45; ori_inplane = 45;
        case 43; threeD = 0; tilt_angle =  45; ori_inplane = 90;
        case 44; threeD = 0; tilt_angle =  45; ori_inplane = 135;
        case 45; threeD = 0; tilt_angle =  45; ori_inplane = 180;
        case 46; threeD = 0; tilt_angle =  45; ori_inplane = 225;
        case 47; threeD = 0; tilt_angle =  45; ori_inplane = 270;
        case 48; threeD = 0; tilt_angle =  45; ori_inplane = 315;
           
        case 49; threeD = 0; tilt_angle =  90; ori_inplane = 0;
        case 50; threeD = 0; tilt_angle =  90; ori_inplane = 45;
        case 51; threeD = 0; tilt_angle =  90; ori_inplane = 90;
        case 52; threeD = 0; tilt_angle =  90; ori_inplane = 135;  
        
        otherwise; threeD = 1; tilt_angle =  0; ori_inplane = 0;
    end
    if threeD
        printId=['3D: (' num2str(tilt_angle) ',' num2str(ori_inplane) ')'];
    else
        printId=['2D: (' num2str(tilt_angle) ',' num2str(ori_inplane) ')'];
    end
    disp(printId);
    
end

