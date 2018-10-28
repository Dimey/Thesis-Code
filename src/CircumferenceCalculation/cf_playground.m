% Mit diesem Skript wird der neue Umfangsberechnungsalgorithmus getestet,
% der mit einer beliebigen Anzahl an Kreisen zurechtkommt

%% TESTE FIXE, KÜNSTLICHE UMGEBUNG
%Erzeuge ein weißes Bild von der Größe 1000x1000
leinwandDimension = 1500;
whiteImage = 255 * ones(leinwandDimension, leinwandDimension*1.3, 'uint8');
imshow(whiteImage);

% Platziere fixe Kreise
centers = [160 200; 80 220; 210 180; 230 250; 100 100];
radius = 50; % 110 interessant

radii = radius * ones(size(centers,1),1);
viscircles(centers, radii,'EdgeColor','k');

% Erzeuge ein CircumferenceCalculation-Objekt
circumCalc = CircumferenceCalculation(centers,radius);

% Berechne nicht überlappende Bogenstücke
arcs = circumCalc.calculateCircumferenceTable();

% Gehe nun jeden Kreis durch und zeichne die Bögen
for i = 1:length(centers)
    for j = 1:length(arcs)
        if ~isempty(arcs(i,j).startPoint)
            arc = arcs(i,j);
            %fprintf('Kreis %d',i)
            drawArc(centers(i,:),arc,radius);
        end
    end
end

% Berechne die Gesamtbogenlänge 
sumArcs = 0;
for i = 1:size(arcs,1)
    for j = 1:size(arcs,2)
        arc = arcs(i,j);
        if ~isempty(arc.startPoint)
            arcAbs = arc.endPoint - arc.startPoint;
            sumArcs = sumArcs + arcAbs;
        end
    end
end

% 284 Pixel entsprechen 2 micrometre
% bogen/360 * 2*pi*radius)
pixelLength = 2/284; % Factor (micrometre per pixel)

circumference = sumArcs/360 * pi * radius * pixelLength;
fprintf('Umfang aller Kreise: %.2f micrometre\n',circumference)

%% TESTE ZUFÄLLIGE, KÜNSTLICHE UMGEBUNG
% Erzeuge ein weißes Bild von der Größe 1000x1000
leinwandDimension = 1500;
whiteImage = 255 * ones(leinwandDimension, leinwandDimension*1.3, 'uint8');
imshow(whiteImage);

% % Initiere zufällige Kreise
anzahl = 100;
radius = 50;
centers = zeros(anzahl,2);
for i = 1:anzahl
     centers(i,:) = [randi(leinwandDimension*1.3-2*radius)+radius randi(leinwandDimension-2*radius)+radius];
end

% Zeichne Kreise auf die weiße Leinwand
radii = radius * ones(size(centers,1),1);
viscircles(centers, radii,'EdgeColor','k');

tic
% Erzeuge ein CircumferenceCalculation-Objekt
circumCalc = CircumferenceCalculation(centers,radius);

% Berechne nicht überlappende Bogenstücke
arcs = circumCalc.calculateCircumferenceTable();

% Gehe nun jeden Kreis durch und zeichne die Bögen
for i = 1:length(centers)
    for j = 1:length(arcs)
        if ~isempty(arcs(i,j).startPoint)
            arc = arcs(i,j);
            %fprintf('Kreis %d',i)
            drawArc(centers(i,:),arc,radius);
        end
    end
end
toc
%% TESTE ECHTE UMGEBUNG
% SCHRITT 1: BILD EINLESEN
original = imread('115ohneBalken.png');
imshow(original) % zeige zur Überprüfung das Bild an

time=cputime;

% SCHRITT 2: KREISE DETEKTIEREN
[centers,radii] = imfindcircles(original,[30 45],'ObjectPolarity','dark', ...
    'Method','twostage','Sensitivity',0.935);
time=cputime-time;
fprintf('Processing time = %.2f s\n',time);

radius = mean(radii); % Bilde Durchschnittswert der Radien
radii = radius * ones(size(centers,1),1);

viscircles(centers, radii,'EdgeColor','b');

