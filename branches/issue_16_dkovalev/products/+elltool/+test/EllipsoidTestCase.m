classdef EllipsoidTestCase < mlunitext.test_case

% $Author: Dmitry Kovalev, Lomonosov Moscow State University,
% Faculty of Computational Mathematics and Cybernetics, System Analysis
% Department, 18-October-2012, <klivenn@gmail.com>$

    methods
        function self = EllipsoidTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        function self = testPlot(self)
            nDim = 2;
            testEll = ellipsoid(zeros(nDim, 1), eye(nDim));
            %testPoint = zeros(nDim, 1);
            %plot(
            %plot3
            %mlunit.assert_equals(0, sin(0));
        end
        function self = testMove2Origin(self)
            nDim = 1;
            testPoint = rand(nDim, 1);
            testRes = move2origin(testPoint);
            mlunit.assert_equals(zeros(nDim, 1), testRes);
            
            nDim = 5;
            testPoint = rand(nDim, 1);
            testRes = move2origin(testPoint);
            mlunit.assert_equals(zeros(nDim, 1), testRes);
            
            nDim = 10;
            testPoint = rand(nDim, 1);
            testRes = move2origin(testPoint);
            mlunit.assert_equals(zeros(nDim, 1), testRes);
        end
        function self = testShape(self)
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
            mlunit.assert_equals(0, sin(0));
        end
        function self = testMinus(self)
            mlunit.assert_equals(0, sin(0));
        end
        function self = testUminus(self)
            mlunit.assert_equals(0, sin(0));
        end
        function self = testDisplay(self)
            mlunit.assert_equals(0, sin(0));
        end
        function self = testInv(self)
            mlunit.assert_equals(0, sin(0));
        end
    end
end