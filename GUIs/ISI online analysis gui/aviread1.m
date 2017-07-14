function x = aviread(fname,k,N,varargin)

% img = aviread(fname,k,N,varargin)
%
% Reads from frame k to k+N-1 in file fname
% 
% fname - the file name (e.g., 'xx0_000_001')
% k     - the index of the first frame to be read.  The first index is 0.
% N     - the number of consecutive frames to read starting with k.
%
% If N>1 it returns a 4D array of size = [#pmt rows cols N] 
% If N=1 it returns a 3D array of size = [#pmt rows cols]
%
% #pmts is the number of pmt channels being sampled (1 or 2)
% rows is the number of lines in the image
% cols is the number of pixels in each line
%
%
% The function also creates a global 'info' variable with additional
% information about the file

global info_loaded info

% check if already loaded...

if(isempty(info_loaded) || ~strcmp(fname,info_loaded))
    
    if(~isempty(info_loaded))   % try closing previous...
        try
            fclose(info.fid);
        catch
        end
    end

    load(fname);
    
    info_loaded = fname;
    
    if(~isfield(info,'sz'))
        info.sz = [304 484];    % it was only sz = .... 
    end
     
    info.fid = fopen([fname '.avi']);
    d = dir([fname '.avi']);
    info.nsamples = info.sz(2)*info.sz(1)*2;   % bytes per record 
    
   info.max_idx =  d.bytes/info.sz(1)/info.sz(2)/2 - 1;
end

if(isfield(info,'fid') && info.fid ~= -1)
    
    % nsamples = info.postTriggerSamples * info.recordsPerBuffer;
        
    try
        fseek(info.fid,k*info.nsamples,'bof');
        x = fread(info.fid,info.nsamples/2 * N,'uint16=>uint16');
        x = reshape(x,[1 info.sz(2) info.sz(1)  N]);
    catch
        error('Cannot read frame.  Index range likely outside of bounds.');
    end

    x = intmax('uint16')-permute(x,[1 3 2 4]);
    
else
    x = [];
end