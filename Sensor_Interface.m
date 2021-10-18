function varargout = Sensor_Interface(varargin)
% SENSOR_INTERFACE MATLAB code for Sensor_Interface.fig
%      SENSOR_INTERFACE, by itself, creates a new SENSOR_INTERFACE or raises the existing
%      singleton*.
%
%      H = SENSOR_INTERFACE returns the handle to a new SENSOR_INTERFACE or the handle to
%      the existing singleton*.
%
%      SENSOR_INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SENSOR_INTERFACE.M with the given input arguments.
%
%      SENSOR_INTERFACE('Property','Value',...) creates a new SENSOR_INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sensor_Interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sensor_Interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sensor_Interface

% Last Modified by GUIDE v2.5 15-Dec-2020 08:32:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sensor_Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @Sensor_Interface_OutputFcn, ...
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


% --- Executes just before Sensor_Interface is made visible.
function Sensor_Interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sensor_Interface (see VARARGIN)

% Choose default command line output for Sensor_Interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Sensor_Interface wait for user response (see UIRESUME)
% uiwait(handles.figureMain);


% --- Outputs from this function are returned to the command line.
function varargout = Sensor_Interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figureMain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figureMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles = guihandles;
set(handles.figureMain,'HandleVisibility','off');
close(findobj('type','figure','name','Sensor_Interface'));
set(handles.figureMain,'HandleVisibility','on');

handles = guihandles;
handles.str = '';
handles.handleBtn = 1;
guidata(hObject,handles);

delete(instrfindall);
delete(timerfindall);

global AllValue;
AllValue = [];
AllValue.value.raw = [];
AllValue.value.processed = [];
AllValue.folder.lib = 'Library';
AllValue.folder.saveFolder = 'Save';
AllValue.serial = serial('port');
AllValue.serial.UserData.ac = [];
AllValue.serial.UserData.val = [];
AllValue.serial.UserData.count = 0;
AllValue.time = timer();
AllValue.time.UserData = 0;
AllValue.send = '';
AllValue.get.delay = 1;
AllValue.get.num = 1;
AllValue.get.gain = 1;
AllValue.valueSet.form = {'%f'};
AllValue.valueSet.fullName = {'Time (s)','Volt (V)'};
AllValue.plot.LS.val = '-';
AllValue.plot.LS.id = 2;
AllValue.plot.mark.val = '';
AllValue.plot.mark.id = 1;
AllValue.plot.LW = 1;
AllValue.plot.grid = 'off';
AllValue.check.serial = 0;
AllValue.check.time = 0;
AllValue.check.ready = 0;
AllValue.check.start = 0;
AllValue.check.read = 0;
AllValue.check.change = 0;
AllValue.check.save = 0;
AllValue.check.load = 0;
AllValue.check.calib = 0;
AllValue.confirm = '';
AllValue.calib.type = 'Exact';
AllValue.calib.x0 = [];
AllValue.calib.y0 = [];
AllValue.calib.check = [];
AllValue.calib.status = 'off';

hold on;
zoom on;
legend show;
title('Sensor Plot','Color','w');
xlabel('Time (s)','Color','w');
ylabel('All Value','Color','w');

set(AllValue.time,'ExecutionMode','fixedrate');
set(AllValue.time,'BusyMode','queue');
set(AllValue.time,'StartDelay',1);
AllValue.time.TimerFcn = @(~,~)readFcn(handles);

set(AllValue.serial,'BytesAvailableFcnMode','terminator');
set(AllValue.serial,'Terminator','CR/LF');
AllValue.serial.BytesAvailableFcn = @(~,~)receiveSignal(handles);
AllValue.serial.TimerFcn = @(~,~)serialTimer(handles);



% --- Executes on button press in btnPower.
function btnPower_Callback(hObject, eventdata, handles)
% hObject    handle to btnPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnPower

global AllValue;
if get(hObject,'Value')
    btnOn(handles);
    cd(AllValue.folder.lib);
    Serial;
    uiwait(Serial);
    cd ../;
    if AllValue.check.serial
        btnWhileConnect(handles,'on');
        AllValue.check.serial = 0;
    else
        btnOff(handles);
    end
else
    if isequal(AllValue.serial.Status,'open')
        fclose(AllValue.serial);
    end
    if strcmp(AllValue.time.Running,'on')
        stop(AllValue.time);
    end
    btnOff(handles);
    btnWhileConnect(handles,'off');
    set(handles.btnAcqr,'String','Acquire');
end



function btnOn(handles)
set(handles.btnPower,'String','ON');
set(handles.btnPower,'Value',1);
set(handles.btnPower,'ForegroundColor','k');
set(handles.btnPower,'BackgroundColor','w');



