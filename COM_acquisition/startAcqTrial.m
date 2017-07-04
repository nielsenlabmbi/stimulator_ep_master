function startAcqTrial

global setupDefault

switch setupDefault.setupID

    case 'ISI' %intrinsic imaging (on same machine)
        startSyncAcq
    case 'ISI_NL'
end