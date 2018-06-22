function varargout = ISIPixGui2(varargin)
% ISIPIXGUI2 MATLAB code for ISIPixGui2.fig
%      ISIPIXGUI2, by itself, creates a new ISIPIXGUI2 or raises the existing
%      singleton*.
%
%      H = ISIPIXGUI2 returns the handle to a new ISIPIXGUI2 or the handle to
%      the existing singleton*.
%
%      ISIPIXGUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ISIPIXGUI2.M with the given input arguments.
%
%      ISIPIXGUI2('Property','Value',...) creates a new ISIPIXGUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ISIPixGui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ISIPixGui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ISIPixGui2

% Last Modified by GUIDE v2.5 15-Jun-2018 11:16:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ISIPixGui2_OpeningFcn, ...
                   'gui_OutputFcn',  @ISIPixGui2_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before ISIPixGui2 is made visible.
function ISIPixGui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ISIPixGui2 (see VARARGIN)
   
% Choose default command line output for ISIPixGui2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ISIPixGui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ISIPixGui2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
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


% --- Executes during object creation, after setting all properties.
function slider_filterPx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_filterPx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in pulldown_param1.
function pulldown_param1_Callback(hObject, ~, handles)
    contents = cellstr(get(hObject,'String'));
    handles.plotDetail.param1name = contents{get(hObject,'Value')};
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pulldown_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pulldown_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_circular.
function checkbox_circular_Callback(hObject, ~, handles)
    handles.plotDetail.param1_circular = get(hObject,'Value');
    
    % get mean image
    if ~isempty(handles.pixelTuning)
        [handles.plotDetail.dispImage,handles.plotDetail.param1val] = getImage(handles.pixelTuning,handles.trialDetail,handles.plotDetail);
        handles.plotDetail.funcImage = plotImage(handles.plotDetail.dispImage,handles.plotDetail,handles.axis_image);
        enableMaskMode(handles);
    end
    guidata(hObject, handles);


% --- Executes on button press in checkbox_modulo.
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

% --- Executes during object creation, after setting all properties.
function textbox_moduloValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_moduloValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pulldown_param2.
function pulldown_param2_Callback(hObject, ~, handles)
    contents = cellstr(get(hObject,'String'));
    handles.plotDetail.param2name = contents{get(hObject,'Value')};
    handles.plotDetail.param2val = handles.trialDetail.domval(1,get(hObject,'Value'));
    set(handles.pulldown_param2Value,'String',unique(handles.trialDetail.domval(:,get(hObject,'Value'))),'value',1);
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pulldown_param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pulldown_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pulldown_param2Value.
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


% --- Executes during object creation, after setting all properties.
function pulldown_param2Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pulldown_param2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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
    
    
% --- Executes on button press in tbutton_pixelSelect.
function tbutton_pixelSelect_Callback(hObject, ~, handles)
    handles.pixelmode = ~handles.pixelmode;
    if handles.pixelmode
        handles.clickToMagnify = false;
        set(handles.tbutton_pixelSelect,'CData',handles.pixIcon_on);
        set(handles.tbutton_clickToMagnify,'CData',handles.ctmIcon);
    end
    guidata(hObject, handles);

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
    

    % handle pixel tuning selection
    if handles.pixelmode && ~isempty(handles.trialResp) && handles.buttonDownOnAxis
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
%         if handles.clickToMagnify
%             handles.buttonDownOnAxis = false;
%             H = get(hObject,'UserData');
%             f1 = H(1); a1 = H(2); a2 = H(3);
%             set(a1,'Color',get(a2,'Color'));
%             set(f1,'UserData',[],'Pointer','arrow','CurrentAxes',a1);
%             if ~strcmp(get(f1,'SelectionType'),'alt'),
%               delete(a2);
%             end
%         end
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
% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
