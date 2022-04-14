function varargout = shutterSetting(varargin)
% SHUTTERSETTING MATLAB code for shutterSetting.fig
%      SHUTTERSETTING, by itself, creates a new SHUTTERSETTING or raises the existing
%      singleton*.
%
%      H = SHUTTERSETTING returns the handle to a new SHUTTERSETTING or the handle to
%      the existing singleton*.
%
%      SHUTTERSETTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHUTTERSETTING.M with the given input arguments.
%
%      SHUTTERSETTING('Property','Value',...) creates a new SHUTTERSETTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before shutterSetting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to shutterSetting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help shutterSetting

% Last Modified by GUIDE v2.5 06-Mar-2017 18:09:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @shutterSetting_OpeningFcn, ...
                   'gui_OutputFcn',  @shutterSetting_OutputFcn, ...
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


% --- Executes just before shutterSetting is made visible.
function shutterSetting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to shutterSetting (see VARARGIN)

% Choose default command line output for shutterSetting
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global shutterInfo
if shutterInfo.LEch==1
    set(handles.channelSel1,'Value',1);
    set(handles.channelSel2,'Value',0);
else
    set(handles.channelSel1,'Value',0);
    set(handles.channelSel2,'Value',1);
end

if shutterInfo.LEopen==1
    set(handles.LEopenBit,'Value',1);
else
    set(handles.LEopenBit,'Value',2);
end
if shutterInfo.REopen==1
    set(handles.REopenBit,'Value',1);
else
    set(handles.REopenBit,'Value',2);
end

set(handles.waitTime,'string',num2str(shutterInfo.waitTime));

% UIWAIT makes shutterSetting wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = shutterSetting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LEopen.
function LEopen_Callback(hObject, eventdata, handles)
% hObject    handle to LEopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LEopen
global shutterInfo

LEbit = get(hObject,'Value');
if shutterInfo.LEopen==0
    LEbit=1-LEbit;
end

moveShutter(shutterInfo.LEch,LEbit);
waitforDisplayResp

% --- Executes on button press in REopen.
function REopen_Callback(hObject, eventdata, handles)
% hObject    handle to REopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of REopen
global shutterInfo

REbit = get(hObject,'Value');
if shutterInfo.REopen==0
    REbit=1-REbit;
end

moveShutter(shutterInfo.REch,REbit);
waitforDisplayResp

% --- Executes on button press in channelSel1.
function channelSel1_Callback(hObject, eventdata, handles)
% hObject    handle to channelSel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global shutterInfo

% Hint: get(hObject,'Value') returns toggle state of channelSel1
if get(handles.channelSel1,'Value')==1
    set(handles.channelSel2,'Value',0);
    shutterInfo.LEch=1;
    shutterInfo.REch=2;
else
    set(handles.channelSel2,'Value',1);
    shutterInfo.LEch=2;
    shutterInfo.REch=1;
end


% --- Executes on button press in channelSel2.
function channelSel2_Callback(hObject, eventdata, handles)
% hObject    handle to channelSel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channelSel2
global shutterInfo

% Hint: get(hObject,'Value') returns toggle state of channelSel1
if get(handles.channelSel2,'Value')==1
    set(handles.channelSel1,'Value',0);
    shutterInfo.LEch=2;
    shutterInfo.REch=1;
else
    set(handles.channelSel1,'Value',1);
    shutterInfo.LEch=1;
    shutterInfo.REch=2;
end

% --- Executes on selection change in LEopenBit.
function LEopenBit_Callback(hObject, eventdata, handles)
% hObject    handle to LEopenBit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LEopenBit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LEopenBit
global shutterInfo

mTmp=get(hObject,'string');
mVal=get(hObject,'value');
shutterInfo.LEopen = str2num(mTmp{mVal});

% --- Executes during object creation, after setting all properties.
function LEopenBit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LEopenBit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in REopenBit.
function REopenBit_Callback(hObject, eventdata, handles)
% hObject    handle to REopenBit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns REopenBit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from REopenBit
global shutterInfo

mTmp=get(hObject,'string');
mVal=get(hObject,'value');
shutterInfo.REopen = str2num(mTmp{mVal});


% --- Executes during object creation, after setting all properties.
function REopenBit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to REopenBit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function waitTime_Callback(hObject, eventdata, handles)
% hObject    handle to waitTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of waitTime as text
%        str2double(get(hObject,'String')) returns contents of waitTime as a double
global shutterInfo

shutterInfo.waitTime=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function waitTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waitTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
