%% READ IMAGE
pathToFile = '/Users/dimi/Desktop/Studium/Aktuelles Semester/Bachelor Thesis/REM-Bilder/Feine Auswahl/104.TIF';
original = imread(pathToFile);

%% MOST SIMPLE CALL
surface = calculateSurfaceByDIP(original);
fprintf('Oberfläche der Mantelfläche aller Drähte: %.2f Quadratmikrometer\n',surface)

%% ADDITIONALLY GET ESTIMATED SENSITIVITY
[~,sensitivity] = calculateSurfaceByDIP(original);
fprintf('Ermittelter Sensitivitätswert: %.3f \n',sensitivity)

%% USE PRE-CALCULATED SENSITIVITY TO REDUCE CALCULATION TIME
surface = calculateSurfaceByDIP(original,'Sensitivity',sensitivity);

%% USE INDIVIDUAL HEIGHT PARAMETER
surfaceWithNewHeight = calculateSurfaceByDIP(original,'Sensitivity',0.935,'Height',30);

%% GET SOME VISUAL OUTPUT FOR DETECTED CIRCLES
calculateSurfaceByDIP(original,'Sensitivity',0.930,'Visualization','on');