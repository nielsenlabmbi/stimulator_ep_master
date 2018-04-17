function varargout = MainWindow(varargin)
% MAINWINDOW M-file for MainWindow.fig
%      MAINWINDOW, by itself, creates a new MAINWINDOW or raises the existing
%      singleton*.
%
%      H = MAINWINDOW returns the handle to a new MAINWINDOW or the handle to
%      the existing singleton*.
%
%      MAINWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINWINDOW.M with the given input arguments.
%
%      MAINWINDOW('Property','Value',...) creates a new MAINWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainWindow

% Last Modified by GUIDE v2.5 26-Mar-2018 18:07:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @MainWindow_OutputFcn, ...
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


% --- Executes just before MainWindow is made visible.
function MainWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainWindow (see VARARGIN)

% Choose default command line output for MainWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


global GUIhandles Mstate setupDefault

Mstate.running = 0;

%Set GUI to the default established in configureMstate
set(handles.screendistance,'string',num2str(Mstate.screenDist))
set(handles.analyzerRoots,'string',Mstate.analyzerRoot)
set(handles.animal,'string',Mstate.anim)
set(handles.unitcb,'string',Mstate.unit)
set(handles.exptcb,'string',Mstate.expt)
set(handles.hemisphere,'string',Mstate.hemi)
set(handles.screendistance,'string',Mstate.screenDist)
set(handles.dataRoots,'string',Mstate.dataRoot)

monitorName{1}=setupDefault.defaultMonitor;
mTmp=strtrim(strsplit(setupDefault.alternativeMonitor,';'));
for i=1:length(mTmp)
    monitorName{i+1}=mTmp{i};
end
set(handles.monitor,'string',monitorName)


if setupDefault.useMCDaq==0 || setupDefault.useVentilator==0
    set(handles.syncVflag,'Enable','off')
end

GUIhandles.main = handles;




% --- Outputs from this function are returned to the command line.
function varargout = MainWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function animal_Callback(hObject, eventdata, handles)
% hObject    handle to animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of animal as text
%        str2double(get(hObject,'String')) returns contents of animal as a double

global Mstate GUIhandles setupDefault

Mstate.anim = get(handles.animal,'string');

roots = strsplit(Mstate.analyzerRoot,';');

dirinfo = dir(fullfile(roots{1},Mstate.anim)); %Use the first root path for the logic below

if length(dirinfo) > 2 %If the animal folder exists and there are files in it
    
    lastunit = dirinfo(end).name(8:10);
    lastexpt = dirinfo(end).name(12:14);

    newunit = lastunit; 
    newexpt = sprintf('%03d',str2num(lastexpt)+1); %Go to next experiment number
    
else  %if animal folder does not exist or there aren't any files.  The new folder will
        %be created when you hit the 'run' button
    
    newunit = '000';
    newexpt = '000';

end

Mstate.unit = newunit;
Mstate.expt = newexpt;
set(handles.exptcb,'string',newexpt)
set(handles.unitcb,'string',newunit)
set(handles.showTrial,'string','' )

if get(GUIhandles.main.daqflag,'value')
    updateAcqName   %Send expt info to acquisition
end

save(setupDefault.MstateHistoryFile,'Mstate');

% --- Executes during object creation, after setting all properties.
function animal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hemisphere_Callback(hObject, eventdata, handles)
% hObject    handle to hemisphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hemisphere as text
%        str2double(get(hObject,'String')) returns contents of hemisphere as a double

global Mstate setupDefault

%This is not actually necessary since updateMstate is always called prior
%to showing stimuli...
Mstate.hemi = get(handles.hemisphere,'string');
save(setupDefault.MstateHistoryFile,'Mstate');

% --- Executes during object creation, after setting all properties.
function hemisphere_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hemisphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function screendistance_Callback(hObject, eventdata, handles)
% hObject    handle to screendistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of screendistance as text
%        str2double(get(hObject,'String')) returns contents of screendistance as a double

global Mstate setupDefault

%This is not actually necessary since updateMstate is always called prior
%to showing stimuli...  
Mstate.screenDist = str2num(get(handles.screendistance,'string'));
save(setupDefault.MstateHistoryFile,'Mstate');

% --- Executes during object creation, after setting all properties.
function screendistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to screendistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runbutton.
function runbutton_Callback(hObject, eventdata, handles)
% hObject    handle to runbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mstate GUIhandles  trialno Lstate setupDefault

if ~exist(setupDefault.ExperimentMasterFile,'file')
    resetExperimentMasterListFile;
end
tempStruct = load(setupDefault.ExperimentMasterFile); %generates expts and count
count = tempStruct.count;
expts = tempStruct.expts;

