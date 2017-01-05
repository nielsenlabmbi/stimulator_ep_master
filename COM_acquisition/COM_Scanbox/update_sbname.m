function update_sbname

global Mstate

send_sbserver(sprintf('A%s',Mstate.anim));
send_sbserver(sprintf('U%s',Mstate.unit));
send_sbserver(sprintf('E%s',Mstate.expt));