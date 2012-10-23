classdef EllipsoidTestCase < mlunitext.test_case

% $Author: Dmitry Kovalev, Lomonosov Moscow State University,
% Faculty of Computational Mathematics and Cybernetics, System Analysis
% Department, 18-October-2012, <klivenn@gmail.com>$

    methods
        function self = EllipsoidTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        function self = testPlot(self)
            %nDim = 2;
            %testEll = ellipsoid(zeros(nDim, 1), eye(nDim));
            %testPoint = zeros(nDim, 1);
            %plot(
            %plot3
            %mlunit.assert_equals(0, sin(0));
        end
        
        function self = testMove2Origin(self)
        testShapeMatrix = [3 1; 0 1];
        testCenter = [1; 1];
        testEll = ellipsoid(testCenter, testShapeMatrix*testShapeMatrix');
        testResultEll = move2origin(testEll);
        [testResCenter ~] = double(testResultEll);
        mlunit.assert_equals([0; 0], testResCenter);
        
        testShapeMatrix = 3;
        testCenter = 150;
        testEll = ellipsoid(testCenter, testShapeMatrix*testShapeMatrix');
        testResultEll = move2origin(testEll);
        [testResCenter ~] = double(testResultEll);
        mlunit.assert_equals(0, testResCenter);
        
        testShapeMatrix = [3 1 5 3; 1 2 0 1; 6 4.4 8 9; 3.4 4 5 6];
        testCenter = [1; 1; 0; 10];
        testEll = ellipsoid(testCenter, testShapeMatrix*testShapeMatrix');
        testResultEll = move2origin(testEll);
        [testResCenter ~] = double(testResultEll);
        mlunit.assert_equals([0; 0; 0; 0], testResCenter);
        end
        
        function self = testShape(self)
        testShapeMatrix1 = [3 5 -1; 2 4 1; 5 6 7];
        testShapeMatrix2 = [4 8 2; 8 3 2; 8 7 6];
        testMatrix = [4 5 3; 7.2 3 8; 91 0 1];
        testEll1 = ellipsoid([2; 4; 1], testShapeMatrix1*testShapeMatrix1');
        testEll2 = ellipsoid([5; 1; 2], testShapeMatrix2*testShapeMatrix2');
        testEllArray = [testEll1, testEll2];
        testRes = shape(testEllArray, testMatrix);
        display(testRes);
        testKnownRes = testShapeMatrix
        mlunit.assert_equals(0, sin(0));
        end
        
        function self = testRho(self)
            mlunit.assert_equals(0, sin(0));
        end
        function self = testProjection(self)
            mlunit.assert_equals(0, sin(0));
        end
        function self = testMinksum(self)
            mlunit.assert_equals(0, sin(0));
        end
        function self = testMinkdiff(self)
            mlunit.assert_equals(0, sin(0));
        end
        function self = testMinkpm(self)
            mlunit.assert_equals(0, sin(0));
        end
        
        function self = testPlus(self)
            testEllCenter = [5 10];
            testVector = [3 8];
            testRes = plus(testEllCenter, testVector);
            mlunit.assert_equals([8 18], testRes);
            
            testEllCenter = [1 2 3 4 5 6 7 8 9 10];
            testVector = [7 3 7 9 0 3 2 4 3 6];
            testRes = plus(testEllCenter, testVector);
            mlunit.assert_equals([8 5 10 13 5 9 9 12 12 16], testRes);
            
            testEllCenter = 1;
            testVector = 7;
            testRes = plus(testEllCenter, testVector);
            mlunit.assert_equals(8, testRes);
        end
        
        function self = testMinus(self)
            testEllCenter = [3 7];
            testVector = [3 9];
            testRes = minus(testEllCenter, testVector);
            mlunit.assert_equals([0 -2], testRes);
            
            testEllCenter = [1 2 3 4 5 6 7 8 9 10];
            testVector = [7 3 7 9 0 3 2 4 3 6];
            testRes = minus(testEllCenter, testVector);
            mlunit.assert_equals([-6 -1 -4 -5 5 3 5 4 6 4], testRes);
            
            testEllCenter = 1;
            testVector = 7;
            testRes = minus(testEllCenter, testVector);
            mlunit.assert_equals(-6, testRes);
        end
        
        function self = testUminus(self)
            testEllCenter = [5 10];
            testRes = uminus(testEllCenter);
            mlunit.assert_equals([-5 -10], testRes);
            
            testEllCenter = [1 -2 3 -4 5 -6 7 -8 9 -10];
            testRes = uminus(testEllCenter);
            mlunit.assert_equals([-1 2 -3 4 -5 6 -7 8 -9 10], testRes);
            
            testEllCenter = -1;
            testRes = uminus(testEllCenter);
            mlunit.assert_equals(1, testRes);
        end
        
        function self = testDisplay(self)
            testShapeMatrix = [1 0; 0 1];
            testEll = ellipsoid([0; 1], testShapeMatrix*testShapeMatrix');
            display(testEll);
            
            testShapeMatrix = [-1 2 3; 4 3 -2.6; 5 10 241];
            testEll = ellipsoid([241; 24.1; 2.41], testShapeMatrix*testShapeMatrix');
            display(testEll);
            
            testShapeMatrix = 1;
            testEll = ellipsoid(5, testShapeMatrix*testShapeMatrix');
            display(testEll);
        end
        
        function self = testInv(self)
            testShapeMatrix = [1 1; 1 1];
            testEll = ellipsoid([1; 2], testShapeMatrix*testShapeMatrix');
            self.runAndCheckError('inv(testEll)','degenerateMatrix')
            
            testShapeMatrix = eye(2,2);
            testEll = ellipsoid([-5; 1], testShapeMatrix*testShapeMatrix');
            testEll = inv(testEll);
            [testResCenter testResMatrix] = double(testEll);
            testIsRight = (testResMatrix == eye(2,2));
            mlunit.assert_equals(min(min((testIsRight))), 1);
        end
    end
end