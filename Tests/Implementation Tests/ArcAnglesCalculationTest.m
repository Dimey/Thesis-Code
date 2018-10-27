classdef ArcAnglesCalculationTest < matlab.unittest.TestCase
    %ARCTEST Tests f¸r die Bogenst¸ck-Klasse
    %   Detailed explanation goes here
    
    properties
        sut
        distances = [0 80 283 336; 80 0 273 416; 283 273 0 470; 336 416 470 0];
        distanceAngles = [0 60 135 233; 240 0 151 234; 315 331 0 270; 53 54 90 0];
        radius = 200;
    end
    
    methods(TestClassSetup)
        function createSystemUnderTest(testCase)
            testCase.sut = ArcAnglesCalculation(testCase.distances, testCase.distanceAngles, testCase.radius);
        end
    end
    
    methods (Test)
        
        % TESTING OF CONSTRUCTOR AND INITIALIZATION
        
        function testInitializationOfObjectVariables(testCase)
            %testInitialization Construct an instance of this class
            %   Detailed explanation goes here
            
            actSolutionDistances = testCase.sut.distances;
            actSolutionDistanceAngles = testCase.sut.distanceAngles;
            expSolution = [testCase.distances, testCase.distanceAngles];
            testCase.verifyEqual([actSolutionDistances, actSolutionDistanceAngles], expSolution);
        end
        
        function testCorrectAngleCalculation(testCase)
            %testInitialization Construct an instance of this class
            %   Detailed explanation goes here
            distance = 80;
            distanceAngle = 60;
            actSolution = testCase.sut.calculateArcAngle(distance,distanceAngle);
            expSolution = [138.463,341.537];
            testCase.verifyEqual([actSolution.startPoint, actSolution.endPoint],expSolution,'RelTol', 0.01);
        end
        
        function testAnotherCorrectAngleCalculation(testCase)
            %testInitialization Construct an instance of this class
            %   Detailed explanation goes here
            distance = 273;
            distanceAngle = 331;
            actSolution = testCase.sut.calculateArcAngle(distance,distanceAngle);
            expSolution = [17.96,284.04];
            testCase.verifyEqual([actSolution.startPoint, actSolution.endPoint],expSolution,'RelTol', 0.01);
        end
        
        function testAngleCalculationForSameCircle(testCase)
            %testInitialization Construct an instance of this class
            %   Detailed explanation goes here
            distance = 0;
            distanceAngle = 0;
            actSolution = testCase.sut.calculateArcAngle(distance,distanceAngle);
            expSolution = Arc(0,360);
            testCase.verifyEqual(actSolution,expSolution);
        end
        
        function testCalculateArcAngleTable(testCase)
            %testInitialization Construct an instance of this class
            %   Detailed explanation goes here
            tempActSolution = testCase.sut.calculateArcAngleTable();
            
            % Entpacke den Cell-Array in eine normale, numerische Matrix
            actSolution = ones(length(tempActSolution),length(tempActSolution)*2);
            for i = 1:size(tempActSolution,1)
                for j = 1:size(tempActSolution,2)
                        actSolution(i,2*j-1) = tempActSolution(i,j).startPoint;
                        actSolution(i,2*j) = tempActSolution(i,j).endPoint;
                end
            end 
            
            expSolution = [0, 360, 138.46, 341.54, 179.97, 90.03, 265.86, 200.14;
                           318.46, 161.54, 0, 360, 197.96, 104.04, 0, 360;
                           359.97, 270.03, 17.96, 284.04, 0, 360, 0, 360;
                           85.86, 20.14, 0, 360, 0, 360, 0, 360];
                       
            testCase.verifyEqual(actSolution,expSolution, 'RelTol', 0.01);
        end
  
    end
    
end