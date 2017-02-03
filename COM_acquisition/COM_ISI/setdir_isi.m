function setdir_isi

[Oflag,dd] = checkforOverwrite; %this is an imager function
if Oflag
    return
else
    mkdir(dd)
end
    