function varargout = Load(varargin)
% LOAD MATLAB code for Load.fig
%      LOAD, by itself, creates a new LOAD or raises the existing
%      singleton*.
%
%      H = LOAD returns the handle to a new LOAD or the handle to
%      the existing singleton*.
%
%      LOAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOAD.M with the given input arguments.
%
%      LOAD('Property','Value',...) creates a new LOAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Load_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Load_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Load

% Last Modified by GUIDE v2.5 27-Nov-2020 23:57:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Load_OpeningFcn, ...
                   'gui_OutputFcn',  @Load_OutputFcn, ...
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


% --- Executes just before Load is made visible.
function Load_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Load (see VARARGIN)

% Choose default command line output for Load
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Load wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global AllValue;
cd ../;
list = dir(AllValue.folder.saveFolder);
cd(AllValue.folder.lib);

handles.list = char(list(3:end).name);
set(handles.listFile,'String',handles.list);
handles.str = '';
guidata(hObject,handles);



% --- Outputs from this function are returned to the command line.
function varargout = Load_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnLoad.
function btnLoad_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global AllValue;
file = get(handles.editFile,'String');
fileList = get(hObject,'String');
if isempty(fileList) || isempty(file)
    errordlg('Name File Invalid!');
else
    cd ../;
    cd(AllValue.folder.saveFolder);
    [val,name] = xlsread(file);
    cd ../;
    cd(AllValue.folder.lib);
    if ~isempty(val)
        AllValue.value.raw = val;
        if length(name) > 1
            AllValue.valueSet.fullName = name;
            AllValue.check.change = 0;
            AllValue.check.load = 1;
            AllValue.calib.check = [];
            AllValue.calib.x0 = [];
            AllValue.calib.y0 = [];
            closereq;
        else
            errordlg('Name Shortage!');
        end
    else
        errordlg('Data Is Empty!');
    end
end



% --- Executes on selection change in listFile.
function listFile_Callback(hObject, eventdata, handles)
% hObject    handle to listFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listFile contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listFile
fileList = get(hObject,'String');
fileIndex = get(hObject,'Value');
file_1 = fileList(fileIndex,:);
if ismember(' ',file_1)
    endName = find(file_1 == ' ');
    file = file_1(1:endName(1)-1);
else
    file = file_1;
end
set(handles.editFile,'String',file);



% --- Executes on key press with focus on editFile and none of its controls.
function editFile_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editFile (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
key = eventdata.Key;
if strcmp(key,'backspace') && ~isempty(handles.str)
    handles.str = handles.str(1:end-1);
elseif ~isempty(eventdata.Character) && ~strcmp(key,'backspace')
    handles.str = [handles.str,eventdata.Character];
end
if isempty(handles.str)
    newList = handles.list;
else
    list = handles.list;
    newList = list(startsWith(string(handles.list),handles.str),:);
end
set(handles.listFile,'String',newList);
guidata(hObject,handles);




% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
key = eventdata.Key;
if isequal(key,'return')
    pause(0.01);
    btnLoad_Callback(handles.btnLoad,eventdata,handles);
end
if isequal(key,'escape')
    closereq;
end