%Run it!
if ~Mstate.running
    
    %Check if this analyzer file already exists!
    roots = strtrim(strsplit(Mstate.analyzerRoot,';'));    
    for i = 1:length(roots)  %loop through each root
        title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];
        dd = fullfile(roots{i},Mstate.anim,[title '.analyzer']);
        
        if(exist(dd))
            warndlg('File exists!!!  Please advance experiment before running')
            return
        end
    end
    
    if get(GUIhandles.main.daqflag,'value')
        setAcqDir   %check (and set) acquisition file if necessary
    end
    
    
    %check whether breathing is possible
    if get(handles.syncVflag,'Value')==1
        brOk=checkSyncV;
        if brOk==0
            warndlg('Trial too long to sync ventilator to stim!')
            return
        end
    end
    
    Mstate.running = 1;  %Global flag for interrupt in real-time loop ('Abort')
    
    %Update states just in case user has not pressed enter after inputing
    %fields:
    updateLstate
    updateMstate   
    
    %update randum number generator seed
    rng(datenum(date)+100*str2double(Mstate.unit)+str2double(Mstate.expt));
    
    makeLoop;  %makes 'looperInfo'.  This must be done before saving the analyzer file.

    saveExptParams  %Save .analyzer. Do this before running... in case something crashes

    count = count + 1; %Save for database
    expts(count).Mstate = Mstate;
    expts(count).Lstate = Lstate;
    expts(count).abort = 0;
    
    save(setupDefault.ExperimentMasterFile,'expts','count','-append');
    
    set(handles.runbutton,'string','Abort')    
    
    %%%%Send initial parameters to display
    modID = getmoduleID;
    sendPinfo(modID)
    % disp('send P')
    waitforDisplayResp;
    sendMinfo
    % disp('send M')
    waitforDisplayResp;
    %%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%Get the Acquisition ready:
    if get(GUIhandles.main.daqflag,'value')  %Flag for the link with Blackrock
        pause(5);
        startAcq;
        pause(2);
    end
        
    % clear all current trial details from Looper window
    for ii=1:5
        eval(['set(GUIhandles.looper.currtri' num2str(ii) ',''string'','' ''), drawnow;']);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    trialno = 1;
       
    run2  %gets recalled after each trial (in 'endAcquisition' or 'Displaycb')
    
    
else
    Mstate.running = 0;  %Global flag for interrupt in real-time loop ('Abort')    
    set(handles.runbutton,'string','Run')
    
    expts(count).abort = 1;
    save(setupDefault.ExperimentMasterFile,'expts','-append');
end




% --- Executes on button press in unitcb.
function unitcb_Callback(hObject, eventdata, handles)
% hObject    handle to unitcb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mstate GUIhandles setupDefault

newunit = sprintf('%03d',str2num(Mstate.unit)+1);
Mstate.unit = newunit;
set(handles.unitcb,'string',newunit)

newexpt = '000';
Mstate.expt = newexpt;
set(handles.exptcb,'string',newexpt)
set(handles.showTrial,'string','' )

if get(GUIhandles.main.daqflag,'value')
    updateAcqName   %Send expt info to acquisition
end

save(setupDefault.MstateHistoryFile,'Mstate');

% --- Executes on button press in exptcb.
function exptcb_Callback(hObject, eventdata, handles)
% hObject    handle to exptcb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Mstate GUIhandles setupDefault

newexpt = sprintf('%03d',str2num(Mstate.expt)+1);
Mstate.expt = newexpt;
set(handles.exptcb,'string',newexpt)
set(handles.showTrial,'string','' )

if get(GUIhandles.main.daqflag,'value')
    updateAcqName   %Send expt info to acquisition
end

save(setupDefault.MstateHistoryFile,'Mstate');

% --- Executes on button press in closeDisplay.
function closeDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to closeDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DcomState

fwrite(DcomState.serialPortHandle,'C;~')


% --- Executes on button press in stimonlyflag.
function stimonlyflag_Callback(hObject, eventdata, handles)
% hObject    handle to stimonlyflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stimonlyflag

global GUIhandles

flagS = get(handles.stimonlyflag,'value');
flagD = get(handles.daqflag,'value');

%make sure something is selected at all times
if flagS+flagD==0
    flagS=1;
end

%stimonly selected; unselect the other one
if flagS==1
    flagD=0;
end

%update radiobuttons
set(GUIhandles.main.stimonlyflag,'value',flagS);
set(GUIhandles.main.daqflag,'value',flagD);



% --- Executes on button press in daqflag.
function daqflag_Callback(hObject, eventdata, handles)
% hObject    handle to daqflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of daqflag

global GUIhandles

flagS = get(handles.stimonlyflag,'value');
flagD = get(handles.daqflag,'value');

%make sure something is selected at all times
if flagS+flagD== 0
    flagS=1;
end

%ephys selected; unselect the other ones
if flagD==1
    flagS=0;
end

%update radiobuttons
set(GUIhandles.main.stimonlyflag,'value',flagS);
set(GUIhandles.main.daqflag,'value',flagD);




function analyzerRoots_Callback(hObject, eventdata, handles)
% hObject    handle to analyzerRoots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of analyzerRoots as text
%        str2double(get(hObject,'String')) returns contents of analyzerRoots as a double

global Mstate setupDefault
%This is not actually necessary since updateMstate is always called prior
%to showing stimuli...
Mstate.analyzerRoot = get(handles.analyzerRoots,'string');
save(setupDefault.MstateHistoryFile,'Mstate');

% --- Executes during object creation, after setting all properties.
function analyzerRoots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analyzerRoots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function monitor_Callback(hObject, eventdata, handles)
% hObject    handle to monitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of monitor as text
%        str2double(get(hObject,'String')) returns contents of monitor as a double

global Mstate setupDefault

mTmp=get(handles.monitor,'string');
mVal=get(handles.monitor,'value');
Mstate.monitorName = mTmp{mVal};

updateMonitorValues
sendMonitor
save(setupDefault.MstateHistoryFile,'Mstate');

% --- Executes during object creation, after setting all properties.
function monitor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dataRoots_Callback(hObject, eventdata, handles)
% hObject    handle to dataRoots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataRoots as text
%        str2double(get(hObject,'String')) returns contents of dataRoots as a double
global Mstate setupDefault
Mstate.dataRoot = get(handles.dataRoots,'string');
save(setupDefault.MstateHistoryFile,'Mstate');

% --- Executes during object creation, after setting all properties.
function dataRoots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataRoots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function resetExperimentMasterListFile

global setupDefault
count = 0;
expts = [];
save(setupDefault.ExperimentMasterFile,'expts','count');


% --- Executes on button press in reconnectSlave.
function reconnectSlave_Callback(hObject, eventdata, handles)
% hObject    handle to reconnectSlave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
configDisplayCom_tcp;
