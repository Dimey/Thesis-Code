function sensitivityPoint = calculateSensitivityPoint(image,radius)
%CALCULATESENSITIVITYPOINT Summary of this function goes here
%   Detailed explanation goes here
    
    %% ARBEITSBEREICH FÜR DEN SENSITIVITÄTSWERT ERMITTELN
    % 1) STARTWERT
    % Anfangswerte für den Sensitivitätswert und die Schrittweite
    startPunkt = 0.5;
    schrittWeite = 0.25;

    % Genauigkeit der binären Suche einstellen
    epsilon = 0.01;
    
    % Beginne Zeitmessung
    tic
    
    % Bild einlesen
    %original = imread(image);

    % Binäre Suche starten
    while schrittWeite > epsilon
        foundCircles = imfindcircles(image,[radius-floor(radius*0.19) radius+floor(radius*0.19)],'ObjectPolarity','dark', ...
        'Method','twostage','Sensitivity',startPunkt);
        if ~isempty(foundCircles)
            startPunkt = startPunkt - schrittWeite;
        else
            startPunkt = startPunkt + schrittWeite;
        end

        schrittWeite = schrittWeite/2;
    end
    
    % Das Ergebnis auf zwei Dezimalstellen runden
    startPunkt = round(startPunkt,2) + 0.01;
    
    % 2) ENDWERT
    arrayCounter = 0;
    
    % Suche grob nach Kreisen im eingeschränkten Sensitivitätsbereich
    for i = startPunkt: 0.01: 0.99
        arrayCounter = arrayCounter + 1;
        [centers,~] = imfindcircles(image,[radius-floor(radius*0.19) radius+floor(radius*0.19)],'ObjectPolarity','dark', ...
        'Method','twostage','Sensitivity',i);
        if length(centers) < 500 % natürliche, sinnvolle Maximalanzahl in einem Bild
            foundCircles(arrayCounter) = length(centers);
        else
            break;
        end
    end

    % Leite diskrete Funktion ab
    foundCirclesDiff = diff(foundCircles);

    % Bestimme Median der Menge
    medianValue = median(foundCirclesDiff);

    % Bestimme die Stelle, an der der Anstieg der Anzahl der gefundenen 
    % Kreise den Median um 1000% übertrifft
    indexOfSensitivity = find(foundCirclesDiff>medianValue*5, 1, 'first');
    endPunkt = startPunkt + 0.01* indexOfSensitivity;
    
    % Beende Zeitmessung
    toc
    
    %% SENSITIVITÄTSWERT INNERHALB DES ARBEITSBEREICHS ERMITTELN
    % ÜBER SENSITIVITÄT ITERIEREN UND ANZAHL GEFUNDENER KREISE SPEICHERN
    foundCircles = zeros(1, 1000);
    arrayCounter = 1;
    for i=startPunkt:0.005:endPunkt
        [centers,~] = imfindcircles(image,[radius-floor(radius*0.19) radius+floor(radius*0.19)],'ObjectPolarity','dark', ...
        'Method','twostage','Sensitivity',i);
        foundCircles(arrayCounter) = length(centers);
        arrayCounter = arrayCounter + 1;
    end
    toc

    x = startPunkt+0.005:0.005:endPunkt;
    y = foundCircles(1:arrayCounter-1);
    differential = diff(y);

    indicesOfLocalMinima = islocalmin(differential);
    localMinima = x(indicesOfLocalMinima);

    % refine tf
    tf_refined = differential(indicesOfLocalMinima) < ceil(mean(differential(indicesOfLocalMinima)));
    localMinima_refined = localMinima(tf_refined);
    
    sensitivityPoint = localMinima_refined(end);

    %% VISUALISIERUNG
    plot(x,differential,x(indicesOfLocalMinima),differential(indicesOfLocalMinima),'r*')
    title('Gradient of Found Circles')
    xlabel('Sensitivity')
    ylabel('New found circles with every step')
end

