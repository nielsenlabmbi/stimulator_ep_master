function varargout = optoStim(varargin)
% OPTOSTIM MATLAB code for optoStim.fig
%      OPTOSTIM, by itself, creates a new OPTOSTIM or raises the existing
%      singleton*.
%
%      H = OPTOSTIM returns the handle to a new OPTOSTIM or the handle to
%      the existing singleton*.
%
%      OPTOSTIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTOSTIM.M with the given input arguments.
%
%      OPTOSTIM('Property','Value',...) creates a new OPTOSTIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before optoStim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to optoStim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help optoStim

% Last Modified by GUIDE v2.5 31-Oct-2017 16:37:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @optoStim_OpeningFcn, ...
                   'gui_OutputFcn',  @optoStim_OutputFcn, ...
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


% --- Executes just before optoStim is made visible.
function optoStim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to optoStim (see VARARGIN)

% Choose default command line output for optoStim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global optoInfo
set(handles.eCh,'string',num2str(optoInfo.Ch));
set(handles.eDur,'string',num2str(optoInfo.pulseDur));
set(handles.eHz,'string',num2str(optoInfo.pulseFreq));
set(handles.eTrainDur,'string',num2str(optoInfo.trainDur));

% UIWAIT makes optoStim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = optoStim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bSingle.
function bSingle_Callback(hObject, eventdata, handles)
% hObject    handle to bSingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sendOptoPar;
waitforDisplayResp
sendOptoGo(1);
waitforDisplayResp


% --- Executes on button press in bTrain.
function bTrain_Callback(hObject, eventdata, handles)
% hObject    handle to bTrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function eDur_Callback(hObject, eventdata, handles)
% hObject    handle to eDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eDur as text
%        str2double(get(hObject,'String')) returns contents of eDur as a double

global optoInfo
optoInfo.pulseDur=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function eDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function eHz_Callback(hObject, eventdata, handles)
% hObject    handle to eHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eHz as text
%        str2double(get(hObject,'String')) returns contents of eHz as a double

global optoInfo
optoInfo.pulseFreq=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function eHz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eTrainDur_Callback(hObject, eventdata, handles)
% hObject    handle to eTrainDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eTrainDur as text
%        str2double(get(hObject,'String')) returns contents of eTrainDur as a double
global optoInfo
optoInfo.trainDur=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function eTrainDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eTrainDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eCh_Callback(hObject, eventdata, handles)
% hObject    handle to eCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eCh as text
%        str2double(get(hObject,'String')) returns contents of eCh as a double
global optoInfo
optoInfo.Ch=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function eCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
