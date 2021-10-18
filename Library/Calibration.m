function varargout = Calibration(varargin)
% CALIBRATION MATLAB code for Calibration.fig
%      CALIBRATION, by itself, creates a new CALIBRATION or raises the existing
%      singleton*.
%
%      H = CALIBRATION returns the handle to a new CALIBRATION or the handle to
%      the existing singleton*.
%
%      CALIBRATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATION.M with the given input arguments.
%
%      CALIBRATION('Property','Value',...) creates a new CALIBRATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Calibration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calibration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Calibration

% Last Modified by GUIDE v2.5 27-Dec-2020 22:26:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calibration_OpeningFcn, ...
                   'gui_OutputFcn',  @Calibration_OutputFcn, ...
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


% --- Executes just before Calibration is made visible.
function Calibration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Calibration (see VARARGIN)

% Choose default command line output for Calibration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Calibration wait for user response (see UIRESUME)
% uiwait(handles.figure);
global AllValue;
handles.type = AllValue.calib.type;
handles.x0 = AllValue.calib.x0;
handles.y0 = AllValue.calib.y0;
handles.check = AllValue.calib.check;
handles.status = AllValue.calib.status;
handles.fullName = AllValue.valueSet.fullName(2:end);
handles.str = '';
guidata(hObject,handles);

if find(handles.check)
    showData(handles,1);
else
    handles.table.Data = [];
end
if strcmp(handles.status,'on')
    set(handles.btnOn,'String','Calib: ON');
else
    set(handles.btnOn,'String','Calib: OFF');
end
set(handles.popName,'String',handles.fullName);
if strcmp(handles.type,'Lagrange')
    set(handles.popType,'Value',3);
elseif strcmp(handles.type,'Linear')
    set(handles.popType,'Value',2);
end

hold on;
zoom on;
title('Sensor Plot','Color','w');
xlabel('Received','Color','w');
ylabel('Calibrated','Color','w');
handles.ax.XColor = 'w';
handles.ax.YColor = 'w';


% --- Outputs from this function are returned to the command line.
function varargout = Calibration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnOn.
function btnOn_Callback(hObject, eventdata, handles)
% hObject    handle to btnOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.String,'Calib: OFF')
    if isempty(handles.x0)
        errordlg('Don''t have any data to calibrate!');
    else
        set(hObject,'String','Calib: ON');
        handles.status = 'on';
    end
else
    set(hObject,'String','Calib: OFF');
    handles.status = 'off';
end
guidata(hObject,handles);


% --- Executes on button press in btnReset.
function btnReset_Callback(hObject, eventdata, handles)
% hObject    handle to btnReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.x0 = [];
handles.y0 = [];
handles.check = [];
guidata(hObject,handles);
showData(handles,get(handles.popName,'Value'));


% --- Executes on selection change in popName.
function popName_Callback(hObject, eventdata, handles)
% hObject    handle to popName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popName contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popName
showData(handles,get(hObject,'Value'));


% --- Executes on button press in btnGet.
function btnGet_Callback(hObject, eventdata, handles)
% hObject    handle to btnGet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
if AllValue.serial.BytesAvailable
    fread(AllValue.serial, AllValue.serial.BytesAvailable);
    try
        fullValue = zeros(length(AllValue.valueSet.form),1);
        for c = 1:length(AllValue.valueSet.form)
            value = fscanf(AllValue.serial,AllValue.valueSet.form{c});
            if c == 1
                fullValue = zeros(length(AllValue.valueSet.form),length(value));
            end
            fullValue(c,:) = transpose(value);
        end
        handles.x0 = [handles.x0;fullValue];
        newRow = zeros(1,length(fullValue));
        handles.y0 = [handles.y0;newRow];
        handles.check = [handles.check;newRow];
        guidata(hObject,handles);
    catch
        disp('Recive other stuff!');
    end
    showData(handles,get(handles.popName,'Value'));
else
    errordlg('Don''t have anything to read!');
end


% --- Executes when entered data in editable cell(s) in table.
function table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
id = get(handles.popName,'Value');
ind = eventdata.Indices;
edit = eventdata.EditData;
similar = find(handles.x0(1:end-1,id) == handles.x0(end,id));
if isempty(edit)
    handles.x0(ind(1),id) = 0;
    handles.y0(ind(1),id) = 0;
    handles.check(ind(1),id) = 0;
elseif isnan(str2double(edit))
    errordlg('Data has to be number!');
else
    if ~isempty(similar) && handles.y0(similar(1)) ~= str2double(edit)
        errordlg('ONE X CAN NOT HAVE MANY Y!');
    else
        handles.y0(ind(1),id) = str2double(edit);
        handles.check(ind(1),id) = 1;
    end
end
guidata(hObject,handles);
showData(handles, id);


function showData(handles, id)
if ~isempty(handles.x0)
    x0 = handles.x0(logical(handles.check(:,id)),id);
    y0 = handles.y0(logical(handles.check(:,id)),id);
    value = [handles.x0(:,id),handles.y0(:,id),handles.check(:,id)];
    cla(handles.ax);
    if ~isempty(x0)
        if strcmp(handles.type,'Exact')
            plot(handles.ax,x0,y0,'*--');
        else
            x = transpose(linspace(min(x0),max(x0),100));
            y = Calib(x,x0,y0,handles.type);
            plot(handles.ax,x,y,'-');
            plot(handles.ax,x0,y0,'*');
        end
    end
    handles.table.Data = value;
else
    cla(handles.ax);
    handles.table.Data = [];
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


% --- Executes on selection change in popType.
function popType_Callback(hObject, eventdata, handles)
% hObject    handle to popType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popType
handles.type = hObject.String{hObject.Value};
guidata(hObject,handles);
showData(handles,get(handles.popName,'Value'));


% --- Executes during object deletion, before destroying properties.
function figure_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
col = size(handles.x0,2);
if ~isempty(handles.x0)
    m = [handles.x0,handles.y0,handles.check];
    m = m(any(m,2),:);
    handles.x0 = m(:,1:col);
    handles.y0 = m(:,col+1:2*col);
    handles.check = m(:,2*col+1:3*col);
end
AllValue.calib.type = handles.type;
AllValue.calib.x0 = handles.x0;
AllValue.calib.y0 = handles.y0;
AllValue.calib.check = handles.check;
AllValue.calib.status = handles.status;
AllValue.valueSet.fullName = [{'Time (t)'},handles.fullName];
