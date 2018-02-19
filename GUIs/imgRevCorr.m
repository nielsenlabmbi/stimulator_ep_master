function varargout = imgRevCorr(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @imgRevCorr_OpeningFcn, ...
                       'gui_OutputFcn',  @imgRevCorr_OutputFcn, ...
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



% --- Executes just before imgRevCorr is made visible.
function imgRevCorr_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imgRevCorr (see VARARGIN)

% Choose default command line output for imgRevCorr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imgRevCorr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imgRevCorr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editImagesLocation_Callback(hObject, eventdata, handles)
% hObject    handle to editImagesLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editImagesLocation as text
%        str2double(get(hObject,'String')) returns contents of editImagesLocation as a double


% --- Executes during object creation, after setting all properties.
function editImagesLocation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editImagesLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOutputLocation_Callback(hObject, eventdata, handles)
% hObject    handle to editOutputLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOutputLocation as text
%        str2double(get(hObject,'String')) returns contents of editOutputLocation as a double


% --- Executes during object creation, after setting all properties.
function editOutputLocation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOutputLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editStimIds_Callback(hObject, eventdata, handles)
% hObject    handle to editStimIds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStimIds as text
%        str2double(get(hObject,'String')) returns contents of editStimIds as a double


% --- Executes during object creation, after setting all properties.
function editStimIds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStimIds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editNStim_Callback(hObject, eventdata, handles)
% hObject    handle to editNStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNStim as text
%        str2double(get(hObject,'String')) returns contents of editNStim as a double


% --- Executes during object creation, after setting all properties.
function editNStim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonGenerate.
function pushbuttonGenerate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonGenerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mstate;

%Check if this analyzer file already exists!
roots = strtrim(strsplit(Mstate.analyzerRoot,';'));    
for ii=1:length(roots)  %loop through each root
    title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];
    dd = fullfile(roots{ii},Mstate.anim, [title '.analyzer']);

    if(exist(dd,'file'))
        warndlg('File exists. Please advance experiment before running.')
        return
    end
end

if ~Mstate.running
    set(handles.textStatus,'String','Please wait. Calculating...'); drawnow;
    
    imagesLoc = get(handles.editImagesLocation,'String');
    outputLoc = get(handles.editOutputLocation,'String');
    stimIds = eval(get(handles.editStimIds,'String'));
    nStim = str2double(get(handles.editNStim,'String'));
    nTotalStim = str2double(get(handles.editNStimTotal,'String'));

    selectedIds = zeros(nStim,length(stimIds));
    selectedImages = nan(512,512,nStim*length(stimIds));
    for ii=1:length(stimIds)
        ids3d = sort(randperm(nTotalStim,nStim/2))';
        selectedIds(:,ii) = [ids3d; ids3d+nTotalStim];
        load([imagesLoc '\' num2str(stimIds(ii)) '.mat']);
        selectedImages(:,:,(nStim*(ii-1)+1):(ii*nStim)) = st(:,:,selectedIds(:,ii));
    end
    
    title = [Mstate.anim '_' Mstate.unit '_' Mstate.expt];
    save([outputLoc '/' title '_imgRevCorr.mat'],'selectedIds','selectedImages','stimIds')
    save([outputLoc '/tmp.mat'],'selectedIds','selectedImages','stimIds')
    
    set(handles.textStatus,'String','Files saved. Proceed to experiment.');
end



function editNStimTotal_Callback(hObject, eventdata, handles)
% hObject    handle to editNStimTotal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNStimTotal as text
%        str2double(get(hObject,'String')) returns contents of editNStimTotal as a double


% --- Executes during object creation, after setting all properties.
function editNStimTotal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNStimTotal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
