function varargout = project2(varargin)
% PROJECT2 MATLAB code for project2.fig
%      PROJECT2, by itself, creates a new PROJECT2 or raises the existing
%      singleton*.
%
%      H = PROJECT2 returns the handle to a new PROJECT2 or the handle to
%      the existing singleton*.
%
%      PROJECT2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT2.M with the given input arguments.
%
%      PROJECT2('Property','Value',...) creates a new PROJECT2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project2

% Last Modified by GUIDE v2.5 15-Dec-2023 21:41:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project2_OpeningFcn, ...
                   'gui_OutputFcn',  @project2_OutputFcn, ...
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
% --- Executes just before project2 is made visible.
function project2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project2 (see VARARGIN)

% Choose default command line output for project2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% --- Outputs from this function are returned to the command line.
function varargout = project2_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global originImage 
grayImage = rgb2gray(originImage);
noisyImage = grayImage;

if handles.popupmenu1.Value == 1
    RGB = 0.2989*originImage(:,:,1) + 0.5870*originImage(:,:,2)+0.1140*originImage(:,:,3);
    C = double(RGB);
    for i=1:size(C, 1)-2
        for j = 1:size(C, 2)-2
           % x-direction
           GX =((2*C(i,j+1)+C(i,j)+C(i,j+2))-(2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2)));
           % y-direction
           GY =((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
            RGB(i,j) = sqrt(GX.^2 + GY.^2);
        end
    end
    text = 'Sobel Edge Detection';
    result = RGB;
    %------------------------------------------------------
elseif handles.popupmenu1.Value == 2
    prewittHorizontal = [-1 -1 -1; 0 0 0; 1 1 1];
    prewittVertical = [-1 0 1; -1 0 1; -1 0 1];
    gradientX = conv2(double(grayImage), prewittHorizontal, 'same');
    gradientY = conv2(double(grayImage), prewittVertical, 'same');
    gradientMagnitude = sqrt(gradientX.^2 + gradientY.^2);
    normalizedGradient = uint8((gradientMagnitude / max(gradientMagnitude(:))) * 255);
    
    text = 'Prewitt Edge Detection';
    result = normalizedGradient;
    %------------------------------------------------------
elseif handles.popupmenu1.Value == 3
    % Add salt-and-pepper noise manually
    noiseDensity = 0.02;
    % Generate random positions for salt noise
    saltPositions = rand(size(noisyImage)) < noiseDensity / 2;
    noisyImage(saltPositions) = 255; % Set salt noise to white (255)
    % Generate random positions for pepper noise
    pepperPositions = rand(size(noisyImage)) < noiseDensity / 2;
    noisyImage(pepperPositions) = 0; % Set pepper noise to black (0)
    noisyImage = uint8(noisyImage);
    
    text = 'Noisy Image';
    result = noisyImage;
    %------------------------------------------------------
elseif handles.popupmenu1.Value == 4
    denoisedImage = medfilt2(noisyImage, [3, 3]);
    text = 'Denoised Image';
    result = denoisedImage;
    %------------------------------------------------------
elseif handles.popupmenu1.Value == 5
    logFilter = fspecial('log', [5, 5], 0.5);
    edges = imfilter(double(grayImage), logFilter, 'symmetric', 'conv');
    % Normalize the result to the range [0, 255]
    normalizedEdges = uint8((edges - min(edges(:))) * (255 / (max(edges(:)) - min(edges(:)))));

    text = 'Laplacian of Gaussian';
    result = normalizedEdges;
    %------------------------------------------------------
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



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
