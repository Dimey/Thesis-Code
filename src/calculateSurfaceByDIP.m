 function [surface,sensitivity] = calculateSurfaceByDIP(varargin)
%CALCULATESURFACEBYDIP Calculate surface of cylindric objects
%   SURFACE = CALCULATESURFACEBYDIP(IMAGE) calculates the surface of cylindric
%   objects in the input image IMAGE. IMAGE can be a grayscale, RGB or
%   binary image. SURFACE is calculated by the position of found circles,
%   the default cylinder height of 24 micrometers and the default scale
%   factor of 1/142 micrometers per pixel.
%
%   [SURFACE, SENSITIVITY] = CALCULATESURFACEBYDIP(IMAGE) returns the
%   determined SENSITIVITY used for locating circle positions. Can be
%   useful for calibration of a series of images of the same record
%   parameters.
%
%   SURFACE = CALCULATESURFACEBYDIP(...,PARAM1,VAL1,PARAM2,VAL2,...)
%   calculates surface using name-value pairs to control aspects of the
%   Circular Hough Transform, scaling and visualization. Parameter names
%   can be abbreviated.
%
%   Parameters include:
%
%   'ObjectPolarity' - Specifies the polarity of the circular object with
%                      respect to the background. Available options are:
%
%                      'bright' : The object is brighter than the background.
%                      'dark'   : The object is darker than the background. (Default)
%
%   'Method' - Specifies the technique used for computing the operation
%              point. Available options are:
%
%              'BinarySearch'  : Binary search to find the operation range.
%                                (Default)
%              'QuickEstimate' : Very quick method to find a mediocre
%                                operation range
%
%   'Sensitivity ' - Specifies the sensitivity factor in the range [0 1]
%                    for finding circles. A high sensitivity value leads
%                    to detecting more circles, including weak or
%                    partially obscured ones, at the risk of a higher
%                    false detection rate. Default value: Computed by the
%                    method which is specified by the 'Method' param.
%
%   'ScaleFactor' - Specifies how many pixels are needed to match one
%                   micrometer.
%                   Some values for specific zoom levels:
%                    8000x : 0.0219/1.4
%                   15000x : 0.012/1.4
%                   20000x : 0.0088/1.4
%                   25000x : 0.0071/1.4 (default)
%                   65000x : 0.0027/1.4
%                       yx : 175.2/y/1.4
%
%   'Height' - HEIGHT overrides the default HEIGHT of the cylinders.
%              Unit: micrometer.
%
%   'Visualization' - Specifies the visualization of found circles and arcs
%                     in the original image.
%
%                     'on' : Activate visualization
%                     'off' : Deactivate visualization (default)
%
%   Notes
%   -----
%   1.  Binary images (must be logical matrix) undergo additional pre-processing
%       to improve the accuracy of the result. RGB images are converted to
%       grayscale using RGB2GRAY before they are processed.
%   2.  Accuracy is limited for very small radius values, e.g. Rmin <= 5.
%   3.  The sensitivity estimation step for QuickSearch method is typically
%       faster than that of the BinarySearch method.
%   4.  Both Phase Coding and Two-Stage methods in IMFINDCIRCLES are limited
%       in their ability to detect concentric circles. The results for
%       concentric circles may vary based on the input image.
%   5.  IMFINDCIRCLES does not find circles with centers outside the image
%       domain.
%
%   Class Support
%   -------------
%   Input image A can be uint8, uint16, int16, double, single or logical,
%   and must be nonsparse. The output variables CENTERS, RADII, and METRIC
%   are of class double.

parsedInputs  = parseInputs(varargin{:});

A = parsedInputs.Image;
method        = lower(parsedInputs.Method);
objPolarity   = lower(parsedInputs.ObjectPolarity);
scaleFactor    = parsedInputs.ScaleFactor;
sensitivity   = parsedInputs.Sensitivity;
height = parsedInputs.Height;
visual   = parsedInputs.Visualization;

%% CROP IMAGE 
speedScale = 1;
A = imresize(A,1.4*speedScale);
A = A(1:floor(end*0.85),:);

