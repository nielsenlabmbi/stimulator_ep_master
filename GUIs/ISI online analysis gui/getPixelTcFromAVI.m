function success  = getPixelTcFromAVI%(maxBaselineFrames,maxPostFrames)
    global pixelTc imagingDetail exptDetail Analyzer
    
    aviPath = ['C:\ISIdata\' exptDetail.animal '\' exptDetail.animal '_' exptDetail.unit '_' exptDetail.expt ];
    analyzerPath = ['Z:\ISI\Analyzer\' exptDetail.animal '\' exptDetail.animal '_u' exptDetail.unit '_' exptDetail.expt '.analyzer'];
    
    if ~exist([aviPath '.mat'],'file')
        success = false;
        return;
    end
    load(analyzerPath,'-mat');
    
    for i = 1:length(Analyzer.P.param);
        Params.(eval(strcat('Analyzer.P.param{',num2str(i),'}{1}'))) = ...
            eval(strcat('Analyzer.P.param{',num2str(i),'}{3}'));
    end
    
    load([aviPath '_meta.mat']);
    
    v = VideoReader([fname,'.avi']);
    imagingDetail.imageSize = [v.Height v.Width];
    imagingDetail.tPerFrame = 1/v.FrameRate;
    imagingDetail.predelay = Params.predelay*v.FrameRate;
    imagingDetail.postdelay = Params.postdelay*v.FrameRate;
    imagingDetail.maxBaselineFrames = ceil(min(v.FrameRate,imagingDetail.predelay*v.FrameRate)); %default 1s predelay unless predelay is shorter than that
    imagingDetail.maxPostFrames = ceil(min(v.FrameRate,imagingDetail.postdelay*v.FrameRate));
    imagingDetail.stimFrames = floor(Params.stim_time*v.FrameRate);

    trialDetail = getTrialDetail(Analyzer);

    pixelTc = cell(1,trialDetail.nTrial);
    
    success = true;
    if length(meta) == length(trialDetail.trials)
        hWaitbar = waitbar(0,'Extracting pixel data from avi file. This may take a while...',...
                'CreateCancelBtn',...
                'setappdata(gcbf,''canceling'',1)');
        setappdata(hWaitbar,'canceling',0);

        count = 1;
        while hasFrame(v);
            data(:,:,count) = rgb2gray(readFrame(v));
            if getappdata(hWaitbar,'canceling'); success = false; break; end
            waitbar(count/(v.Duration*v.FrameRate));
            count = count+1;
        end
        delete(hWaitbar);
        
        for t=1:length(meta)
            if t == 1
                trial(t).data =  data(:,:,1:length(meta{t}.metadata));
            else
                trial(t).data = data(:,:,(length(meta{t-1}.metadata)+1):(length(meta{t-1}.metadata) + length(meta{t}.metadata)));
            end
            % assume trigger-frame-delay
            epochs = [0 imagingDetail.maxBaselineFrames imagingDetail.maxBaselineFrames + imagingDetail.stimFrames ...
               imagingDetail.maxBaselineFrames + imagingDetail.stimFrames + imagingDetail.maxPostFrames];
            % if no trigger-frame-delay
%             epochs = [imagingDetail.predelay - imagingDetail.maxBaselineFrames imagingDetail.predelay ...
%                 imagingDetail.predelay + imagingDetail.stimFrames imagingDetail.predelay + imagingDetail.stimFrames + imagingDetail.maxPostFrames];
                        
            baseline = trial(t).data(:,:,epochs(1)+1:epochs(2));
            stim = trial(t).data(:,:,epochs(2)+1:epochs(3));
            post = trial(t).data(:,:,epochs(3)+1:epochs(4));
            pixelTc{t} = double(cat(3,baseline,stim,post));
             
        end
    else
        disp('Something went wrong. TTL pulses don''t match up with nTrials.')
        success = false;
    end
    delete(v);
    
end