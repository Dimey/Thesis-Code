classdef ArcAnglesCalculation
    %ArcAnglesCalculation Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        distances
        distanceAngles
        radius
    end
    
    methods
        
        % Konstruktor
        function obj = ArcAnglesCalculation(distances, distanceAngles, radius)
            if nargin > 0 % überprüfe, ob die Anzahl der übergebenen Parameter größer 0 ist
                if isnumeric(distances) && isnumeric(distanceAngles)
                    obj.distances = distances;
                    obj.distanceAngles = distanceAngles;
                    obj.radius = radius;
                else
                    error('Value must be numeric')
                end
            end
        end
        
        function arcAngle = calculateArcAngle(obj, distance, distanceAngle)
            if distance == 0 || distance >= obj.radius*2
                arcAngle = Arc(0,360);
                return
            end
            
            alpha = acosd(distance/2/obj.radius);
            startPoint = distanceAngle + alpha;
            endPoint = distanceAngle - alpha;
            
            if startPoint > 360
                startPoint = startPoint - 360;
            end
            
            if endPoint < 0
                endPoint = endPoint + 360;
            end
            
            arcAngle = Arc(startPoint, endPoint);           
        end
        
        function arcAngleTable = calculateArcAngleTable(obj)
            % Erzeuge leeres Objekt-Array zum Füllen der Bogenstücke
            arcAngleTable(length(obj.distances),length(obj.distances)) = Arc;
            
            % Fülle Tabelle mit Bogenstücken, wenn sich Kreise schneiden.
            % Ansonsten füge eine Null ein, für nichtschneidende Kreise.
            for i = 1:size(obj.distances,1)
                for j = 1:size(obj.distances,2)
                    arcAngleTable(i,j) = obj.calculateArcAngle(obj.distances(i,j),obj.distanceAngles(i,j));
                end
            end
        end
        
    end
end

