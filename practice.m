function varargout = practice(varargin)
% PRACTICE MATLAB code for practice.fig
%      PRACTICE, by itself, creates a new PRACTICE or raises the existing
%      singleton*.
%
%      H = PRACTICE returns the handle to a new PRACTICE or the handle to
%      the existing singleton*.
%
%      PRACTICE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRACTICE.M with the given input arguments.
%
%      PRACTICE('Property','Value',...) creates a new PRACTICE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before practice_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to practice_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help practice

% Last Modified by GUIDE v2.5 29-Jun-2018 13:48:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @practice_OpeningFcn, ...
                   'gui_OutputFcn',  @practice_OutputFcn, ...
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


% --- Executes just before practice is made visible.
function practice_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to practice (see VARARGIN)

% Choose default command line output for practice
handles.output = hObject;

handles.t = tcpip('192.168.0.1',777);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes practice wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = practice_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in turnlighton.
function turnlighton_Callback(hObject, eventdata, handles)
% hObject    handle to turnlighton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global t

fopen(handles.t);
fprintf(handles.t,'SET:LEVEL:CHANNEL1,100;');
fscanf(handles.t)
fclose(handles.t);
fopen(handles.t);
fprintf(handles.t,'SET:MODE:CHANNEL1,1;');
fscanf(handles.t)
fclose(handles.t);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in off.
function off_Callback(hObject, eventdata, handles)
% hObject    handle to off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global t
% t = tcpip('192.168.0.1',777);
fopen(handles.t);
fprintf(handles.t,'SET:MODE:CHANNEL1,0;');
fscanf(handles.t)
fclose(handles.t);


% Update handles structure
guidata(hObject, handles);


% --- Executes on slider movement.
function lightintensity_Callback(hObject, eventdata, handles)
% hObject    handle to lightintensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

fopen(handles.t);
b = get(hObject,'Value')

%fprintf(handles.t,sprintf('SET:LEVEL:CHANNEL1,10^%d',b));
y = sprintf('SET:LEVEL:CHANNEL1,%d',b);
fprintf(handles.t,y);
fclose(handles.t);
% Update handles structure
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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
c = get(hObject,'String');
d = str2num(c)
fopen(handles.t);
z = sprintf('SET:LEVEL:CHANNEL1,%d',d);
fprintf(handles.t,z);
fscanf(handles.t)
fclose(handles.t);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
