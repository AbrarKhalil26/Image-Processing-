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

% Sobel Edge Detection
if handles.popupmenu1.Value == 1
   result = manualSobelEdgeDetection(originImage);
   text = 'Sobel Edge Detection';
    %------------------------------------------------------
% Prewitt Edge Detection
elseif handles.popupmenu1.Value == 2
    result = manualPrewittEdgeDetection(originImage);
    text = 'Prewitt Edge Detection';
    %------------------------------------------------------
% Add salt-and-papper noise
elseif handles.popupmenu1.Value == 3
    result = addSaltAndPepperNoise(noisyImage, 0.02);
    text = 'Noisy Image';
    %------------------------------------------------------
% Denoised Image Using Median Filter 
elseif handles.popupmenu1.Value == 4
    denoisedImage = medfilt2(noisyImage, [3, 3]);
    text = 'Denoised Image';
    result = denoisedImage;
    %------------------------------------------------------
% Laplacian of Gaussian 
elseif handles.popupmenu1.Value == 5
    result = manualLaplacianOfGaussian(grayImage);
    text = 'Laplacian of Gaussian';
    %------------------------------------------------------
% Histogram Equialization
elseif handles.popupmenu1.Value == 6
    result = manualHistogramEqualization(grayImage);
    text = 'Histogram Equalization';
    %------------------------------------------------------
% Canny Edge Detection
elseif handles.popupmenu1.Value == 7
    result = manualCannyEdgeDetection(grayImage);
    text = 'Canny Edge Detection';
    
end
axes(handles.axes2);
imshow(result)
title(text);

function result = manualSobelEdgeDetection(image)
    % Sobel Edge Detection
    RGB = 0.2989 * image(:,:,1) + 0.5870 * image(:,:,2) + 0.1140 * image(:,:,3);
    C = double(RGB);
    for i = 1:size(C, 1) - 2
        for j = 1:size(C, 2) - 2
            % x-direction
            GX = ((2 * C(i, j + 1) + C(i, j) + C(i, j + 2)) - (2 * C(i + 2, j + 1) + C(i + 2, j) + C(i + 2, j + 2)));
            % y-direction
            GY = ((2 * C(i + 1, j + 2) + C(i, j + 2) + C(i + 2, j + 2)) - (2 * C(i + 1, j) + C(i, j) + C(i + 2, j)));
            RGB(i, j) = sqrt(GX.^2 + GY.^2);
        end
    end
    result = RGB;
    
function result = manualPrewittEdgeDetection(image)
    % Convert image to grayscale
    grayImage = rgb2gray(image);

    % Prewitt Edge Detection
    prewittHorizontal = [-1 -1 -1; 0 0 0; 1 1 1];
    prewittVertical = [-1 0 1; -1 0 1; -1 0 1];
    gradientX = conv2(double(grayImage), prewittHorizontal, 'same');
    gradientY = conv2(double(grayImage), prewittVertical, 'same');
    gradientMagnitude = sqrt(gradientX.^2 + gradientY.^2);
    normalizedGradient = uint8((gradientMagnitude / max(gradientMagnitude(:))) * 255);

    result = normalizedGradient;

function result = addSaltAndPepperNoise(image, density)
    % Add salt-and-pepper noise manually
    noiseDensity = density;
    
    % Generate random positions for salt noise
    saltPositions = rand(size(image)) < noiseDensity / 2;
    image(saltPositions) = 255; % Set salt noise to white (255)
    
    % Generate random positions for pepper noise
    pepperPositions = rand(size(image)) < noiseDensity / 2;
    image(pepperPositions) = 0; % Set pepper noise to black (0)
    
    result = uint8(image); 

function result = manualLaplacianOfGaussian(image)
    % Gaussian smoothing
    hsize = 5;
    sigma = 1.4;
    gaussianFilter = fspecial('gaussian', hsize, sigma);
    smoothedImage = imfilter(double(image), gaussianFilter);

    % Laplacian of Gaussian filter
    logFilter = fspecial('log', hsize, sigma);
    
    % Apply the Laplacian of Gaussian filter
    edges = conv2(smoothedImage, logFilter, 'same');

     % Adjust threshold to get binary edge map
    threshold = 0.5; % You may need to adjust this threshold
    binaryEdges = edges > threshold;

    result = uint8(binaryEdges * 255);
    
function result = manualHistogramEqualization(grayImage)
    [counts, ~] = imhist(grayImage);
    cdf = cumsum(counts) / sum(counts);
    result = uint8(255 * cdf(grayImage + 1));

function result = manualCannyEdgeDetection(grayImage)
 % Gaussian smoothing
    hsize = 5;
    sigma = 1.4;
    gaussianFilter = fspecial('gaussian', hsize, sigma);
    smoothedImage = imfilter(double(grayImage), gaussianFilter, 'symmetric');

    % Gradient calculation (Sobel operators)
    sobelFilterX = [-1 0 1; -2 0 2; -1 0 1];
    sobelFilterY = sobelFilterX';

    gradientX = conv2(smoothedImage, sobelFilterX, 'same');
    gradientY = conv2(smoothedImage, sobelFilterY, 'same');

    % Gradient magnitude and direction
    gradientMagnitude = sqrt(gradientX.^2 + gradientY.^2);
    gradientDirection = atan2d(gradientY, gradientX);

    % Non-maximum suppression
    edgeImage = zeros(size(grayImage));
    for i = 2:size(gradientMagnitude, 1) - 1
        for j = 2:size(gradientMagnitude, 2) - 1
            angle = gradientDirection(i, j);
            if (angle >= -22.5 && angle < 22.5) || (angle >= 157.5 || angle < -157.5)
                neighbor1 = gradientMagnitude(i, j + 1);
                neighbor2 = gradientMagnitude(i, j - 1);
            elseif (angle >= 22.5 && angle < 67.5) || (angle >= -157.5 && angle < -112.5)
                neighbor1 = gradientMagnitude(i - 1, j + 1);
                neighbor2 = gradientMagnitude(i + 1, j - 1);
            elseif (angle >= 67.5 && angle < 112.5) || (angle >= -112.5 && angle < -67.5)
                neighbor1 = gradientMagnitude(i - 1, j);
                neighbor2 = gradientMagnitude(i + 1, j);
            elseif (angle >= 112.5 && angle < 157.5) || (angle >= -67.5 && angle < -22.5)
                neighbor1 = gradientMagnitude(i - 1, j - 1);
                neighbor2 = gradientMagnitude(i + 1, j + 1);
            end

            if gradientMagnitude(i, j) >= neighbor1 && gradientMagnitude(i, j) >= neighbor2
                edgeImage(i, j) = gradientMagnitude(i, j);
            end
        end
    end

    % Edge tracking by hysteresis
    highThreshold = 0.2 * max(edgeImage(:));
    lowThreshold = 0.01 * max(edgeImage(:));

    strongEdges = edgeImage > highThreshold;
    weakEdges = (edgeImage >= lowThreshold) & (edgeImage <= highThreshold);

    % Use bwselect to connect weak edges to strong edges
    edgeImage = edgeImage .* (strongEdges | bwmorph(weakEdges, 'bridge'));

    result = uint8(edgeImage);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
