function [threeD,tilt_angle,ori] = v4_3d_scanning_getCoarseParams(id)
    if ~exist('id','var'); id = 1; end
    switch(id)
        case 1;  threeD = 1; tilt_angle =   0; ori = 0;
        case 2;  threeD = 1; tilt_angle =   0; ori = 90;
        case 3;  threeD = 1; tilt_angle =   0; ori = 180;
        case 4;  threeD = 1; tilt_angle =   0; ori = 270;
            
        case 5;  threeD = 1; tilt_angle =  90; ori = 0;
        case 6;  threeD = 1; tilt_angle =  90; ori = 90;
        
        case 7;  threeD = 1; tilt_angle = -90; ori = 0;
        case 8;  threeD = 1; tilt_angle = -90; ori = 90;
            
        case 9;  threeD = 0; tilt_angle =   0; ori = 0;
        case 10; threeD = 0; tilt_angle =   0; ori = 90;
        case 11; threeD = 0; tilt_angle =   0; ori = 180;
        case 12; threeD = 0; tilt_angle =   0; ori = 270;
        
        case 13; threeD = 0; tilt_angle =  90; ori = 0;
        case 14; threeD = 0; tilt_angle =  90; ori = 90;
            
        otherwise; threeD = 1; tilt_angle =  0; ori = 0;
    end
end

