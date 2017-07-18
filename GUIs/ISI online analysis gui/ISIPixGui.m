% =========================================================================
% =========================== CORE CALLBACKS ==============================
% =========================================================================

function varargout = ISIPixGui(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @ISIPixGui_OpeningFcn, ...
                       'gui_OutputFcn',  @ISIPixGui_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end

function ISIPixGui_OpeningFcn(hObject, ~, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to ISIPixGui (see VARARGIN)

    global Analyzer exptDetail imagingDetail;

    % Choose default command line output for ISIPixGui
    handles.output = hObject;
    
    % preset some important flags
    handles.clickToMagnify = false;
    handles.pixelmode = true;
    handles.plotDetail.showAnatomy = true;
    
    % messages counter and list
    handles.messages.messageList = {};
    handles.messages.count = 0;
    
    % have the details in handles for easy access
    % note: pixelTc is still global
    handles.analyzer = Analyzer;
    handles.exptDetail = exptDetail;
    handles.imagingDetail = imagingDetail;
    
    % get all details of stimuli and blanks
    if ~isempty(handles.analyzer)
        handles.trialDetail = getTrialDetail(handles.analyzer);
        handles.dataLoaded = true;
        handles.messages = addMessage(handles.messages,'Data loaded.');
        handles.messages = addMessage(handles.messages,['Total trials: ' num2str(handles.trialDetail.nTrial)]);
        handles.messages = addMessage(handles.messages,['Repeats: ' num2str(handles.trialDetail.nRepeat)]);
        handles.messages = addMessage(handles.messages,['Blanks: ' num2str(handles.trialDetail.nRepeatBlank)]);
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
    else
        handles.trialDetail = [];
        handles.trialDetail.isMultipleDomain = 0;
        handles.trialDetail.domains{1} = '';
        handles.dataLoaded = false;
        handles.messages = addMessage(handles.messages,'Data not loaded.');
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
    end
    
    % gui changes -> button icons
    % anatomy axis buttons
    pixIcon = imread('avgPixIcon_pix.png'); handles.pixIcon = imresize(pixIcon, [40 40]);
    ctmIcon = imread('avgPixIcon_ctm.png'); handles.ctmIcon = imresize(ctmIcon, [40 40]);
    
    pixIcon_on = imread('avgPixIcon_pix_on.png'); handles.pixIcon_on = imresize(pixIcon_on, [40 40]);
    ctmIcon_on = imread('avgPixIcon_ctm_on.png'); handles.ctmIcon_on = imresize(ctmIcon_on, [40 40]);
    
    set(handles.tbutton_pixelSelect,'CData',handles.pixIcon_on);
    set(handles.tbutton_clickToMagnify,'CData',handles.ctmIcon);
    
    twIcon  = imread('avgPixIcon_tw.png');  handles.twIcon  = imresize(twIcon, [40 40]);
    set(handles.button_adjustTimeWindows,'CData',handles.twIcon);
    
    handles.clickToMagnifyData = [4,0.08];
    handles.buttonDownOnAxis = false;
    
    handles.plotDetail.filterPx = 4;
    set(handles.slider_filterPx,'value',handles.plotDetail.filterPx);
    
    % gui changes -> analyzer manipulation
    set(handles.pulldown_param1,'String',handles.trialDetail.domains);
    set(handles.pulldown_param1,'Value',1);
    set(handles.textbox_moduloValue,'String','180','Enable','off');
    if strcmp(handles.trialDetail.domains{1},'ori')
        set(handles.checkbox_circular,'Value',1);
        handles.plotDetail.param1_circular = true;
    else
        set(handles.checkbox_circular,'Value',0);
        handles.plotDetail.param1_circular = false;
    end  
    
    handles.plotDetail.param1name = handles.trialDetail.domains{1};
    handles.plotDetail.param1_modulo = false;
    handles.plotDetail.param1_moduloVal = 180;
    
    if handles.trialDetail.isMultipleDomain
        set(handles.pulldown_param2,'String',handles.trialDetail.domains);
        set(handles.pulldown_param2,'Value',2);
        set(handles.pulldown_param2Value,'String',unique(handles.trialDetail.domval(:,2)),'value',1);
        
        set(handles.radiobutton_mean,'Value',1);
        set(handles.radiobutton_all,'Value',0);
        set(handles.radiobutton_value,'Value',0);
        
        handles.plotDetail.param2name = handles.trialDetail.domains{2};
        handles.plotDetail.param2val = handles.trialDetail.domval(1,2);
        handles.plotDetail.param2mode = 'mean';
        
        set(handles.pulldown_param2Value,'enable','off');
        
        handles.messages = addMessage(handles.messages,['Multiple variables: ' handles.trialDetail.domains{1} ', ' handles.trialDetail.domains{2} '.']);
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
    else
        set(handles.pulldown_param2,'enable','off');
        set(handles.pulldown_param2Value,'enable','off');
        set(handles.radiobutton_mean,'enable','off');
        set(handles.radiobutton_all,'enable','off');
        set(handles.radiobutton_value,'enable','off');
        
        handles.plotDetail.param2name = [];
        handles.plotDetail.param2val = [];
        handles.plotDetail.param2mode = [];
        if ~isempty(handles.trialDetail.domains{1})
            handles.messages = addMessage(handles.messages,['Single variable: ' handles.trialDetail.domains{1} '.']);
            set(handles.listbox_messages,'String',handles.messages.messageList);
            set(handles.listbox_messages,'Value',handles.messages.count);
        end
    end
    
    % get time windows depending upon how many frames were collected
    if ~isempty(handles.imagingDetail)
        handles.timeWindows = getTimeWindows(handles.imagingDetail);
        
        handles.messages = addMessage(handles.messages,['Baseline time (ms): ' num2str(round(handles.timeWindows.baselineRange(1))) ' to ' num2str(round(handles.timeWindows.baselineRange(2)))]);
        handles.messages = addMessage(handles.messages,['Response time (ms): ' num2str(round(handles.timeWindows.respRange(1))) ' to ' num2str(round(handles.timeWindows.respRange(2)))]);
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
    else
        handles.timeWindows = [];
        handles.imagingDetail.imageSize = [512 796]; 
        % hack so gui doesn't throw error when loaded without any data
    end
    
    % get tuning for all pixels
    if ~isempty(handles.timeWindows)
        handles.messages = addMessage(handles.messages,'Calculating pixel tuning.');
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
        
        [handles.pixelTuning,handles.trialResp] = getPixelTuning...
            (handles.trialDetail,handles.timeWindows,...
            handles.plotDetail.filterPx,handles.imagingDetail.imageSize);
    else
        handles.pixelTuning = []; handles.trialResp = [];
    end
    
    % get mean image
    if ~isempty(handles.pixelTuning)
        % refresh the functional image
        [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
        handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
        handles.plotDetail.anatomy = getAnatomy;
        
        % refresh the anatomy image
        cla(handles.axis_anatomy);
        if handles.plotDetail.showAnatomy        
            imagesc(handles.plotDetail.anatomy,'parent',handles.axis_anatomy);
            colormap(handles.axis_anatomy,'gray')
        end
    else
        handles.plotDetail.param1val = [];
        handles.plotDetail.anatomy = [];
    end
    
    set(handles.axis_image,'xtick',[],'ytick',[]);
    box(handles.axis_image,'on');
    
    set(handles.axis_anatomy,'xtick',[],'ytick',[]);
    box(handles.axis_anatomy,'on')
    
    if ~handles.dataLoaded
        msgbox('No global data was found. Use the ''Open file...'' button to load data.','No data found','warn');
    end
    
    % Update handles structure
    guidata(hObject, handles);

function varargout = ISIPixGui_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;    

% =========================================================================
% ========================= CORE CALLBACKS DONE ===========================
% =========================================================================

% =========================================================================
% ========================== TOOLBAR CALLBACKS ============================
% =========================================================================

% TODO: handle zoom in and out from toolbar
function uitoggletool_zoomIn_ClickedCallback(hObject, ~, handles)

% TODO: handle zoom in and out from toolbar
function uitoggletool_zoomOut_ClickedCallback(hObject, ~, handles)

function uipushtool_open_ClickedCallback(hObject, ~, handles)
    global exptDetail
    load('currentExpt.mat')
    
    % in case of sbx load
    prompt = {'Animal:','Unit:','Experiment:'};
    dlg_title = 'Input';
    num_lines = 1;
    defaultans = {exptDetail.animal,exptDetail.unit,exptDetail.expt};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    if isempty(answer); return; end
    
    handles.messages = addMessage(handles.messages,['Loading data for ' answer{1} '_' answer{2} '_' answer{3}]);
    set(handles.listbox_messages,'String',handles.messages.messageList);
    set(handles.listbox_messages,'Value',handles.messages.count);
    
    exptDetail.animal = answer{1};
    exptDetail.unit = answer{2};
    exptDetail.expt = answer{3};
    
    fileLoc = which('currentExpt.mat');
    save(fileLoc,'exptDetail');
    
    handles = loadDataAndRefreshGui(handles);   
    guidata(hObject, handles);
    
function uipushtool_save_ClickedCallback(hObject, ~, handles)
    global pixelTc;
    if ~handles.dataLoaded
        msgbox('No data loaded.','Nothing to save','error');
        handles.messages = addMessage(handles.messages,'Cannot save data. No data loaded.');
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
    else
        savePathC = ['C:\ISIdata\' handles.exptDetail.animal '\' ...
            handles.exptDetail.animal '_' handles.exptDetail.unit '_' ...
            handles.exptDetail.expt '_pixelData.mat'];
        savePathZ = ['Z:\ISI\Ferret ISI\Ferret ISI data\' handles.exptDetail.animal '\' ...
            handles.exptDetail.animal '_' handles.exptDetail.unit '_' ...
            handles.exptDetail.expt '_pixelData.mat'];
        
        choice = questdlg(['Do you want to save pixel timecourse data?'...
            '(Warning: This will take minutes.'...
            'Click ''No'' to only save pixel tuning data.)'], ...
            'Save data', ...
            'Yes','No','No');
        if strcmp(choice,'Yes')
            saveData.pixelTc = pixelTc;
        end
        saveData.pixelTuning = handles.pixelTuning;
        saveData.trialResp = handles.trialResp;
        saveData.analyzer = handles.analyzer;
        saveData.trialDetail = handles.trialDetail;
        saveData.plotDetail = handles.plotDetail;
        saveData.exptDetail = handles.exptDetail;
        saveData.imagingDetail = handles.imagingDetail;
        saveData.timeWindows = handles.timeWindows;
        saveData.clickToMagnifyData = handles.clickToMagnifyData; %#ok<STRNU>
        
        if ~exist(['C:\ISIdata\' handles.exptDetail.animal],'dir'); mkdir(['C:\ISIdata\' handles.exptDetail.animal]); end
        if ~exist(['Z:\ISI\Ferret ISI\Ferret ISI data\' handles.exptDetail.animal],'dir'); mkdir(['Z:\ISI\Ferret ISI\Ferret ISI data\' handles.exptDetail.animal]); end
        h = msgbox('Saving data...','Save Data','none');
        save(savePathC,'saveData','-v7.3');
        save(savePathZ,'saveData','-v7.3');
        delete(h);
        msgbox('Data saved.','Save Data','none');
        handles.messages = addMessage(handles.messages,['Data saved (in c:\ and z:\) for ' handles.exptDetail.animal '_' handles.exptDetail.unit '_' handles.exptDetail.expt]);
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
    end
    guidata(hObject, handles);

% =========================================================================
% ======================= TOOLBAR CALLBACKS DONE ==========================
% =========================================================================

% =========================================================================
% ======================== ANALYZER MANIPULATION ==========================
% =========================================================================

function pulldown_param1_Callback(hObject, ~, handles)
    contents = cellstr(get(hObject,'String'));
    handles.plotDetail.param1name = contents{get(hObject,'Value')};
    guidata(hObject, handles);
    
function pulldown_param2_Callback(hObject, ~, handles)
    contents = cellstr(get(hObject,'String'));
    handles.plotDetail.param2name = contents{get(hObject,'Value')};
    handles.plotDetail.param2val = handles.trialDetail.domval(1,get(hObject,'Value'));
    set(handles.pulldown_param2Value,'String',unique(handles.trialDetail.domval(:,get(hObject,'Value'))),'value',1);
    guidata(hObject, handles);
    
function checkbox_circular_Callback(hObject, ~, handles)
    handles.plotDetail.param1_circular = get(hObject,'Value');
    
    % get mean image
    if ~isempty(handles.pixelTuning)
        [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
        handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
        enableMaskMode(handles);
    end
    guidata(hObject, handles);
    
function checkbox_modulo_Callback(hObject, ~, handles)
    handles.plotDetail.param1_modulo = get(hObject,'Value');
    if get(hObject,'Value')
        set(handles.textbox_moduloValue,'enable','on');
    else
        set(handles.textbox_moduloValue,'enable','off');
    end
    
    % get mean image
    if ~isempty(handles.pixelTuning)
        [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
        handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
        enableMaskMode(handles);
    end
    guidata(hObject, handles);

function textbox_moduloValue_Callback(hObject, ~, handles)
    handles.plotDetail.param1_moduloVal = str2double(get(hObject,'String'));
    
    % get mean image
    if ~isempty(handles.pixelTuning)
        [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
        handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
        enableMaskMode(handles);
    end
    guidata(hObject, handles);

function radiobutton_mean_Callback(hObject, ~, handles)
    if get(hObject,'Value')
        handles.plotDetail.param2mode = 'mean';
        set(handles.pulldown_param2Value,'enable','off');
    end
    
    % get mean image
    if ~isempty(handles.pixelTuning)
        [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
        handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
        enableMaskMode(handles);
    end
    guidata(hObject, handles);
    
function radiobutton_all_Callback(hObject, ~, handles)
    if get(hObject,'Value')
        handles.plotDetail.param2mode = 'all';
        set(handles.pulldown_param2Value,'enable','off');
    end
    
    % get mean image
    if ~isempty(handles.pixelTuning)
        [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
        handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
        enableMaskMode(handles);
    end
    guidata(hObject, handles);
    
function radiobutton_value_Callback(hObject, ~, handles)
    if get(hObject,'Value')
        handles.plotDetail.param2mode = 'value';
        handles.plotDetail.param2val = handles.trialDetail.domval(1,2);
        set(handles.pulldown_param2Value,'enable','on');
    else
        set(handles.pulldown_param2Value,'enable','off');
    end
    % get mean image
    if ~isempty(handles.pixelTuning)
        [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
        handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
        enableMaskMode(handles);
    end
    guidata(hObject, handles);

function pulldown_param2Value_Callback(hObject, ~, handles)
    contents = cellstr(get(hObject,'String'));
    handles.plotDetail.param2val = str2double(contents{get(hObject,'Value')});
    
    % get mean image
    if ~isempty(handles.pixelTuning)
        [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
        handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
        enableMaskMode(handles);
    end
    guidata(hObject, handles);
    
% =========================================================================
% ===================== ANALYZER MANIPULATION DONE ========================
% =========================================================================

% =========================================================================
% ======================== ANATOMY AXIS BUTTONS ===========================
% =========================================================================


function tbutton_clickToMagnify_Callback(hObject, ~, handles)
    handles.clickToMagnify = ~handles.clickToMagnify;
    if handles.clickToMagnify
        handles.pixelmode = false;
        set(handles.tbutton_pixelSelect,'CData',handles.pixIcon);
        set(handles.tbutton_clickToMagnify,'CData',handles.ctmIcon_on);
    end
    guidata(hObject, handles);

function tbutton_pixelSelect_Callback(hObject, ~, handles)
    handles.pixelmode = ~handles.pixelmode;
    if handles.pixelmode
        handles.clickToMagnify = false;
        set(handles.tbutton_pixelSelect,'CData',handles.pixIcon_on);
        set(handles.tbutton_clickToMagnify,'CData',handles.ctmIcon);
    end
    guidata(hObject, handles);

function button_adjustTimeWindows_Callback(hObject, ~, handles)
    if handles.dataLoaded
        prompt = {'Baseline duration (in ms):','Post-stimulus duration (in ms):','Response start after stimulus onset (in ms):','Response stop after stimulus offset (in ms):'};
        dlg_title = 'Input';
        num_lines = 1;
        defaultans = {num2str(handles.imagingDetail.maxBaselineFrames*handles.imagingDetail.tPerFrame*1000),...
            num2str(handles.imagingDetail.maxPostFrames*handles.imagingDetail.tPerFrame*1000),...
            num2str(handles.timeWindows.respFrames(1)*handles.imagingDetail.tPerFrame*1000),...
            num2str(handles.timeWindows.respFrames(2)*handles.imagingDetail.tPerFrame*1000)};
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
        if isempty(answer); return; end

        maxBaselineFrames = round(str2double(answer{1})/(handles.imagingDetail.tPerFrame*1000));
        maxPostFrames = round(str2double(answer{2})/(handles.imagingDetail.tPerFrame*1000));
        respFrames = [round(str2double(answer{3})/(handles.imagingDetail.tPerFrame*1000))...
                      round(str2double(answer{4})/(handles.imagingDetail.tPerFrame*1000))];
        
      % nothing changed
        if maxBaselineFrames == handles.imagingDetail.maxBaselineFrames && ...
           maxPostFrames == handles.imagingDetail.maxPostFrames && ...
           isequal(respFrames,handles.timeWindows.respFrames)
            return;
        end
        
        if respFrames(2) > maxPostFrames
            msgbox('The number of response frames exceed the maximum requested frames. Please try again.','Frame count inconsistant','error');
            return;
        end
        
        if respFrames(2) > handles.imagingDetail.maxPostFrames || ...
            maxBaselineFrames ~= handles.imagingDetail.maxBaselineFrames || ...
            maxPostFrames ~= handles.imagingDetail.maxPostFrames
            handles = loadDataAndRefreshGui(handles,maxBaselineFrames,maxPostFrames,respFrames);
        else
            handles = updateTimeWindowsAndReplot(handles,respFrames);
        end
    else
        msgbox('Load data before adjusting time windows.','Data not loaded','error');
    end
    guidata(hObject, handles);

function slider_filterPx_Callback(hObject, ~, handles)
    handles.plotDetail.filterPx = round(get(hObject,'Value'));
    set(handles.slider_filterPx,'value',handles.plotDetail.filterPx);
    
    % get tuning for all pixels
    if ~isempty(handles.timeWindows)
        handles.messages = addMessage(handles.messages,'Calculating pixel tuning.');
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
        
        [handles.pixelTuning,handles.trialResp] = getPixelTuning...
            (handles.trialDetail,handles.timeWindows,...
            handles.plotDetail.filterPx,handles.imagingDetail.imageSize);
    else
        handles.pixelTuning = []; handles.trialResp = [];
    end
    
    % get mean image
    if ~isempty(handles.pixelTuning)
        [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
        handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
        handles.plotDetail.anatomy = getAnatomy;
    else
        handles.plotDetail.param1val = [];
        handles.plotDetail.anatomy = [];
    end
    
    set(handles.axis_image,'xtick',[],'ytick',[]);
    box(handles.axis_image,'on');
    
    guidata(hObject, handles);
    
% =========================================================================
% ====================== ANATOMY AXIS BUTTONS DONE ========================
% =========================================================================    
    

% =========================================================================
% ========================== PIXEL CLICKED ================================
% =========================================================================

function figure1_WindowButtonDownFcn(hObject, ~, handles)
    showAnatomyCrosshair = false;
    showFuncCrosshair = false;
    
    mouseLoc_func = get(handles.axis_image,'currentpoint');
    mouseLoc_func = fliplr(ceil(mouseLoc_func(1,1:2)));
    mouseLoc_anat = get(handles.axis_anatomy,'currentpoint');
    mouseLoc_anat = fliplr(ceil(mouseLoc_anat(1,1:2)));
    
    % check if click was on hFunc
    if mouseLoc_func(1) < handles.imagingDetail.imageSize(1) && ...
       mouseLoc_func(2) < handles.imagingDetail.imageSize(2) && ...
       mouseLoc_func(1) > 0 && ...
       mouseLoc_func(2) > 0
        handles.buttonDownOnAxis = true;
        handles.selectedPixel = mouseLoc_func;
        handleClickedOn = handles.axis_image;
        showAnatomyCrosshair = true;
    % check if click was on hAnat
    elseif mouseLoc_anat(1) < handles.imagingDetail.imageSize(1) && ...
           mouseLoc_anat(2) < handles.imagingDetail.imageSize(2) && ...
           mouseLoc_anat(1) > 0 && ...
           mouseLoc_anat(2) > 0
        handles.buttonDownOnAxis = true;
        handles.selectedPixel = mouseLoc_anat;
        handleClickedOn = handles.axis_anatomy;
        showFuncCrosshair = true;
    else
        handles.buttonDownOnAxis = false;
%         handles.selectedPixel = [];
        handleClickedOn = [];
    end
    
    % handle magnify
    if handles.clickToMagnify && handles.buttonDownOnAxis
        f1 = hObject;
        a1 = handleClickedOn;
        a2 = copyobj(a1,f1);

        set(f1,'UserData',[f1,a1,a2],'CurrentAxes',a2);
        set(a2,'Color',get(a1,'Color'),'xtick',[],'ytick',[],'Box','on');
        xlabel(''); ylabel(''); zlabel(''); title('');
        set(a1,'Color',get(a1,'Color')*0.95);
        figure1_WindowButtonMotionFcn(hObject,[],handles);

    % handle pixel tuning selection
    elseif handles.pixelmode && ~isempty(handles.trialResp) && handles.buttonDownOnAxis
        plotTuning(handles.selectedPixel,handles.trialResp,handles.plotDetail,...
            handles.trialDetail,handles.imagingDetail,handles.timeWindows,...
            handles.axis_tc,handles.axis_tuning);
        if showAnatomyCrosshair
            if isfield(handles,'anatomyPointHandle') && ~isempty(handles.anatomyPointHandle) 
                delete(handles.anatomyPointHandle);
            end
            hold(handles.axis_anatomy,'on');
            hPoint = plot(handles.axis_anatomy,handles.selectedPixel(2),handles.selectedPixel(1),'r+','markersize',20);
            hold(handles.axis_anatomy,'off');
            handles.anatomyPointHandle = hPoint;
        elseif showFuncCrosshair
            if isfield(handles,'funcPointHandle') && ~isempty(handles.funcPointHandle) 
                delete(handles.funcPointHandle);
            end
            hold(handles.axis_image,'on');
            hPoint = plot(handles.axis_image,handles.selectedPixel(2),handles.selectedPixel(1),'r+','markersize',20);
            hold(handles.axis_image,'off');
            handles.funcPointHandle = hPoint;
        end
    end
    
    % tuning axis clicks
    mouseLoc_tuning = get(handles.axis_tuning,'currentpoint');
    if handles.dataLoaded
        if isfield(handles.plotDetail,'param1val') && ...
            mouseLoc_tuning(1,1) < max(handles.plotDetail.param1val) && ...
            mouseLoc_tuning(1,1) > min(handles.plotDetail.param1val) && ...
            mouseLoc_tuning(1,2) < max(get(handles.axis_tuning,'ylim')) && ...
            mouseLoc_tuning(1,2) > min(get(handles.axis_tuning,'ylim'))
            [~,selectedCondInd] = min(abs(handles.plotDetail.param1val - mouseLoc_tuning(1)));
            if handles.pixelmode
                plotTimecoursePerCondition(handles.selectedPixel,selectedCondInd,handles.plotDetail,handles.trialDetail,handles.imagingDetail,handles.timeWindows,handles.axis_tc);
                
                handles.messages = addMessage(handles.messages,['Timecourse for ' handles.plotDetail.param1name ' = ' num2str(handles.trialDetail.domval(selectedCondInd)) '.']);
                set(handles.listbox_messages,'String',handles.messages.messageList);
                set(handles.listbox_messages,'Value',handles.messages.count);
            end
        end
    end
    guidata(hObject, handles);

function figure1_WindowButtonMotionFcn(hObject, ~, handles)
    if handles.buttonDownOnAxis
        showAnatomyCrosshair = false;
        showFuncCrosshair = false;
        mouseLoc_func = get(handles.axis_image,'currentpoint');
        mouseLoc_func = fliplr(ceil(mouseLoc_func(1,1:2)));  
        mouseLoc_anat = get(handles.axis_anatomy,'currentpoint');
        mouseLoc_anat = fliplr(ceil(mouseLoc_anat(1,1:2)));

        % check if click was on hFunc
        if mouseLoc_func(1) < handles.imagingDetail.imageSize(1) && ...
           mouseLoc_func(2) < handles.imagingDetail.imageSize(2) && ...
           mouseLoc_func(1) > 0 && ...
           mouseLoc_func(2) > 0
            handles.selectedPixel = mouseLoc_func;
            showAnatomyCrosshair = true;
            
        % check if click was on hAnat
        elseif mouseLoc_anat(1) < handles.imagingDetail.imageSize(1) && ...
               mouseLoc_anat(2) < handles.imagingDetail.imageSize(2) && ...
               mouseLoc_anat(1) > 0 && ...
               mouseLoc_anat(2) > 0

            handles.selectedPixel = mouseLoc_anat;
            showFuncCrosshair = true;
        end

        if handles.clickToMagnify && handles.buttonDownOnAxis
            H = get(hObject,'UserData');
            if ~isempty(H)
                f1 = H(1); a1 = H(2); a2 = H(3);
                a2_param = handles.clickToMagnifyData;
                f_pos = get(f1,'Position');
                a1_pos = get(a1,'Position');

                [f_cp, a1_cp] = pointer2d(f1,a1);

                set(a2,'Position',[(f_cp./f_pos(3:4)) 0 0] + a2_param(2)*a1_pos(3)*[-1 -1 2 2]);
                a2_pos = get(a2,'Position');

                set(a2,'XLim',a1_cp(1)+(1/a2_param(1))*(a2_pos(3)/a1_pos(3))*diff(get(a1,'XLim'))*[-0.5 0.5]);
                set(a2,'YLim',a1_cp(2)+(1/a2_param(1))*(a2_pos(4)/a1_pos(4))*diff(get(a1,'YLim'))*[-0.5 0.5]);
            end
        elseif handles.pixelmode && handles.buttonDownOnAxis && ~isempty(handles.trialResp)
            plotTuning(handles.selectedPixel,handles.trialResp,handles.plotDetail,...
                handles.trialDetail,handles.imagingDetail,handles.timeWindows,...
                handles.axis_tc,handles.axis_tuning)
            if showAnatomyCrosshair
                if isfield(handles,'anatomyPointHandle') && ~isempty(handles.anatomyPointHandle) 
                    delete(handles.anatomyPointHandle);
                end
                hold(handles.axis_anatomy,'on');
                hPoint = plot(handles.axis_anatomy,mouseLoc_func(2),mouseLoc_func(1),'r+','markersize',20);
                hold(handles.axis_anatomy,'off');
                handles.anatomyPointHandle = hPoint;
            elseif showFuncCrosshair
                if isfield(handles,'funcPointHandle') && ~isempty(handles.funcPointHandle) 
                    delete(handles.funcPointHandle);
                end
                hold(handles.axis_image,'on');
                hPoint = plot(handles.axis_image,handles.selectedPixel(2),handles.selectedPixel(1),'r+','markersize',20);
                hold(handles.axis_image,'off');
                handles.funcPointHandle = hPoint;
            end
        end

        guidata(hObject, handles);
    end

function figure1_WindowButtonUpFcn(hObject, ~, handles)
    if handles.buttonDownOnAxis
        handles.buttonDownOnAxis = false;
        if handles.clickToMagnify
            handles.buttonDownOnAxis = false;
            H = get(hObject,'UserData');
            f1 = H(1); a1 = H(2); a2 = H(3);
            set(a1,'Color',get(a2,'Color'));
            set(f1,'UserData',[],'Pointer','arrow','CurrentAxes',a1);
            if ~strcmp(get(f1,'SelectionType'),'alt'),
              delete(a2);
            end
        end
        if isfield(handles,'anatomyPointHandle') && ~isempty(handles.anatomyPointHandle) 
            delete(handles.anatomyPointHandle);
        end
        if isfield(handles,'funcPointHandle') && ~isempty(handles.funcPointHandle) 
            delete(handles.funcPointHandle);
        end
        guidata(hObject, handles);
    end

% =========================================================================
% ========================== PIXEL CLICKED DONE ===========================
% =========================================================================

% =========================================================================
% ============================== CREATEFNs ================================
% =========================================================================

function pulldown_param1_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
function pulldown_param2_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
function pulldown_param2Value_CreateFcn(hObject, ~, ~) %#ok<*DEFNU>
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
function textbox_moduloValue_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
function slider_filterPx_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
function listbox_messages_Callback(~,~,~)
    
function listbox_messages_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
% =========================================================================
% ========================= CREATEFNs DONE ================================
% =========================================================================

% =========================================================================
% ====================== CLICK TO MAGNIFY HELPERS =========================
% =========================================================================    
    
function figure1_KeyPressFcn(hObject, ~, handles)
    if handles.clickToMagnify
        H = get(hObject,'UserData');
        if ~isempty(H)
            f1 = H(1); a2 = H(3);
            if (strcmp(get(f1,'CurrentCharacter'),'+') || strcmp(get(f1,'CurrentCharacter'),'='))
                handles.clickToMagnifyData(1) = handles.clickToMagnifyData(1)*1.2;
            elseif (strcmp(get(f1,'CurrentCharacter'),'-') || strcmp(get(f1,'CurrentCharacter'),'_'))
                handles.clickToMagnifyData(1) = handles.clickToMagnifyData(1)/1.2;
            elseif (strcmp(get(f1,'CurrentCharacter'),'<') || strcmp(get(f1,'CurrentCharacter'),','))
                handles.clickToMagnifyData(2) = handles.clickToMagnifyData(2)/1.2;
            elseif (strcmp(get(f1,'CurrentCharacter'),'>') || strcmp(get(f1,'CurrentCharacter'),'.'))
                handles.clickToMagnifyData(2) = handles.clickToMagnifyData(2)*1.2;
            end;
            set(a2,'UserData',handles.clickToMagnifyData);
            figure1_WindowButtonMotionFcn(hObject,[],handles);
        end
    end
    guidata(hObject, handles);

function [pointerFig, pointerAxis] = pointer2d(hFig,hAxis)
    set(hFig,'Units','pixels');
    set(hAxis,'Units','normalized');

    pointer_pos = get(0,'PointerLocation');	%pixels {0,0} lower left
    fig_pos = get(hFig,'Position');	%pixels {l,b,w,h}

    pointerFig = pointer_pos - fig_pos([1,2]);
    set(hFig,'CurrentPoint',pointerFig);

    if isempty(hAxis)
        pointerAxis = [];
    elseif nargout == 2
        axes_pointer_line = get(hAxis,'CurrentPoint');
        pointerAxis = sum(axes_pointer_line)/2;
    end
    
% =========================================================================
% ==================== CLICK TO MAGNIFY HELPERS DONE ======================
% =========================================================================

% =========================================================================
% ========================== HELPER FUNCTIONS =============================
% =========================================================================

function handles = loadDataAndRefreshGui(handles,maxBaselineFrames,maxPostFrames,respFrames)
    global pixelTc imagingDetail exptDetail

    if ~exist('maxBaselineFrames','var');   maxBaselineFrames = 10; end
    if ~exist('maxPostFrames','var');       maxPostFrames = 20;     end
    if ~exist('respFrames','var');          respFrames = [1 8];     end

    if ~getPixelTcFromAVI(maxBaselineFrames,maxPostFrames)
        msgbox('File does not exist or trials don''t match.','Error','error');
        handles.messages = addMessage(handles.messages,'File does not exist or trials don''t match.');
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
        return;
    end
    % ==================
    
    % any preprocessing to be done on inputs should be done here.
    % need to check for empty frames.
    global isDffCalculated
    if sum(squeeze(pixelTc{1}(1,1,:) == 0))
        handles.messages = addMessage(handles.messages,'Removing empty frames. This may take a minute...');
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
        
        for t=1:length(pixelTc)
            % hack to remove empty frames
            ind = squeeze(pixelTc{t}(1,1,:) == 0);
            pixelTc{t} = pixelTc{t}(:,:,~ind);
        end
    end
    isDffCalculated = false;
    % ===================
    
    % load analyzer file
    global Analyzer
    load(['Z:\ISI\Analyzer\' exptDetail.animal '\' exptDetail.animal '_u' exptDetail.unit '_' exptDetail.expt '.analyzer'],'-mat');
    % ===================
    
    handles.analyzer = Analyzer;
    handles.exptDetail = exptDetail;
    handles.imagingDetail = imagingDetail;
    handles.trialDetail = getTrialDetail(handles.analyzer);
        handles.messages = addMessage(handles.messages,'Data loaded.');
        handles.messages = addMessage(handles.messages,['Total trials: ' num2str(handles.trialDetail.nTrial)]);
        handles.messages = addMessage(handles.messages,['Repeats: ' num2str(handles.trialDetail.nRepeat)]);
        handles.messages = addMessage(handles.messages,['Blanks: ' num2str(handles.trialDetail.nRepeatBlank)]);
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
        
    handles.dataLoaded = true;
    handles.clickToMagnifyData = [4,0.08];
    set(handles.pulldown_param1,'String',handles.trialDetail.domains);
    set(handles.pulldown_param1,'Value',1);
    set(handles.textbox_moduloValue,'String','180','Enable','off');
    if strcmp(handles.trialDetail.domains{1},'ori')
        set(handles.checkbox_circular,'Value',1);
        handles.plotDetail.param1_circular = true;
    else
        set(handles.checkbox_circular,'Value',0);
        handles.plotDetail.param1_circular = false;
    end
    handles.plotDetail.param1name = handles.trialDetail.domains{1};
    handles.plotDetail.param1_modulo = false;
    handles.plotDetail.param1_moduloVal = 180;
    if handles.trialDetail.isMultipleDomain
        set(handles.pulldown_param2,'String',handles.trialDetail.domains);
        set(handles.pulldown_param2,'Value',2);
        set(handles.pulldown_param2Value,'String',unique(handles.trialDetail.domval(:,2)),'value',1);
        
        set(handles.radiobutton_mean,'Value',1);
        set(handles.radiobutton_all,'Value',0);
        set(handles.radiobutton_value,'Value',0);
        
        handles.plotDetail.param2name = handles.trialDetail.domains{2};
        handles.plotDetail.param2val = handles.trialDetail.domval(1,2);
        handles.plotDetail.param2mode = 'mean';
        
        set(handles.pulldown_param2Value,'enable','off');
        
        set(handles.pulldown_param2,'enable','on');
        set(handles.radiobutton_mean,'enable','on');
        set(handles.radiobutton_all,'enable','on');
        set(handles.radiobutton_value,'enable','on');
        
        handles.messages = addMessage(handles.messages,['Multiple variables: ' handles.trialDetail.domains{1} ', ' handles.trialDetail.domains{2} '.']);
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
    else
        set(handles.pulldown_param2,'enable','off');
        set(handles.pulldown_param2Value,'enable','off');
        set(handles.radiobutton_mean,'enable','off');
        set(handles.radiobutton_all,'enable','off');
        set(handles.radiobutton_value,'enable','off');
        
        handles.plotDetail.param2name = [];
        handles.plotDetail.param2val = [];
        handles.plotDetail.param2mode = [];
        
        handles.messages = addMessage(handles.messages,['Single variable: ' handles.trialDetail.domains{1} '.']);
        set(handles.listbox_messages,'String',handles.messages.messageList);
        set(handles.listbox_messages,'Value',handles.messages.count);
    end
    

function handles = updateTimeWindowsAndReplot(handles,respFrames)
    handles.timeWindows = getTimeWindows(handles.imagingDetail,respFrames);
    
    handles.messages = addMessage(handles.messages,['Baseline time (ms): ' num2str(round(handles.timeWindows.baselineRange(1))) ' to ' num2str(round(handles.timeWindows.baselineRange(2)))]);
    handles.messages = addMessage(handles.messages,['Response time (ms): ' num2str(round(handles.timeWindows.respRange(1))) ' to ' num2str(round(handles.timeWindows.respRange(2)))]);
    set(handles.listbox_messages,'String',handles.messages.messageList);
    set(handles.listbox_messages,'Value',handles.messages.count);
    
    handles.messages = addMessage(handles.messages,'Calculating pixel tuning.');
    set(handles.listbox_messages,'String',handles.messages.messageList);
    set(handles.listbox_messages,'Value',handles.messages.count);
    
    [handles.pixelTuning,handles.trialResp] = getPixelTuning...
        (handles.trialDetail,handles.timeWindows,...
        handles.plotDetail.filterPx,handles.imagingDetail.imageSize);
    
    % refresh the functional image
    [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
    handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
    
    % refresh the anatomy image
    handles.plotDetail.anatomy = getAnatomy;
    cla(handles.axis_anatomy);
    if handles.plotDetail.showAnatomy        
        imagesc(handles.plotDetail.anatomy,'parent',handles.axis_anatomy);
        colormap(handles.axis_anatomy,'gray')
        hold(handles.axis_anatomy,'on')
        set(handles.axis_anatomy,'xtick',[],'ytick',[]);
        box(handles.axis_anatomy,'on')
    end  


  function messages = addMessage(messages,msg)
    messages.count = messages.count + 1;
    messages.messageList{messages.count} = msg;
    
% =========================================================================
% ======================= HELPER FUNCTIONS DONE ===========================
% =========================================================================


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider_filterPx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_filterPx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
