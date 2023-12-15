function varargout = project(varargin)
% PROJECT MATLAB code for project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project

% Last Modified by GUIDE v2.5 15-Dec-2023 03:21:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_OpeningFcn, ...
                   'gui_OutputFcn',  @project_OutputFcn, ...
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
function project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project (see VARARGIN)

% Choose default command line output for project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
function varargout = project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global originImage
[fileName, path] = uigetfile({'*.jpg;*.png', 'Image Files'});
if fileName ~= 0
    originImage = imread(fullfile(path, fileName));
    axes(handles.axes1);
    imshow(originImage)
    title('Origin Image');
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
global originImage 
grayImage = rgb2gray(originImage);
noisyImage = imnoise(grayImage, 'salt & pepper', 0.02);

if handles.popupmenu1.Value == 1
    k = edge(grayImage, 'sobel',0.0234);
    text = 'Sobel Edge Detection';
    result = k;
    
elseif handles.popupmenu1.Value == 2
    k = edge(grayImage, 'prewitt',0.0234);
    text = 'Prewitt Edge Detection';
    result = k;
    
elseif handles.popupmenu1.Value == 3
    text = 'Noisy Image';
    result = noisyImage;
    
elseif handles.popupmenu1.Value == 4
    denoisedImage = medfilt2(noisyImage, [3, 3]);
    text = 'Denoised Image';
    result = denoisedImage;
    
elseif handles.popupmenu1.Value == 5
    logImage = edge(grayImage, 'log');
    text = 'Laplacian of Gaussian';
    result = logImage;
    
elseif handles.popupmenu1.Value == 6
    equalizedImage = histeq(grayImage);
    text = 'Histogram Equalization';
    result = equalizedImage;
    
elseif handles.popupmenu1.Value == 7
    edgeImage = edge(grayImage, 'canny');
    text = 'Canny Edge Detection';
    result = edgeImage;
    
end
axes(handles.axes2);
imshow(result)
title(text);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
