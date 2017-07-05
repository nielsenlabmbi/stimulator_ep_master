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

% Last Modified by GUIDE v2.5 03-Jul-2017 17:05:10

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

% Choose default command line output for camPreviewGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes camPreviewGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
cam = handles.cam;

axes(handles.axes1);

fprintf('Generating preview\n');
src = getselectedsource(cam);
set(src, 'TriggerMode', 'Off');
triggerconfig(cam,'immediate','none','none');

vidRes = cam.VideoResolution;
nBands = cam.NumberOfBands;
handles.hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
preview(cam, handles.hImage);
title('GigE preview');


% --------------------------------------------------------------------
function snapshot_Callback(hObject, eventdata, handles)
% hObject    handle to snapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frame = getsnapshot(cam);
stoppreview(cam);
cla; delete(findobj(handles.main,'type','uicontextmenu'));
image(frame);


% --------------------------------------------------------------------
function prev_Callback(hObject, eventdata, handles)
% hObject    handle to prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla; delete(findobj(handles.main,'type','uicontextmenu'));
preview(handles.cam, handles.hImage);

% --------------------------------------------------------------------
function ctxt_menu_Callback(hObject, eventdata, handles)
% hObject    handle to ctxt_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Outputs from this function are returned to the command line.
function varargout = camPreviewGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% function CloseRequestFcn(hObject, eventdata, handles)
%     delete(obj)
% 
% delete ( findobj ( h.main, 'type','uicontextmenu' ) )
