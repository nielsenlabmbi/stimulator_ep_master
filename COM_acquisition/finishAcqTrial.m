function finishAcqTrial

global setupDefault

switch setupDefault.setupID

    case 'ISI' %intrinsic imaging (on same machine)
        runIsiAcq
    case 'ISI_NL'
        stopCamAcqTrial
end