function varargout = camPreviewGui(varargin)
% CAMPREVIEWGUI MATLAB code for camPreviewGui.fig
%      CAMPREVIEWGUI, by itself, creates a new CAMPREVIEWGUI or raises the existing
%      singleton*.
%
%      H = CAMPREVIEWGUI returns the handle to a new CAMPREVIEWGUI or the handle to
%      the existing singleton*.
%
%      CAMPREVIEWGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMPREVIEWGUI.M with the given input arguments.
%
%      CAMPREVIEWGUI('Property','Value',...) creates a new CAMPREVIEWGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before camPreviewGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to camPreviewGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help camPreviewGui

% Last Modified by GUIDE v2.5 09-Feb-2019 22:28:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @camPreviewGui_OpeningFcn, ...
                   'gui_OutputFcn',  @camPreviewGui_OutputFcn, ...
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


% --- Executes just before camPreviewGui is made visible.
function camPreviewGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to camPreviewGui (see VARARGIN)
set(gcf,'toolbar','none')

global previewImg GUIhandles setupDefault
previewImg = handles.previewImg;
axes(handles.acqYN); set(handles.acqYN,'XTick',[],'YTick',[]); axis tight;
x = [0 1 1 0];
y = [0 0 1 1];
patch(x,y,'red');

axes(handles.previewImg); set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
handles.image = zeros(100);
imshow(handles.image);
handles.oImage = handles.image;

% Update handles structure
guidata(hObject, handles);

if (exist('cam','var'))
    set(handles.openCam,'Enable','Off');
    set(handles.closeCam,'Enable','On');
else
    set(handles.openCam,'Enable','On');
    set(handles.closeCam,'Enable','Off');
end

% lights
handles.output = hObject;
handles.t1 = tcpip(setupDefault.light1IP,777);
handles.t2 = tcpip(setupDefault.light2IP,777);
set(handles.lightintensity,'Min',1);
set(handles.lightintensity,'Max',250);

% Update handles structure
guidata(hObject,handles);

GUIhandles.ISI_NL = handles;

% Choose default command line output for camPreviewGui
handles.output = hObject;


% UIWAIT makes camPreviewGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = camPreviewGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in getPreview.
function getPreview_Callback(hObject, eventdata, handles)
% hObject    handle to getPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Initialize camera
global cam
src = getselectedsource(cam);
set(src, 'TriggerMode', 'Off');
triggerconfig(cam,'immediate','none','none');
handles.vidRes = cam.VideoResolution;
handles.nBands = cam.NumberOfBands;

fprintf('Generating preview\n');
axes(handles.previewImg); set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
handles.hImage = image( zeros(handles.vidRes(2), handles.vidRes(1), handles.nBands) );
preview(cam, handles.hImage);
title('GigE preview');

axes(handles.acqYN); set(handles.acqYN,'XTick',[],'YTick',[]); axis tight;
x = [0 1 1 0];
y = [0 0 1 1];
patch(x,y,'green','parent',handles.acqYN);
    
% Update handles structure
guidata(hObject,handles);

% --- Executes on button press in stopPreview.
function stopPreview_Callback(hObject, eventdata, handles)
% hObject    handle to stopPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam
stoppreview(cam);

axes(handles.acqYN);  set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
x = [0 1 1 0];
y = [0 0 1 1];
patch(x,y,'red','parent',handles.acqYN);

fprintf('Preview done\n');

% Update handles structure
guidata(hObject,handles);

% --- Executes on button press in getSnapshot.
function getSnapshot_Callback(hObject, eventdata, handles)
% hObject    handle to getSnapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam
handles.image = getsnapshot(cam);
handles.oImage = handles.image;
stoppreview(cam);
cla(handles.previewImg); axes(handles.previewImg);  set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
image(handles.image);
axes(handles.acqYN);  set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
x = [0 1 1 0];
y = [0 0 1 1];
patch(x,y,'red','parent',handles.acqYN);

% Update handles structure
guidata(hObject,handles);

