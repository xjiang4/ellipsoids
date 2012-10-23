classdef EllipsoidTestCase < mlunitext.test_case

% $Author: Igor Samokhin, Lomonosov Moscow State University,
% Faculty of Computational Mathematics and Cybernetics, System Analysis
% Department, 22-October-2012, <igorian.vmk@gmail.com>$

    methods
        function self = EllipsoidTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        
        function self = testIsInside(self)
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
    end
end