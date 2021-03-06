classdef CircumferenceCalculation
    %ARC This class stores the data for valid arcs.
    %   The data is just the cut points of the arcs in degrees.
    %   And additionally the information if it is a start or end point
    
    properties
        centers
        radius
    end
    
    methods
        % Konstruktor
        function obj = CircumferenceCalculation(centers, radius)
            if nargin > 0 % �berpr�fe, ob die Anzahl der �bergebenen Parameter gr��er 0 ist
                if isnumeric(centers) && isnumeric(radius)
                    obj.centers = centers;
                    obj.radius = radius;
                else
                    error('Value must be numeric')
                end
            end
        end
        
        function circumferenceTable = calculateCircumferenceTable(obj)
            % Berechne die Entfernungen der Kreise zueinander
            distances = squareform(pdist(obj.centers));
            
            % Erzeuge Matrix zur Speicherung der Abstands-Winkel
            distanceAngles = ones(length(obj.centers),length(obj.centers));
            
            % F�lle die Distanzwinkel-Matrix mit Werten
            for i = 1:size(distances,1)
                for j = 1:size(distances,2)
                    
                    % Hole ersten Punkt
                    p1 = obj.centers(i,:);
                    
                    % Hole zweiten Punkt
                    p2 = obj.centers(j,:);
                    
                    % Berechne Abstandsvektor der beiden Punkte
                    distanceVector = p2 - p1;
                    
                    % Erzeuge x-Einheitsvektor
                    xe = [1 0];
                    
                    % Berechne Winkel zwischen Einheitsvektor und Distanzvektor
                    angle = acosd(min(1,max(-1, xe(:).' * distanceVector(:) / norm(xe) / norm(distanceVector) )));
                    
                    % Passe gegebenenfalls den Wert f�r den korrekten Quadranten an
                    % 1: Die Phase befindet sich im dritten oder vierten Quadranten
                    if distanceVector(2) > 0
                        angle = 360 - angle;
                    end
                    % 2: Wenn der Kreis den Winkel zu sich selbst berechnet
                    if distanceVector == 0
                        angle = 0;
                    end
                    
                    % Speichere den berechneten Wert in die Distanzwinkel-Matrix
                    distanceAngles(i,j) = angle;
                end
            end
            
            % Erzeuge ArcAnglesCalculation-Objekt
            arcAnglesCalc = ArcAnglesCalculation(distances,distanceAngles,obj.radius);
            
            % Berechne Bogenst�cke
            arcAngleTable = arcAnglesCalc.calculateArcAngleTable();
            
            % Erzeuge die Bogen-Tabelle zum Speichern der gemergeten B�gen
            circumferenceTable(size(arcAngleTable,1),size(arcAngleTable,2)) = Arc;
            
            % Extrahiere die Reihen der Tabelle in einen Objektarray
            for i = 1:size(arcAngleTable,1)
                circle = arcAngleTable(i,:);
                % Berechne die zusammengefassten Bogenwinkel
                mergedArcs = obj.mergeArcsForCircle(circle);
                circumferenceTable(i,1:length(mergedArcs)) = mergedArcs;
            end
            
        end
        
        function mergedArcs = mergeArcsForCircle(~, circle)
            % Entferne die Arc(0,360) Eintr�ge
            
            % Sortiere die Bogenst�cke nach Startpunkt und entferne 0/360er
            j = 1;
            arcsOfCircle1 = Arc.empty(length(circle),0);
            for ii = 1:length(circle)
                %if circle(ii).startPoint == 0 && circle(ii).endPoint == 360
                %else
                arcsOfCircle1(j) = circle(ii);
                j = j + 1;
                %end
            end
            
            [~, ind] = sort([arcsOfCircle1.startPoint]);
            arcsOfCircle1_sorted = arcsOfCircle1(ind);
            
            % MERGE ALGORITHMUS
            
            % Speichere alle Startwerte in Array s (bereits sortiert)
            s = zeros(1, length(arcsOfCircle1_sorted));
            for i = 1:length(arcsOfCircle1_sorted)
                s(i) = arcsOfCircle1_sorted(i).startPoint;
            end
            
            % Entferne doppelte Eintr�ge
            s(diff(s) == 0) = [];
            
            % Speichere alle Startwerte in Array e und sortiere sie
            e = zeros(1, length(arcsOfCircle1_sorted));
            for i = 1:length(arcsOfCircle1_sorted)
                e(i) = arcsOfCircle1_sorted(i).endPoint;
            end
            e = sort(e);
            e(diff(e) == 0) = [];
            
            % Entferne diejenigen Start- und Entpunkte, die im �berlappten
            % Bereich liegen
            for i = 1:length(arcsOfCircle1_sorted)
                if arcsOfCircle1_sorted(i).endPoint - arcsOfCircle1_sorted(i).startPoint > 0
                    s_index = s<arcsOfCircle1_sorted(i).startPoint | s>arcsOfCircle1_sorted(i).endPoint;
                    e_index = e<arcsOfCircle1_sorted(i).startPoint | e>arcsOfCircle1_sorted(i).endPoint;
                else
                    s_index = s<arcsOfCircle1_sorted(i).startPoint & s>arcsOfCircle1_sorted(i).endPoint;
                    e_index = e<arcsOfCircle1_sorted(i).startPoint & e>arcsOfCircle1_sorted(i).endPoint;
                end
                s(s_index) = [];
                e(e_index) = [];
            end
            
            % Fasse die Bogenst�cke zu zusammenh�ngenden St�cken zusammen
            mergedArcs = Arc.empty(length(arcsOfCircle1_sorted),0);
            
            k = 1;
            for i = 1:length(s)
                index = find(e>s(i),1);
                if ~isempty(index)
                    mergedArcs(k) = Arc(s(i),e(index));
                    k = k + 1;
                else
                    mergedArcs(k) = Arc(s(i),e(1));
                end
            end
        end
        
    end
end