function varargout = Save(varargin)
% FIGURESAVE MATLAB code for figureSave.fig
%      FIGURESAVE, by itself, creates a new FIGURESAVE or raises the existing
%      singleton*.
%
%      H = FIGURESAVE returns the handle to a new FIGURESAVE or the handle to
%      the existing singleton*.
%
%      FIGURESAVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIGURESAVE.M with the given input arguments.
%
%      FIGURESAVE('Property','Value',...) creates a new FIGURESAVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before figureSave_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to figureSave_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help figureSave

% Last Modified by GUIDE v2.5 23-Nov-2020 16:58:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @figureSave_OpeningFcn, ...
                   'gui_OutputFcn',  @figureSave_OutputFcn, ...
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


% --- Executes just before figureSave is made visible.
function figureSave_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to figureSave (see VARARGIN)

% Choose default command line output for figureSave
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes figureSave wait for user response (see UIRESUME)
% uiwait(handles.figureSave);




% --- Outputs from this function are returned to the command line.
function varargout = figureSave_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in btnSave.
function btnSave_Callback(hObject, eventdata, handles)
% hObject    handle to btnSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;

% Lay ten file kem phan mo rong
tailList = get(handles.popTail,'String');
tailIndex = get(handles.popTail,'Value');
tail = char(tailList(tailIndex));
tailEnd = find(tail == ' ') - 1;

fileName = char(get(handles.editFile,'String'));

file = [fileName , tail(1:tailEnd)];

% Lay ten cac file co trong save folder, kiem tra xem exist
cd ../;
allFile = dir(AllValue.folder.saveFolder);
cd(AllValue.folder.lib);

AllValue.check.save = 1;
for i = 3:length(allFile)
	if strcmp(allFile(i).name,file)
        AllValue.confirm = 'Overwrite';
        Confirm;
        uiwait(Confirm);
        break;
    end
end

if AllValue.check.save == 1
    cd ../;
    cd(AllValue.folder.saveFolder);
    delete(file);
    xlswrite(file,[string(AllValue.valueSet.fullName);AllValue.value.raw]);
    cd ../;
    cd(AllValue.folder.lib);
    AllValue.check.change = 0;
    closereq;
end
            


% --- Executes on key press with focus on figureSave or any of its controls.
function figureSave_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figureSave (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% Kiem tra phim chuc nang Enter(save) va ESC(thoat)
key = eventdata.Key;
if isequal(key,'return')
    pause(0.1);
    btnSave_Callback(handles.btnSave, eventdata, handles);
end
if isequal(key,'escape')
    closereq;
end



% --- Executes on key press with focus on editFile and none of its controls.
function editFile_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editFile (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% Nhap chu vao editFile se enable nut save
key = eventdata.Key;
if strcmp(key,'backspace') && ~isempty(handles.str)
    handles.str = handles.str(1:end-1);
elseif ~isempty(eventdata.Character) && ~strcmp(key,'backspace')
    handles.str = [handles.str,eventdata.Character];
end
guidata(hObject,handles);
if isempty(handles.str)
    set(handles.btnSave,'Enable','off');
else
    set(handles.btnSave,'Enable','on');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over editFile.
function editFile_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to editFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Nhan lan dau vao editFile se enable
set(hObject,'Enable','on');
set(hObject,'String','');
set(hObject,'FontAngle','normal');
set(hObject,'HorizontalAlignment','left');
handles.str = '';
guidata(hObject,handles);
uicontrol(hObject);
