function startIsiAcq

global analogIN

P = getParamStruct;

total_time = P.predelay+P.postdelay+P.stim_time;
sendtoImager(sprintf(['I %2.3f' 13],total_time))
        
%Make sure analog in is not running
stop(analogIN)
flushdata(analogIN)