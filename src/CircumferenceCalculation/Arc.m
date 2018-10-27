classdef Arc
    %ARC This class stores the data for valid arcs.
    %   The data is just the cut points of the arcs in degrees.
    %   And additionally the information if it is a start or end point
    
    properties
        startPoint
        endPoint
    end
    
    methods
        % Konstruktor
        function obj = Arc(startPoint, endPoint)
            if nargin > 0 % �berpr�fe, ob die Anzahl der �bergebenen Parameter gr��er 0 ist
                if isnumeric(startPoint) && isnumeric(endPoint)
                    obj.startPoint = startPoint;
                    obj.endPoint = endPoint;
                else
                    error('Value must be numeric')
                end
            end
        end
        
        function [startPointInRange, endPointInRange] = isMerging(obj,arc)
            %MERGEARC Pr�fe, ob einer der Endpunkte von arc im Bereich des
            %aufrufenden Bogenst�cks ist
            %   Detailed explanation goes here
            
            % Pr�fe, ob Anfangspunkt im noch g�ltigen Bogenbereich liegt
            if obj.endPoint - obj.startPoint < 0 % Bereich des aufrufenden Bogens �berschreitet die 0� Grenze
                startPointInRange = arc.startPoint > obj.startPoint || arc.startPoint < obj.endPoint;
                endPointInRange = arc.endPoint > obj.startPoint || arc.endPoint < obj.endPoint;
            else
                startPointInRange = arc.startPoint > obj.startPoint && arc.startPoint < obj.endPoint;
                endPointInRange = arc.endPoint > obj.startPoint && arc.endPoint < obj.endPoint;
            end
        end
        
        function newArc = merge(obj,arc)
            %MERGEARC Pr�fe, ob einer der Endpunkte von arc im Bereich des
            %aufrufenden Bogenst�cks ist
            %   Detailed explanation goes here
            
            newArc = obj;
            
            % Pr�fe, ob gegen�berliegende Kreise ohne �berlappung
            if obj.isMerging(arc) && arc.isMerging(obj)
                return
            end
            
            % Pr�fe, ob kompletter Kreis eingeschnitten ist
            if ~obj.isMerging(arc) && ~arc.isMerging(obj)
                newArc = Arc(0,0);
                return
            end
            
            % Checke, ob und welche Endst�cke sich erg�nzen
            [sPoint, ePoint] = obj.isMerging(arc);
            
            if sPoint 
                newArc.startPoint = arc.startPoint;
            end
            
            if ePoint
                newArc.endPoint = arc.endPoint;
            end
            
        end
    end
end

