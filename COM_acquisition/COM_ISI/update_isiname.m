function update_isiname

global Mstate

sendtoImager(['U ' Mstate.unit]); %this is an imager function
sendtoImager(['E ' Mstate.expt]);
sendtoImager(['A ' Mstate.anim]);