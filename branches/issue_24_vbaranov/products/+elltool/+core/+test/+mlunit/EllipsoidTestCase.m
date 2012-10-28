classdef EllipsoidTestCase < mlunitext.test_case
    methods
        function self=EllipsoidTestCase(varargin)
            self=self@mlunitext.test_case(varargin{:});
        end
        function self = testDistance(self)
            
            global  ellOptions;
            
            %distance between ellipsoid and two vectors
            testEllipsoid = ellipsoid([1,0,0;0,5,0;0,0,10]);
            testPointArray = [3,0,0; 5,0,0].';
            testResArray = distance(testEllipsoid, testPointArray);
            mlunit.assert_equals(1, (abs(testResArray(1)-2)<ellOptions.abs_tol) &&...
                (abs(testResArray(2)-4)<ellOptions.abs_tol));
            
            %distance between ellipsoid and point in the ellipsoid
            %and point on the boader of the ellipsoid
            testEllipsoid = ellipsoid([1,2,3].',0.25*eye(3,3));
            testPointArray = [2,3,2; 1,2,5].';
            testResArray = distance(testEllipsoid, testPointArray);
            mlunit.assert_equals(1, testResArray(1)==-1 && testResArray(2)==0);
            
            
            %distance between two ellipsoids and two vectors
            testEllipsoidArray = [ellipsoid([5,2,0;2,5,0;0,0,1]),...
                ellipsoid([0,0,5].',[1/4, 0, 0; 0, 1/9 , 0; 0,0, 1/25])];
            testPointArray = [0,0,5; 0,5,5].';
            testResArray = distance(testEllipsoidArray, testPointArray);
            mlunit.assert_equals(1, (abs(testResArray(1)-4)<ellOptions.abs_tol) &&...
                (abs(testResArray(2)-2)<ellOptions.abs_tol));
           
            
            %distance between two ellipsoids and a vector
            testEllipsoidArray = [ellipsoid([5,5,0].',[1,0,0;0,5,0;0,0,10]),...
                ellipsoid([0,10,0].',[10, 0, 0; 0, 1/16 , 0; 0,0, 5])];
            testPointVec = [0,5,0].';
            testResArray = distance(testEllipsoidArray, testPointVec);
            mlunit.assert_equals(1, (abs(testResArray(1)-4)<ellOptions.abs_tol) &&...
                (abs(testResArray(2)-1)<ellOptions.abs_tol));
           
            %negative test: matrix Q of ellipsoid has very large
            %eigenvalues.
            testEllipsoid = ellipsoid([1e+15,0;0,1e+15]);
            testPointVec = [3e+15,0].';
            self.runAndCheckError('distance(testEllipsoid, testPointVec)','NotSecant');
            
         end
    end
end