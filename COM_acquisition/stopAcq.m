function stopAcq

global setupDefault


if ~isempty(strfind(setupDefault.setupID,'2P'))
    send_sbserver('S'); %stop microscope
end

if ~isempty(strfind(setupDefault.setupID,'EP')) 
    stopIntanAcq;
end

if ~isempty(strfind(setupDefault.setupID,'ISI')) 
    
end