function btnWhileConnect(handles,status)
set(handles.btnAcqr,'Enable',status);
handles.editDelay.Enable = status;
handles.editNum.Enable = status;
handles.editGain.Enable = status;
handles.editSend.Enable = status;
if isempty(handles.str) 
    set(handles.btnSend,'Enable','off');
else
    set(handles.btnSend,'Enable','on');
end
handles.btnCalib.Enable = status;


function btnHandleValue(handles,status)
handles.btnMax.Enable = status;
handles.btnMin.Enable = status;
handles.btnAvrg.Enable = status;
handles.btnSave.Enable = status;


function btnOff(handles)
set(handles.btnPower,'String','OFF');
set(handles.btnPower,'Value',0);
set(handles.btnPower,'ForegroundColor','w');
set(handles.btnPower,'BackgroundColor','k');



% --- Executes on button press in btnSave.
function btnSave_Callback(hObject, eventdata, handles)
% hObject    handle to btnSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
cd(AllValue.folder.lib);
Save;
uiwait(Save);
cd ../;



% --- Executes on button press in btnLoad.
function btnLoad_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
AllValue.check.save = 2;
if AllValue.check.change
    cd(AllValue.folder.lib);
    AllValue.confirm = 'Keep data';
    Confirm;
    uiwait(Confirm);
    cd ../;
end
if AllValue.check.save
    if AllValue.check.save == 1
        btnSave_Callback(handles.btnSave, eventdata, handles);
    end
    cd(AllValue.folder.lib);
    Load;
    uiwait(Load);
    cd ../;
    if AllValue.check.load
        btnHandleValue(handles,'on');
        showValue(handles);
        setName(handles);
        AllValue.check.load = 0;
    end
end



% --- Executes on button press in btnMin.
function btnMin_Callback(hObject, eventdata, handles)
% hObject    handle to btnMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
if ~isempty(AllValue.value.processed)
    minValue = min(AllValue.value.processed);
    nameId = get(handles.popName,'Value');
    minId = (AllValue.value.processed == minValue);
    setTextT_V(handles,AllValue.value.processed(minId(:,nameId+1),1),minValue(nameId+1));
else
    setTextT_V(0,0);
end

handles.handleBtn = 0;
guidata(hObject,handles);


function setTextT_V(handles,t,V)
set(handles.textT,'String',num2str(t));
set(handles.textV,'String',num2str(V));


% --- Executes on button press in btnAvrg.
function btnAvrg_Callback(hObject, eventdata, handles)
% hObject    handle to btnAvrg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
if ~isempty(AllValue.value.processed)
    avrgValue = mean(AllValue.value.processed);
    nameId = get(handles.popName,'Value');
    avrgTime = AllValue.value.processed(AllValue.value.processed(:,nameId+1) == avrgValue(nameId+1),1);
    if isempty(avrgTime)
        setTextT_V(handles,0,avrgValue(nameId+1));
    else
        setTextT_V(handles,avrgTime(end),avrgValue(nameId+1));
    end
else
    setTextT_V(0,0);
end
    
handles.handleBtn = 1;
guidata(hObject,handles);


% --- Executes on button press in btnMax.
function btnMax_Callback(hObject, eventdata, handles)
% hObject    handle to btnMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
if ~isempty(AllValue.value.processed)
    maxValue = max(AllValue.value.processed);
    nameId = get(handles.popName,'Value');
    maxId = (AllValue.value.processed == maxValue);
    setTextT_V(handles,AllValue.value.processed(maxId(:,nameId+1),1),maxValue(nameId+1));
else
    setTextT_V(0,0);
end

handles.handleBtn = 2;
guidata(hObject,handles);


% --- Executes on selection change in popName.
function popName_Callback(hObject, eventdata, handles)
% hObject    handle to popName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popName contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popName
global AllValue;
nameId = get(hObject,'Value');
if ~isempty(AllValue.value.processed)
    if handles.handleBtn == 0
        minValue = min(AllValue.value.processed);
        minId = (AllValue.value.processed == minValue);
        setTextT_V(handles,AllValue.value.processed(minId(:,nameId+1),1),minValue(nameId+1));
    elseif handles.handleBtn == 1
        avrgValue = mean(AllValue.value.processed);
        avrgTime = AllValue.value.processed(AllValue.value.processed(:,nameId+1) == avrgValue(nameId+1),1);
        if isempty(avrgTime)
            setTextT_V(handles,0,avrgValue(nameId+1));
        else
            setTextT_V(handles,avrgTime(end),avrgValue(nameId+1));
        end
    else
        maxValue = max(AllValue.value.processed);
        maxId = (AllValue.value.processed == maxValue);
        setTextT_V(handles,AllValue.value.processed(maxId(:,nameId+1),1),maxValue(nameId+1));
    end
