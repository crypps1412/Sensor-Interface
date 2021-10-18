function varargout = Properties(varargin)
% PROPERTIES MATLAB code for Properties.fig
%      PROPERTIES, by itself, creates a new PROPERTIES or raises the existing
%      singleton*.
%
%      H = PROPERTIES returns the handle to a new PROPERTIES or the handle to
%      the existing singleton*.
%
%      PROPERTIES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROPERTIES.M with the given input arguments.
%
%      PROPERTIES('Property','Value',...) creates a new PROPERTIES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Properties_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Properties_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Properties

% Last Modified by GUIDE v2.5 01-Dec-2020 10:48:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Properties_OpeningFcn, ...
                   'gui_OutputFcn',  @Properties_OutputFcn, ...
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


% --- Executes just before Properties is made visible.
function Properties_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Properties (see VARARGIN)

% Choose default command line output for Properties
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Properties wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global AllValue;
handles.valueSet.form = AllValue.valueSet.form;
handles.valueSet.fullName = AllValue.valueSet.fullName(2:end);
handles.valueSet.numF = length(handles.valueSet.fullName);
handles.plot.LS.val = AllValue.plot.LS.val;
handles.plot.LS.id = AllValue.plot.LS.id;
handles.plot.mark.val = AllValue.plot.mark.val;
handles.plot.mark.id = AllValue.plot.mark.id;
handles.numValue = length(handles.valueSet.fullName);
guidata(hObject,handles);

