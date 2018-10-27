function circumference = calculateCircumference(centers,radius,pixelLength)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

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

circumference = sumArcs/360 * pi * radius * pixelLength;
%fprintf('Umfang aller Kreise: %.2f Mikrometer\n',circumference)
end

