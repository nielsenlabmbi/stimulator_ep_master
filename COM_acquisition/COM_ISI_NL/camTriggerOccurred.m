
function camTriggerOccurred(src, event)
    disp('Trigger detected, start acquisition');
    
    %configure the previewGUI
    global GUIhandles
    
    %acquisition flag
    axes(GUIhandles.ISI_NL.acqYN); set(GUIhandles.ISI_NL.acqYN,'XTick',[],'YTick',[]); axis tight;
    x = [0 1 1 0];
    y = [0 0 1 1];
    patch(x,y,'green','parent',GUIhandles.ISI_NL.acqYN);
    
    %black out the image
    axes(GUIhandles.ISI_NL.previewImg); set(GUIhandles.ISI_NL.previewImg,'XTick',[],'YTick',[]); axis tight;
    GUIhandles.ISI_NL.image = zeros(100);
    imshow(GUIhandles.ISI_NL.image);
    GUIhandles.ISI_NL.oImage = GUIhandles.ISI_NL.image;
    
    %make other buttons unavailable
    set(GUIhandles.ISI_NL.getPreview,'Enable','Off');
    set(GUIhandles.ISI_NL.stopPreview,'Enable','Off');
    
end