classdef ArcTest < matlab.unittest.TestCase
    %ARCTEST Tests für die Bogenstück-Klasse
    %   Detailed explanation goes here
    
    properties
        % Typ A: Bogen zwischen 0° und 360°
        % Typ B: Bogen mit Übertritt der 0°/360°-Grenze
        % Typ C: Bogen mit min. Übertritt der 0°/360°-Grenze
        arc0
        arcA1
        arcA2
        arcA3
        arcA4
        arcB4
        arcB5
        arcB6
        arcB7
        arcC8
    end
    
    methods(TestClassSetup)
        function createArcs(testCase)
            % Erzeuge einige Bogenstücke
            testCase.arc0 = Arc(0,0);
            testCase.arcA1 = Arc(30,330);
            testCase.arcA2 = Arc(0,180);
            testCase.arcA3 = Arc(181,360);
            testCase.arcA4 = Arc(40,320);
            testCase.arcB4 = Arc(210,150);
            testCase.arcB5 = Arc(181,1);
            testCase.arcB6 = Arc(359,179);
            testCase.arcB7 = Arc(200,160);
            testCase.arcC8 = Arc(359,1);
        end
    end
    
    methods (Test)
        
        % TESTING OF ISMERGING
        
        function testIfEndPointInRange(testCase)
            %testEndPointInRange Construct an instance of this class
            %   Detailed explanation goes here
            
            [actSolutionStart, actSolutionEnd] = testCase.arcA1.isMerging(testCase.arcA2);
            expSolution = [false, true];
            testCase.verifyEqual([actSolutionStart, actSolutionEnd],expSolution);
        end
        
        function testIfStartPointInRange(testCase)
            %testStartPointInRange Construct an instance of this class
            %   Detailed explanation goes here
            
            [actSolutionStart, actSolutionEnd] = testCase.arcA1.isMerging(testCase.arcA3);
            expSolution = [true, false];
            testCase.verifyEqual([actSolutionStart, actSolutionEnd],expSolution);
        end
        
        function testIfBothPointsInRange(testCase)
            %testStartPointInRange Construct an instance of this class
            %   Detailed explanation goes here
            
            [actSolutionStart, actSolutionEnd] = testCase.arcA1.isMerging(testCase.arcB4);
            expSolution = [true, true];
            testCase.verifyEqual([actSolutionStart, actSolutionEnd],expSolution);
        end
        
        function testIfNoPointsInRange(testCase)
            %testStartPointInRange Construct an instance of this class
            %   Detailed explanation goes here
            
            [actSolutionStart, actSolutionEnd] = testCase.arcA1.isMerging(testCase.arcC8);
            expSolution = [false, false];
            testCase.verifyEqual([actSolutionStart, actSolutionEnd],expSolution);
        end
        
        % TESTING OF MERGE
        function testMergeAA(testCase)
            %testEndPointInRange Tests if the endpoint of the new arc is
            %correctly adjusted
            %   Detailed explanation goes here
            
            act1 = testCase.arcA1.merge(testCase.arcA2); % sPoint only
            exp1 = Arc(30,180);
            act2 = testCase.arcA1.merge(testCase.arcA3); % ePoint only
            exp2 = Arc(181,330);
            act3 = testCase.arcA1.merge(testCase.arcA4); % bPoints
            exp3 = testCase.arcA4;
            act4 = testCase.arcA2.merge(testCase.arcA3); % nPoints
            exp4 = testCase.arc0;
            testCase.verifyEqual([act1,act2,act3,act4],[exp1,exp2,exp3,exp4]);
        end
        
        function testMergeBB(testCase)
            %testEndPointInRange Tests if the endpoint of the new arc is
            %correctly adjusted
            %   Detailed explanation goes here
            
            act1 = testCase.arcB4.merge(testCase.arcB6); % sPoint only
            exp1 = Arc(359,150);
            act2 = testCase.arcB4.merge(testCase.arcB5); % ePoint only
            exp2 = Arc(210,1);
            act3 = testCase.arcB4.merge(testCase.arcC8); % bPoints
            exp3 = testCase.arcC8;
            act4 = testCase.arcB4.merge(testCase.arcB7); % nPoints
            exp4 = testCase.arcB4;
            testCase.verifyEqual([act1,act2,act3,act4],[exp1,exp2,exp3,exp4]);
        end
        
        function testMergeAB(testCase)
            %testEndPointInRange Tests if the endpoint of the new arc is
            %correctly adjusted
            %   Detailed explanation goes here
            
            act1 = testCase.arcA1.merge(testCase.arcB5); % sPoint only
            exp1 = Arc(181,330);
            act2 = testCase.arcA1.merge(testCase.arcB6); % ePoint only
            exp2 = Arc(30,179);
            act3 = testCase.arcA1.merge(testCase.arcB4); % bPoints, ohne Einschließung
            exp3 = testCase.arcA1; % Vorsicht, Kreise ohne Überlappung!!
            act4 = testCase.arcA1.merge(Arc(355,350)); % bPoints, mit Einschließung
            exp4 = testCase.arcA1; 
            act5 = testCase.arcA1.merge(testCase.arcC8); % nPoints
            exp5 = testCase.arc0;
            testCase.verifyEqual([act1,act2,act3,act4,act5],[exp1,exp2,exp3,exp4,exp5]);
        end
         
        function testMergeBA(testCase)
            %testEndPointInRange Tests if the endpoint of the new arc is
            %correctly adjusted
            %   Detailed explanation goes here
            
            act1 = testCase.arcB4.merge(testCase.arcA2); % sPoint only
            exp1 = Arc(0,150);
            act2 = testCase.arcB4.merge(testCase.arcA3); % ePoint only
            exp2 = Arc(210,360);
            act3 = testCase.arcB4.merge(testCase.arcA1); % bPoints, oE
            exp3 = testCase.arcB4;
            act4 = testCase.arcB4.merge(Arc(10,140)); % bPoints, mE
            exp4 = Arc(10,140);
            act5 = testCase.arcB4.merge(Arc(160,200)); % nPoints
            exp5 = testCase.arc0;
            testCase.verifyEqual([act1,act2,act3,act4,act5],[exp1,exp2,exp3,exp4,exp5]);
        end
        
    end
    
end

