function getISItuning(filterPx,fname,Analyzer)
%fname = 'test20170518pldapsExperiments.test.plainCamTest1927';
load([fname,'_meta.mat']);

% Extract frames
tic
v = VideoReader([fname,'.avi']);
count = 1;
while hasFrame(v);
    data(:,:,count) = rgb2gray(readFrame(v));
end
toc

noTrials = length(meta);
% Organize frames by trial 
for i = 1:noTrials
    if i == 1
        trial(i).data =  data(:,:,1:length(meta{i}.metadata));
    else
        trial(i).data = data(:,:,(length(meta{i-1}.metadata)+1):(length(meta{i-1}.metadata) + length(meta{i}.metadata)));
    end
end

% For each trial, get dF/F and trial resp
kernel = makeGaussianKernel([1 1],[filterPx filterPx],1); % gaussian kernel
% window = timeWindows.baselineFrames + timeWindows.respFrames(1) + 1 : ...
%             size(pixelTc{t},3) - timeWindows.postFrames + timeWindows.respFrames(2))
for i = 1:noTrials
    T = [meta{i}.metadata.TriggerIndex];
    trial(i).baseline = uint8(mean(trial(i).data(:,:,T == 1),4));
    window = T == 2; %at 2nd trigger
    trial(i).dFF = (trial(i).data - repmat(trial(i).baseline,1,1,length(meta{i}.metadata)))...
        ./(repmat(trial(i).baseline,1,1,length(meta{i}.metadata)));

        waitbar(i/noTrials,hWaitbar,['Trial number ' num2str(i)])
        
        trialResp(:,:,i) = mean(trial(i).dFF(:,:,window),3);
        
        trialResp(:,:,i) = smoothImage(trialResp(:,:,i),kernel,filterPx);
end
    delete(hWaitbar);
  
    %%%%%%%%%%%%% Support functions
    function smoothImgs = smoothImage(imgs,kernel,filterPx)
    smoothImgs = imgs;
    for ii=1:size(imgs,3)
        imgPadded = padarray(imgs(:,:,ii),[filterPx filterPx],'replicate');
        smoothImgs(:,:,ii) = filter2(kernel,imgPadded,'valid');
        % smoothImg = (smoothImg - min(smoothImg(:))) / (max(smoothImg(:)) - min(smoothImg(:)));
        % smoothImg = round(min(imgs(:)) + ((max(imgs(:))-1) * smoothImg));
    end


function gaussKernel = makeGaussianKernel(binWidths,sigma,nSigma)
    nDims = length(binWidths);
    
    kernelWidthInBins = round((nSigma.*sigma)./binWidths);

    inp = cell(1,nDims);
    for ii=1:nDims
        inp{ii} = binWidths(ii).*(-kernelWidthInBins(ii):1:kernelWidthInBins(ii));
    end

    outGrid = cell(1,nDims);
    [outGrid{:}] = ndgrid(inp{:});

    gaussKernel = ones(size(outGrid{1}));
    for ii=1:nDims
       gaussKernel =  gaussKernel.*exp(-1.*(outGrid{ii}.*outGrid{ii})./(2*sigma(ii)*sigma(ii)));
    end

    gaussKernel = gaussKernel./sum(gaussKernel(:));
    %%
%%%%%%%%%%%%%%%%%%%%% Get pixel tuning
% get events from the analyzer file

% if secondary value, limit to particular value, or average across values
% average per condition in primary value

%% Compute tuning
% Average over conditions
nrcond=length(Analyzer.loops.conds);

triallist=zeros(noTrials,1);
for i=1:nrcond
    nrrep=length(Analyzer.loops.conds{i}.repeats);
    for r=1:nrrep
        trep=Analyzer.loops.conds{i}.repeats{r}.trialno;
        triallist(trep)=i;
    end
end
    
% tuning curve
% restrict to cond2, or average (if cond2 exists)
%     ix = S.events(:,2)==100;
%     sig = Z(n).sig(ix);
%     events = S.events(ix,1);
% sort by cond1
        [sorted,b] = sort(triallist);
        sig = sig(b);
        M = reshape(sig,nrreps,nrcond);
% average
    M_avg = mean(M,1);
% standard error s/sqrt(n)
    M_stde = std(M,0,1)/reps;
   
