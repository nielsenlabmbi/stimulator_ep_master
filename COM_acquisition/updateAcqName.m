function updateAcqName

global setupDefault

if strcmp(setupDefault.setupID,'2P')
    update_sbname   %Send expt info to 2P server
end