%% READ SCALE BAR
radius = floor(37*speedScale);
% [radius,scaleFactor] = readScaleBar(A);

%% CALCULATE SENSITIVITY VALUE
if sensitivity == 0.0
    sensitivity = calculateSensitivityPoint(A, radius);   
end

%% DETECT CIRCLES
[centers,radii] = imfindcircles(A,[radius-floor(radius*0.19) radius+floor(radius*0.19)],'ObjectPolarity',objPolarity, ...
    'Method','twostage','Sensitivity',sensitivity);
radius = mean(radii);

%% CALCULATE CIRCUMFERENCE OF ALL CIRCLES
circumference = calculateCircumference(centers,radius,scaleFactor);

%% CALCULATE SURFACE
surface = circumference * height;

%% VISUALIZATION?
if strcmp(visual,'on')
    imshow(A)
    radii = radius * ones(size(centers,1),1);
    viscircles(centers, radii,'EdgeColor','b');
    calculateCircumference(centers,radius,scaleFactor);
    
    [x,y,~] = size(A);
    surfacePlanar = x*y*scaleFactor*scaleFactor;
    fprintf('Ebene Fläche: %.2f Quadratmikrometer \n',surfacePlanar)
    fprintf('Mantelfläche: %.2f Quadratmikrometer \n',surface)
    growth = surface/surfacePlanar + 1;
    fprintf('Vergrößerung der Oberfläche: %.2f %% \n',growth*100)
end
end

function parsedInputs = parseInputs(varargin)

% Validate number of input arguments
narginchk(1,Inf);

persistent parser;

% Wenn der Parser noch nicht initialisiert ist, initialisiere
if isempty(parser)
    checkStringInput = @(x,name) validateattributes(x, ...
        {'char','string'},{'scalartext'},mfilename,name);
    parser = inputParser();
    parser.addRequired('Image',@checkImage);
    parser.addParameter('Method','BinarySearch',@(x) checkStringInput(x,'Method'));
    parser.addParameter('ObjectPolarity','dark');
    parser.addParameter('ScaleFactor',0.0071/1.4);
    parser.addParameter('Sensitivity',0.0,@checkSensitivity);
    parser.addParameter('Height',24);
    parser.addParameter('Visualization', 'off', @(x) checkStringInput(x,'Visualization'));
    % instead '0.85' use func like 'computeSensitivity'
end

% Parse input, replacing partial name matches with the canonical form.
if (nargin > 1) % If any name-value pairs are given
    varargin(2:end) = images.internal.remapPartialParamNames({'Method', 'ObjectPolarity', ...
        'ScaleFactor', 'Sensitivity', 'Height', 'Visualization'}, ...
        varargin{2:end});
end

parser.parse(varargin{:});
parsedInputs = parser.Results;
parsedInputs.Method = checkMethod(parsedInputs.Method);
parsedInputs.Visualization = checkVisualization(parsedInputs.Visualization);

    function tf = checkImage(A)
        allowedImageTypes = {'uint8', 'uint16', 'double', 'logical', 'single', 'int16'};
        validateattributes(A,allowedImageTypes,{'nonempty',...
            'nonsparse','real'},mfilename,'A',1);
        N = ndims(A);
        if (isvector(A) || N > 3)
            error(message('images:imfindcircles:invalidInputImage'));
        elseif (N == 3)
            if (size(A,3) ~= 3)
                error(message('images:imfindcircles:invalidImageFormat'));
            end
        end
        tf = true;
    end

    function str = checkMethod(method)
        str = validatestring(method, {'BinarySearch','QuickSearch'}, ...
            mfilename, 'Method');
    end

    function tf = checkSensitivity(s)
        validateattributes(s,{'numeric'},{'nonempty','nonnan', ...
            'finite','scalar'},mfilename,'Sensitivity');
        if (s > 1 || s < 0)
            error(message('images:imfindcircles:outOfRangeSensitivity'));
        end
        tf = true;
    end

    function str = checkVisualization(v)
        str = validatestring(v, {'on','off'}, mfilename,'Visualization');
    end

end