else
    setTextT_V(handles,0,0);
end


% --- Executes during object deletion, before destroying properties.
function figureMain_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figureMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global AllValue;
if isequal(AllValue.serial.Status,'open')
    fclose(AllValue.serial);
end
if strcmp(AllValue.time.Running,'on')
    stop(AllValue.time);
end
delete(instrfindall);
delete(timerfindall);
clear all;



function editDelay_Callback(hObject, eventdata, handles)
% hObject    handle to editDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDelay as text
%        str2double(get(hObject,'String')) returns contents of editDelay as a double
global AllValue;
val = str2double(get(handles.editDelay,'String'));
if isnan(val) || val == 0
    prompt = 'Invalid Delay!\nDelay returns to default!';
    errordlg(sprintf(prompt));
    AllValue.get.delay = 1;
    set(handles.editDelay,'String','1');
else
    AllValue.get.delay = val;
end



function editNum_Callback(hObject, eventdata, handles)
% hObject    handle to editNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNum as text
%        str2double(get(hObject,'String')) returns contents of editNum as a double
global AllValue;
val = str2double(get(handles.editNum,'String'));
if mod(val,1) ~= 0 || val == 0
    prompt = 'Invalid Num!\nNum returns to default!';
    errordlg(sprintf(prompt));
    AllValue.get.num = 1;
    set(handles.editNum,'String','1');
else
    AllValue.get.num = val;
end



function editGain_Callback(hObject, eventdata, handles)
% hObject    handle to editGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGain as text
%        str2double(get(hObject,'String')) returns contents of editGain as a double
global AllValue;
val = str2double(get(handles.editGain,'String'));
if mod(val,1) ~= 0 || val == 0
    prompt = 'Invalid Gain!\nGain returns to default!';
    errordlg(sprintf(prompt));
    AllValue.get.gain = 1;
    set(handles.editGain,'String','1');
else
    AllValue.get.gain = val;
end



% --- Executes on key press with focus on editDelay and none of its controls.
function editDelay_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editDelay (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'return')
    uicontrol(handles.textGain);
end

% --- Executes on key press with focus on editNum and none of its controls.
function editNum_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editNum (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'return')
    uicontrol(handles.textGain);
end


% --- Executes on key press with focus on editGain and none of its controls.
function editGain_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editGain (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'return')
    uicontrol(handles.textGain);
end


% --- Executes on button press in btnProp.
function btnProp_Callback(hObject, eventdata, handles)
% hObject    handle to btnProp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
cd(AllValue.folder.lib);
Properties;
uiwait(Properties);
cd ../;

grid(AllValue.plot.grid);
if ~isempty(AllValue.value.raw)
    showValue(handles);
else
    btnHandleValue(handles,'off');
    cla(handles.plotValue);
    set(handles.tableValue,'Data',cell(4,length(AllValue.valueSet.fullName)))
end

setName(handles);


function setName(handles)
global AllValue;
set(handles.popName,'String',AllValue.valueSet.fullName(2:end));
handles.tableValue.ColumnName = {};
for c = 1:length(AllValue.valueSet.fullName)
    fullName = AllValue.valueSet.fullName{c};
    openOp = find(fullName==40);
    closeOp = find(fullName==41);
    name = fullName(1:openOp-2);
    unit = fullName(openOp+1:closeOp-1);
    handles.tableValue.ColumnName(c) = {[upper(name),'(',unit,')']};
end



function showValue(handles)
global AllValue;
AllValue.value.processed = AllValue.value.raw;
if strcmp(AllValue.calib.status,'on')
    for c = 1:length(AllValue.valueSet.fullName)-1
        x0 = AllValue.calib.x0(logical(AllValue.calib.check(:,c)),c);
        y0 = AllValue.calib.y0(logical(AllValue.calib.check(:,c)),c);
        if ~isempty(x0)
            AllValue.value.processed(:,c+1) = Calib(AllValue.value.raw(:,c+1),x0,y0,AllValue.calib.type);
        end
    end
end
value = AllValue.value.processed;

spec = [AllValue.plot.LS.val,AllValue.plot.mark.val];
cla(handles.plotValue);
for i = 2:length(AllValue.valueSet.fullName)
    plot(handles.plotValue,value(:,1),value(:,i),spec,...
        'LineWidth',AllValue.plot.LW,'DisplayName',AllValue.valueSet.fullName{i});
end
handles.tableValue.Data = value(end:-1:1,:);