function SaveSnapshot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to SaveSnapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure; imshow(handles.image);
filemenufcn(gcf,'FileSaveAs')

% --- Executes on button press in closeCam.
function closeCam_Callback(hObject, eventdata, handles)
% hObject    handle to closeCam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam;

src = getselectedsource(cam);
if(exist('cam', 'var'))
    delete(cam);
    clear cam;
    clear src;
end

set(handles.openCam,'Enable','On');
set(handles.closeCam,'Enable','Off');
% update handles structure
guidata(hObject,handles);

% --- Executes on button press in openCam.
function openCam_Callback(hObject, eventdata, handles)
% hObject    handle to openCam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% create camera 
global camInfo cam

cam = videoinput('gige', 1);
src = getselectedsource(cam);
stop(cam);

set(handles.closeCam,'Enable','On');
set(handles.openCam,'Enable','Off');
guidata(hObject,handles);


% --- Executes on button press in turnlighton.
function turnlighton_Callback(hObject, eventdata, handles)
% hObject    handle to turnlighton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fopen(handles.t1);
fprintf(handles.t1,'SET:LEVEL:CHANNEL1,100;');
fscanf(handles.t1)
fclose(handles.t1);
fopen(handles.t1);
fprintf(handles.t1,'SET:MODE:CHANNEL1,1;');
fscanf(handles.t1)
fclose(handles.t1);
handles.status = 1;

fopen(handles.t2);
fprintf(handles.t,'SET:LEVEL:CHANNEL1,100;');
fscanf(handles.t2)
fclose(handles.t2);
fopen(handles.t2);
fprintf(handles.t2,'SET:MODE:CHANNEL1,1;');
fscanf(handles.t2)
fclose(handles.t2);
handles.status = 1;

set(handles.lightintensity,'Value',100);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in off.
function off_Callback(hObject, eventdata, handles)
% hObject    handle to off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fopen(handles.t1);
fprintf(handles.t1,'SET:MODE:CHANNEL1,0;');
fscanf(handles.t1)
fclose(handles.t1);
handles.status = 0;

fopen(handles.t2);
fprintf(handles.t2,'SET:MODE:CHANNEL1,0;');
fscanf(handles.t2)
fclose(handles.t2);
handles.status = 0;

set(handles.lightintensity,'Value',1);

% Update handles structure
guidata(hObject, handles);



% --- Executes on slider movement.
function lightintensity_Callback(hObject, eventdata, handles)
% hObject    handle to lightintensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
b = get(hObject,'Value');
z = round(b);

fopen(handles.t1);
y = sprintf('SET:LEVEL:CHANNEL1,%d',z);
fprintf(handles.t1,y);
fscanf(handles.t1)
fclose(handles.t1);

fopen(handles.t2);
y = sprintf('SET:LEVEL:CHANNEL1,%d',z);
fprintf(handles.t2,y);
fscanf(handles.t2)
fclose(handles.t2);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lightintensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lightintensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function FrameRate_Callback(hObject, eventdata, handles)
% hObject    handle to FrameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameRate as text
%        str2double(get(hObject,'String')) returns contents of FrameRate as a double


% --- Executes during object creation, after setting all properties.
function FrameRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FrameGrabInterval_Callback(hObject, eventdata, handles)
% hObject    handle to FrameGrabInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameGrabInterval as text
%        str2double(get(hObject,'String')) returns contents of FrameGrabInterval as a double


% --- Executes during object creation, after setting all properties.
function FrameGrabInterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameGrabInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Compression_Callback(hObject, eventdata, handles)
% hObject    handle to Compression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Compression as text
%        str2double(get(hObject,'String')) returns contents of Compression as a double


% --- Executes during object creation, after setting all properties.
function Compression_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Compression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AcqDur_Callback(hObject, eventdata, handles)
% hObject    handle to AcqDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AcqDur as text
%        str2double(get(hObject,'String')) returns contents of AcqDur as a double


% --- Executes during object creation, after setting all properties.
function AcqDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AcqDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
