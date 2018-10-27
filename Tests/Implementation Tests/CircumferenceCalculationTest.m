classdef CircumferenceCalculationTest < matlab.unittest.TestCase
    %ARCTEST Tests f¸r die Bogenst¸ck-Klasse
    %   Detailed explanation goes here
    
    properties
        sut
        centers = [500 500; 540 430; 300 300; 300 770]
        radius = 200
        circTable
    end
    
    methods(TestClassSetup)
        function createSystemUnderTest(testCase)
            testCase.sut = CircumferenceCalculation(testCase.centers, testCase.radius);
            testCase.circTable = testCase.sut.calculateCircumferenceTable();
        end
    end
    
    methods (Test)
        
        % TESTING OF CONSTRUCTOR AND INITIALIZATION
        
        function testInitializationOfObjectVariables(testCase)
            %testInitialization Construct an instance of this class
            %   Detailed explanation goes here
            
            actSolutionCenters = testCase.sut.centers;
            actSolutionRadius = testCase.sut.radius * ones(size(actSolutionCenters,1),1);
            expSolution = [testCase.centers, testCase.radius * ones(size(actSolutionCenters,1),1)];
            testCase.verifyEqual([actSolutionCenters, actSolutionRadius], expSolution);
        end
        
        % TESTING SOME MERGE SCENARIOS
        
        function testArcMergeForFirstCircle(testCase)
            actSolution = testCase.circTable(1,:);
            actSolutionNumeric = zeros(1,length(actSolution)*2);
            for i = 1:length(actSolution)
                if ~isempty(actSolution(i).startPoint)
                    actSolutionNumeric(2*i-1) = actSolution(i).startPoint;
                    actSolutionNumeric(2*i) = actSolution(i).endPoint;
                end
            end
            actSolutionNumeric(actSolutionNumeric==0) = [];
            expSolution = [179.97,200.14,265.86,341.54];
            testCase.verifyEqual(actSolutionNumeric, expSolution,'RelTol', 0.01);
        end
        
        function testArcMergeForSecondCircle(testCase)
            actSolution = testCase.circTable(2,:);
            actSolutionNumeric = zeros(1,length(actSolution)*2);
            for i = 1:length(actSolution)
                if ~isempty(actSolution(i).startPoint)
                    actSolutionNumeric(2*i-1) = actSolution(i).startPoint;
                    actSolutionNumeric(2*i) = actSolution(i).endPoint;
                end
            end
            actSolutionNumeric(i+1:end) = [];
            expSolution = [0,104.6,318.6,360];
            testCase.verifyEqual(actSolutionNumeric, expSolution,'RelTol', 0.01);
        end
        
        function testArcMergeForThirdCircle(testCase)
            actSolution = testCase.circTable(3,:);
            actSolutionNumeric = zeros(1,length(actSolution)*2);
            for i = 1:length(actSolution)
                if ~isempty(actSolution(i).startPoint)
                    actSolutionNumeric(2*i-1) = actSolution(i).startPoint;
                    actSolutionNumeric(2*i) = actSolution(i).endPoint;
                end
            end
            actSolutionNumeric(actSolutionNumeric==0) = [];
            expSolution = [18.5,270];
            testCase.verifyEqual(actSolutionNumeric, expSolution,'RelTol', 0.01);
        end
        
        function testArcMergeForFourthCircle(testCase)
            actSolution = testCase.circTable(4,:);
            actSolutionNumeric = zeros(1,length(actSolution)*2);
            for i = 1:length(actSolution)
                if ~isempty(actSolution(i).startPoint)
                    actSolutionNumeric(2*i-1) = actSolution(i).startPoint;
                    actSolutionNumeric(2*i) = actSolution(i).endPoint;
                end
            end
            actSolutionNumeric(i+1:end) = [];
            expSolution = [0,20.6,86.3,360];
            testCase.verifyEqual(actSolutionNumeric, expSolution,'RelTol', 0.01);
        end
        
        function testArcMergeForOverlapRangeWithNoIntersection(testCase)
            % Erzeuge manuell eine Bogentabelle
            testCircumferenceTable(2,2) = Arc; 
            testCircumferenceTable(1,1) = Arc(90,1);
            testCircumferenceTable(1,2) = Arc(18,284);
            
            actSolution = testCase.sut.mergeArcsForCircle(testCircumferenceTable(1,:));
            
            actSolutionNumeric = zeros(1,length(actSolution)*2);
            for i = 1:length(actSolution)
                if ~isempty(actSolution(i).startPoint)
                    actSolutionNumeric(2*i-1) = actSolution(i).startPoint;
                    actSolutionNumeric(2*i) = actSolution(i).endPoint;
                end
            end
            actSolutionNumeric(actSolutionNumeric==0) = [];
            expSolution = [90,284];
            testCase.verifyEqual(actSolutionNumeric, expSolution,'RelTol', 0.01);
        end
        
        function testArcMergeOfNonOverlappingCircle(testCase)
            % Erzeuge manuell eine Bogentabelle
            testCircumferenceTable(2,2) = Arc; 
            testCircumferenceTable(1,1) = Arc(40,320);
            testCircumferenceTable(1,2) = Arc(190,130);
            
            actSolution = testCase.sut.mergeArcsForCircle(testCircumferenceTable(1,:));
            
            actSolutionNumeric = zeros(1,length(actSolution)*2);
            for i = 1:length(actSolution)
                if ~isempty(actSolution(i).startPoint)
                    actSolutionNumeric(2*i-1) = actSolution(i).startPoint;
                    actSolutionNumeric(2*i) = actSolution(i).endPoint;
                end
            end
            actSolutionNumeric(actSolutionNumeric==0) = [];
            expSolution = [40,130,190,320];
            testCase.verifyEqual(actSolutionNumeric, expSolution,'RelTol', 0.01);
        end
        
        function testArcMergeOfCompleteOverlapping(testCase)
            % Erzeuge manuell eine Bogentabelle
            testCircumferenceTable(3,3) = Arc; 
            testCircumferenceTable(1,1) = Arc(120,2);
            testCircumferenceTable(1,2) = Arc(180,300);
            testCircumferenceTable(1,3) = Arc(310,80);
            
            actSolution = testCase.sut.mergeArcsForCircle(testCircumferenceTable(1,:));
            
            actSolutionNumeric = zeros(1,length(actSolution)*2);
            for i = 1:length(actSolution)
                if ~isempty(actSolution(i).startPoint)
                    actSolutionNumeric(2*i-1) = actSolution(i).startPoint;
                    actSolutionNumeric(2*i) = actSolution(i).endPoint;
                end
            end
            actSolutionNumeric(actSolutionNumeric==0) = [];
            expSolution = zeros(1);
            expSolution(1) = [];
            testCase.verifyEqual(actSolutionNumeric, expSolution);
        end
        
        function testArcMergeOfTwoFreeCircles(testCase)
            % Erzeuge manuell eine Bogentabelle
            testCircumferenceTable(2,2) = Arc; 
            testCircumferenceTable(1,1) = Arc(0,360);
            testCircumferenceTable(1,2) = Arc(0,360);
            testCircumferenceTable(2,1) = Arc(0,360);
            testCircumferenceTable(2,2) = Arc(0,360);
            
            actSolution = testCase.sut.mergeArcsForCircle(testCircumferenceTable(1,:));
            
            actSolutionNumeric = zeros(1,length(actSolution)*2);
            for i = 1:length(actSolution)
                if ~isempty(actSolution(i).startPoint)
                    actSolutionNumeric(2*i-1) = actSolution(i).startPoint;
                    actSolutionNumeric(2*i) = actSolution(i).endPoint;
                end
            end
            expSolution = [0,360];
            testCase.verifyEqual(actSolutionNumeric, expSolution);
        end
  
    end
    
end

% TODO:
% - move temp variables to test init