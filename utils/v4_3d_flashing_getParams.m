function [imgnr,imgpath,imgbase] = v4_3d_flashing_getParams(imageId,imageNum,colorId,is3d)
    if imageNum<=90
        imageId_1=imageId(1); 
        imgnr=imageNum;
    elseif imageNum<=150
        imageId_1=imageId(2); 
        imgnr = imageNum-90;
    else
        imageId_1=imageId(3); 
        imgnr = imageNum-150;
    end
    
    if is3d
        tex = 'shade';
    else
        tex = 'twod';
    end
    
    imgpath = ['~images/flashingL/' num2str(imageId_1)];
    imgbase = [tex '_' num2str(colorId)];
end