% --- Executes on button press in btnAcqr.
function btnAcqr_Callback(hObject, eventdata, handles)
% hObject    handle to btnAcqr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
if strcmp(hObject.String,'Acquire')
    btnWhileConnect(handles,'off');
    set(handles.editSend,'Enable','on');
    set(hObject,'Enable','on');
    set(hObject,'String','Stop');

    set(AllValue.time,'Period',AllValue.get.delay);
    set(AllValue.time,'TasksToExecute',AllValue.get.num);
    if isempty(AllValue.value.raw)
        AllValue.time.UserData = 0;
    else
        AllValue.time.UserData = AllValue.value.raw(end,1);
    end

    % Flush buffer
    AllValue.check.start = 1;
    fread(AllValue.serial, AllValue.serial.BytesAvailable);
else
    btnWhileConnect(handles,'on');
    set(handles.btnAcqr,'String','Acquire');
    if ~isempty(AllValue.value.raw)
        btnHandleValue(handles,'on');
    end
    AllValue.check.read = 0;
    AllValue.serial.UserData.count = 0;
    if isequal(AllValue.time.Running,'on')
        stop(AllValue.time);
    end
end


function receiveSignal(handles)
global AllValue;

if AllValue.check.read % while serial read
    AllValue.check.read = 0; % pause bytes come in
    for c = 1:length(AllValue.valueSet.form)
        value = fscanf(AllValue.serial,AllValue.valueSet.form{c});
        AllValue.serial.UserData.ac = [AllValue.serial.UserData.ac;value];
        if c == length(AllValue.valueSet.form)
            AllValue.check.ready = 1; % timer full start
            AllValue.serial.UserData.val = AllValue.serial.UserData.ac;
            AllValue.serial.UserData.ac = [];
            AllValue.check.read = 1; %resume bytes come in
        end
    end

    if AllValue.serial.UserData.count == AllValue.get.num % All read is done
        btnWhileConnect(handles,'on');
        set(handles.btnAcqr,'String','Acquire');
        if ~isempty(AllValue.value.raw)
            btnHandleValue(handles,'on');
        end
        AllValue.check.read = 0; % stop serial read
        AllValue.serial.UserData.count = 0;
    end
end

if AllValue.check.time && AllValue.check.ready % while timer start
    start(AllValue.time);
    AllValue.check.time = 0; % disable timer start
end

if AllValue.check.start % while flushing buffer
    AllValue.check.read = 1; % serial start to read
    AllValue.check.time = 1; % timer half start
    AllValue.check.start = 0; % disable buffer flushing
    AllValue.serial.UserData.count = 0;
end  



function readFcn(handles)
global AllValue;
try
    AllValue.time.UserData = AllValue.time.UserData + AllValue.get.delay;
    value = transpose(AllValue.serial.UserData.val);
    value = value * AllValue.get.gain;
    AllValue.value.raw = [AllValue.value.raw;AllValue.time.UserData,value];
    showValue(handles);
    AllValue.check.change = 1;
catch
    disp(['Recive ',AllValue.serial.UserData.val,' at ',num2str(AllValue.time.UserData),'s!']);
end
AllValue.serial.UserData.count = AllValue.serial.UserData.count + 1;



function serialTimer(handles)
global AllValue;
if isempty(seriallist)
    errordlg('The process stops as you unplugged the device, perhap!');
    fclose(AllValue.serial);
    if isequal(AllValue.time.Running,'on')
        stop(AllValue.time);
    end
    if AllValue.check.calib
        close(Calibration);
        AllValue.check.calib = 0;
    end
    btnOff(handles);
    btnWhileConnect(handles,'off');
    set(handles.btnAcqr,'String','Acquire');
end


% --- Executes on button press in btnSend.
function btnSend_Callback(hObject, eventdata, handles)
% hObject    handle to btnSend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
fprintf(AllValue.serial,[handles.str,'\']);
set(handles.btnSend,'Enable','off');
set(handles.editSend,'String','');
handles.str = '';
guidata(hObject,handles);


% --- Executes on key press with focus on editSend and none of its controls.
function editSend_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editSend (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
key = eventdata.Key;
if strcmp(key,'backspace') && ~isempty(handles.str)
    handles.str = handles.str(1:end-1);
    guidata(hObject,handles);
elseif strcmp(key,'return')
    uicontrol(handles.btnSend);
    btnSend_Callback(handles.btnSend, eventdata, handles);
    handles.str = '';
elseif ~isempty(eventdata.Character) && ~strcmp(key,'backspace')
    handles.str = [handles.str,eventdata.Character];
    guidata(hObject,handles);
end

if isempty(handles.str) 
    set(handles.btnSend,'Enable','off');
else
    set(handles.btnSend,'Enable','on');
end



% --- Executes on button press in btnCalib.
function btnCalib_Callback(hObject, eventdata, handles)
% hObject    handle to btnCalib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
cd(AllValue.folder.lib);
Calibration;
AllValue.check.calib = 1;
uiwait(Calibration);
AllValue.check.calib = 0;
cd ../;
