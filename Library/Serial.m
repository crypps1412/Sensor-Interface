function varargout = Serial(varargin)
%SERIAL MATLAB code file for Serial.fig
%      SERIAL, by itself, creates a new SERIAL or raises the existing
%      singleton*.
%
%      H = SERIAL returns the handle to a new SERIAL or the handle to
%      the existing singleton*.
%
%      SERIAL('Property','Value',...) creates a new SERIAL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Serial_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SERIAL('CALLBACK') and SERIAL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SERIAL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Serial

% Last Modified by GUIDE v2.5 03-Dec-2020 21:26:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Serial_OpeningFcn, ...
                   'gui_OutputFcn',  @Serial_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Serial is made visible.
function Serial_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Serial
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Serial wait for user response (see UIRESUME)
% uiwait(handles.figure);
s = instrhwinfo('serial');
if isempty(s.SerialPorts)
    set(handles.btnSetUp,'Enable','off');
    set(handles.popPort,'Enable','off');
    set(handles.popBaud,'Enable','off');
    set(handles.textState,'String',sprintf('No device is plugged in!'));
else
    set(handles.popPort,'String',s.SerialPorts);
end


% --- Outputs from this function are returned to the command line.
function varargout = Serial_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnSetUp.
function btnSetUp_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;

% Lay cong COM
portList = get(handles.popPort,'String');
portIndex = get(handles.popPort,'Value');
port = char(portList(portIndex,:));
set(AllValue.serial,'Port',port);

% Lay BaudRate
baudList = get(handles.popBaud,'String');
baudIndex = get(handles.popBaud,'Value');
baudRate = str2double(char(baudList(baudIndex,:)));
set(AllValue.serial,'BaudRate',baudRate);

try
    fopen(AllValue.serial);
    set(handles.textState,'String','Success');
    AllValue.check.serial = 1;
    set(handles.popPort,'Enable','off');
    set(handles.popBaud,'Enable','off');
    closereq;
catch
    errordlg(sprintf('You have open serial port in somewhere else!\nArduino IDE for example.\nClose serial monitor before press Set up again!'));
end


% --- Executes on key press with focus on figure or any of its controls.
function figure_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if isequal(key,'escape')
    closereq;
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popPort.
function popPort_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.popPort,'Enable','on');
set(handles.popBaud,'Enable','on');
uicontrol(handles.popPort);
set(handles.textState,'String','');


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popBaud.
function popBaud_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popBaud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.popBaud,'Enable','on');
set(handles.popPort,'Enable','on');
uicontrol(handles.popBaud);
set(handles.textState,'String','');


% --- Executes on button press in btnSearch.
function btnSearch_Callback(hObject, eventdata, handles)
% hObject    handle to btnSearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = instrhwinfo('serial');
if isempty(s.SerialPorts)
    set(handles.btnSetUp,'Enable','off');
    set(handles.popPort,'Enable','off');
    set(handles.popBaud,'Enable','off');
    set(handles.textState,'String','No device is plugged in!');
    set(handles.popPort,'String','NO PORT');
else
    set(handles.btnSetUp,'Enable','on');
    set(handles.popPort,'Enable','on');
    set(handles.popBaud,'Enable','on');
    set(handles.popPort,'String',s.SerialPorts);
    set(handles.textState,'String','Found');
end
