function configAcqCom

global setupDefault

if strcmp(setupDefault.setupID,'2P') %2p
    open_sbserver    %2p acquisition
end
