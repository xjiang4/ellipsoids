classdef EllipsoidTestCase < mlunitext.test_case
    methods
        function self=EllipsoidTestCase(varargin)
            self=self@mlunitext.test_case(varargin{:});
        end
        function self = testDistance(self)
            
            global  ellOptions;
            testEllipsoid = ellipsoid(zeros(2,1),eye(2,2));
            testPoint = [3,0]';
            testRes = distance(testEllipsoid, testPoint);
            mlunit.assert_equals(1, abs(testRes-2)<ellOptions.abs_tol);
            
            
            testEllipsoid1 = ellipsoid([0,0,0]',[1,0,0; 0,2,0;0,0,4]);
            testEllipsoid2 = ellipsoid([0,0,4]',[3,0,0; 0,5,0; 0,0,1]);
            testRes=distance(testEllipsoid1,testEllipsoid2);
            mlunit.assert_equals(1,abs(testRes-1)<ellOptions.abs_tol);
         end
    end
end