form = '';
for c = 1:length(handles.valueSet.form)
    form = [form,handles.valueSet.form{c},'\'];
end
set(handles.editForm,'String',form);
set(handles.listFullName,'String',handles.valueSet.fullName);
set(handles.popLS,'Value',handles.plot.LS.id);
set(handles.popMark,'Value',handles.plot.mark.id);

set(handles.editLW,'String',num2str(AllValue.plot.LW));
if strcmp(AllValue.plot.grid,'on')
    set(handles.checkGrid,'Value',1);
end



% --- Outputs from this function are returned to the command line.
function varargout = Properties_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editForm_Callback(hObject, eventdata, handles)
% hObject    handle to editForm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editForm as text
%        str2double(get(hObject,'String')) returns contents of editForm as a double
form = char(get(hObject,'String'));
enter = find(form == '\');
numF = strfind(form,'%f');
numEnd = length(enter);
handles.valueSet.numF = length(numF);
handles.valueSet.form = {};
handles.valueSet.form(1) = {form(1:enter(1)-1)};
for c = 2:numEnd
    handles.valueSet.form(c) = {form(enter(c-1)+1:enter(c)-1)};
end
guidata(hObject,handles);



% --- Executes on key press with focus on editForm and none of its controls.
function editForm_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editForm (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if isequal(eventdata.Key,'return')
    uicontrol(handles.textForm);
end


% --- Executes on button press in btnHelp.
function btnHelp_Callback(hObject, eventdata, handles)
% hObject    handle to btnHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Help;
uiwait(Help);


% --- Executes on key press with focus on editUnit and none of its controls.
function editUnit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editUnit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'backspace') || ~isempty(eventdata.Character)
    set(handles.btnDelete,'Enable','off');
end
if isequal(eventdata.Key,'return')
    uicontrol(handles.textForm);
end


% --- Executes on key press with focus on editVN and none of its controls.
function editVN_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editVN (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'backspace') || ~isempty(eventdata.Character)
    set(handles.btnDelete,'Enable','off');
end
if isequal(eventdata.Key,'return')
    uicontrol(handles.textForm);
end


% --- Executes on button press in btnAdd.
function btnAdd_Callback(hObject, eventdata, handles)
% hObject    handle to btnAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name = get(handles.editVN,'String');
unit = get(handles.editUnit,'String');
if isempty(name) 
    name = 'Volt';
end
if isempty(unit)
    unit = 'V';
end
fullName = [name ' (' unit ')'];
handles.numValue = handles.numValue + 1;
handles.valueSet.fullName(handles.numValue) = {fullName};


set(handles.listFullName,'String',char(handles.valueSet.fullName));
changeBtn(handles,'off');
set(handles.editVN,'String','');
set(handles.editUnit,'String','');

guidata(hObject,handles);


function changeBtn(handles,status)
set(handles.btnDelete,'Enable',status);
set(handles.btnUpdate,'Enable',status);



% --- Executes on button press in btnDelete.
function btnDelete_Callback(hObject, eventdata, handles)
% hObject    handle to btnDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
deleteId = get(handles.listFullName,'Value');
handles.valueSet.fullName(deleteId) = [];
handles.numValue = handles.numValue - 1;

set(handles.listFullName,'String',char(handles.valueSet.fullName));
set(handles.listFullName,'Value',1);
changeBtn(handles,'off');
set(handles.editVN,'String','');
set(handles.editUnit,'String','');

guidata(hObject,handles);



% --- Executes on button press in btnUpdate.
function btnUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to btnUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name = get(handles.editVN,'String');
unit = get(handles.editUnit,'String');
if isempty(name) || isempty(unit)
    name = 'Volt';
    unit = 'V';
end
fullName = [name ' (' unit ')'];
updateId = get(handles.listFullName,'Value');
handles.valueSet.fullName(updateId) = {fullName};

set(handles.listFullName,'String',char(handles.valueSet.fullName));
changeBtn(handles,'off');
set(handles.editVN,'String','');
set(handles.editUnit,'String','');

guidata(hObject,handles);



% --- Executes on selection change in listFullName.
function listFullName_Callback(hObject, eventdata, handles)
% hObject    handle to listFullName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listFullName contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listFullName
nameList = get(hObject,'String');
nameId = get(hObject,'Value');
fullName = char(nameList(nameId,:));
openOp = find(fullName==40);
closeOp = find(fullName==41);
name = fullName(1:openOp-2);
unit = fullName(openOp+1:closeOp-1);

changeBtn(handles,'on');
set(handles.editVN,'String',name);
set(handles.editUnit,'String',unit);


% --- Executes on button press in btnResetValueSet.
function btnResetValueSet_Callback(hObject, eventdata, handles)
% hObject    handle to btnResetValueSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.valueSet.fullName = {'Volt (V)'};
handles.numValue = 2;

set(handles.listFullName,'String','Volt (V)');
set(handles.listFullName,'Value',1);
changeBtn(handles,'off');

guidata(hObject,handles);




% --- Executes on selection change in popLS.
function popLS_Callback(hObject, eventdata, handles)
% hObject    handle to popLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLS
handles.plot.LS.id = get(hObject,'Value');
switch handles.plot.LS.id
    case 2
        handles.plot.LS.val = '-';
    case 3
        handles.plot.LS.val = '--';
	case 4
        handles.plot.LS.val = ':';
    case 5
        handles.plot.LS.val = '-.';
    otherwise
        handles.plot.LS.val = '';
end
guidata(hObject,handles);



% --- Executes on selection change in popMark.
function popMark_Callback(hObject, eventdata, handles)
% hObject    handle to popMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMark contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMark
handles.plot.mark.id = get(hObject,'Value');
switch handles.plot.mark.id
    case 2
        handles.plot.mark.val = '.';
    case 3
        handles.plot.mark.val = '*';
	case 4
        handles.plot.mark.val = 'o';
    case 5
        handles.plot.mark.val = 'd';
    otherwise
        handles.plot.mark.val = '';
end
guidata(hObject,handles);


function editLW_Callback(hObject, eventdata, handles)
% hObject    handle to editLW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLW as text
%        str2double(get(hObject,'String')) returns contents of editLW as a double
val = str2double(get(hObject,'String'));
if mod(val,1) == 0
    handles.valueSet.form = val;
else
    errordlg('Invalid Line Width!');
    handles.plot.LW = 1;
    set(hObject,'String','1');
end
guidata(hObject,handles);


% --- Executes on key press with focus on editLW and none of its controls.
function editLW_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editLW (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if isequal(eventdata.Key,'return')
    uicontrol(handles.textForm);
end


% --- Executes on button press in btnResetPlot.
function btnResetPlot_Callback(hObject, eventdata, handles)
% hObject    handle to btnResetPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot.LS.val = '-';
handles.plot.LS.id = 2;
handles.plot.mark.val = '';
handles.plot.mark.id = 1;

set(handles.popLS,'Value',2);
set(handles.popMark,'Value',1);
set(handles.editLW,'String','1');
set(handles.checkGrid,'Value',0);

guidata(hObject,handles);



% --- Executes on button press in btnResetData.
function btnResetData_Callback(hObject, eventdata, handles)
% hObject    handle to btnResetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
AllValue.value.raw = [];
AllValue.value.processed = [];
AllValue.check.change = 0;


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;

if isempty(handles.valueSet.form)
    prompt = 'Invalid Format!\nFormat returns to default!';
    errordlg(sprintf(prompt));
    handles.valueSet.form = {'%f\'};
end
if isempty(handles.listFullName)
    prompt = 'Invalid Value Name!\nValue name returns to default!';
    errordlg(sprintf(prompt));
    handles.valueSet.fullName = {'Volt (V)'};
    handles.numValue = 2;
end
LW = str2double(get(handles.editLW,'String'));
if isempty(LW) || isnan(LW) || LW == 0
    prompt = 'Invalid Line Width!\nLine width returns to default!';
    errordlg(sprintf(prompt));
    LW = 1;
end
if handles.valueSet.numF ~= handles.numValue
    errordlg(sprintf('The number of vars is not the same!\nSome changes have been made.'));
    if handles.numValue > handles.valueSet.numF
        fullName = handles.valueSet.fullName(1:handles.valueSet.numF);
    else
        fullName = cell(1,handles.valueSet.numF);
        fullName(:) = {'Volt (V)'};
        fullName(1:handles.numValue) = handles.valueSet.fullName;
    end
    handles.numValue = handles.valueSet.numF;
    handles.valueSet.fullName = fullName;
end
    
AllValue.valueSet.form = handles.valueSet.form;
n = handles.numValue;
if ~isempty(AllValue.calib.check) && ~isempty(AllValue.value.raw)
    if n < length(AllValue.valueSet.fullName)-1
        AllValue.value.raw = AllValue.value.raw(:,1:n);
        AllValue.calib.x0 = AllValue.calib.x0(:,1:n);
        AllValue.calib.y0 = AllValue.calib.y0(:,1:n);
        AllValue.calib.check = AllValue.calib.check(:,1:n);
    elseif n > length(AllValue.valueSet.fullName)-1
        value = zeros(size(AllValue.value.raw,1),n);
        value(:,1:size(AllValue.value.raw,2)) = AllValue.calib.x0;
        AllValue.calib.x0 = value;
        value(:,1:size(AllValue.value.raw,2)) = AllValue.calib.y0;
        AllValue.calib.y0 = value;
        value(:,1:size(AllValue.value.raw,2)) = AllValue.calib.check;
        AllValue.calib.check = value;
        value(:,1:size(AllValue.value.raw,2)) = AllValue.value.raw;
        AllValue.value.raw = value;
    end
end
AllValue.valueSet.fullName(2:n+1) = handles.valueSet.fullName;
AllValue.plot.LS.val = handles.plot.LS.val;
AllValue.plot.LS.id = handles.plot.LS.id;
AllValue.plot.mark.val = handles.plot.mark.val;
AllValue.plot.mark.id = handles.plot.mark.id;

AllValue.plot.LW = LW;
if handles.checkGrid.Value
    AllValue.plot.grid = 'on';
else
    AllValue.plot.grid = 'off';
end
