function varargout = Confirm(varargin)
% CONFIRM MATLAB code for Confirm.fig
%      CONFIRM, by itself, creates a new CONFIRM or raises the existing
%      singleton*.
%
%      H = CONFIRM returns the handle to a new CONFIRM or the handle to
%      the existing singleton*.
%
%      CONFIRM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIRM.M with the given input arguments.
%
%      CONFIRM('Property','Value',...) creates a new CONFIRM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Confirm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Confirm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Confirm

% Last Modified by GUIDE v2.5 29-Nov-2020 16:21:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Confirm_OpeningFcn, ...
                   'gui_OutputFcn',  @Confirm_OutputFcn, ...
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


% --- Executes just before Confirm is made visible.
function Confirm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Confirm (see VARARGIN)

% Choose default command line output for Confirm
handles.output = hObject;
handles.confirm = 1;
handles.out = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Confirm wait for user response (see UIRESUME)
% uiwait(handles.figure);
global AllValue;
set(hObject,'Name',AllValue.confirm);
if strcmp(AllValue.confirm,'Overwrite')
    set(handles.text,'String',sprintf('File already exists!\nWant to replace?'));
elseif strcmp(AllValue.confirm,'Keep data')
    set(handles.text,'String',sprintf('You haven''t save changes!\nSave it or Leave it?'));
end


% --- Outputs from this function are returned to the command line.
function varargout = Confirm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in btnYes.
function btnYes_Callback(hObject, eventdata, handles)
% hObject    handle to btnYes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.confirm = 1;
handles.out = 0;
guidata(hObject,handles);
closereq;


% --- Executes on button press in btnNo.
function btnNo_Callback(hObject, eventdata, handles)
% hObject    handle to btnNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.confirm = 2;
handles.out = 0;
guidata(hObject,handles);
closereq;


% --- Executes on key press with focus on figure or any of its controls.
function figure_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% Kiem tra phim chuc nang <- va -> de chon yes hoac no
key = eventdata.Key;
if isequal(key,'leftarrow')
    handles.confirm = 1;
    set(handles.btnYes,'BackgroundColor','c');
    set(handles.btnNo,'BackgroundColor','g');
end
if isequal(key,'rightarrow')
    handles.confirm = 2;
    set(handles.btnYes,'BackgroundColor','g');
    set(handles.btnNo,'BackgroundColor','c');
end
guidata(hObject,handles);

% Kiem tra phim chuc nang Enter(yes/no) va ESC(return)
if isequal(key,'escape')
    closereq;
end
if isequal(key,'return')
    handles.out = 0;
    guidata(hObject,handles);
    closereq;
end



% --- Executes during object deletion, before destroying properties.
function figure_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AllValue;
if strcmp(AllValue.confirm,'Overwrite') || strcmp(AllValue.confirm,'Keep data')
    if handles.out
        AllValue.check.save = 0;
    else
        AllValue.check.save = handles.confirm;
    end
end
