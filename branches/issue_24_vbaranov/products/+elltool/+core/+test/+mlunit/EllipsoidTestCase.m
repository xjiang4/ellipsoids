classdef EllipsoidTestCase < mlunitext.test_case
    methods
        function self=EllipsoidTestCase(varargin)
            self=self@mlunitext.test_case(varargin{:});
        end
        function self = testDistance(self)
            
            global  ellOptions;
            
            %distance between ellipsoid and two vectors
            testEllipsoid = ellipsoid([1,0,0;0,5,0;0,0,10]);
            testPoints = [3,0,0; 5,0,0]';
            testRes = distance(testEllipsoid, testPoints);
            mlunit.assert_equals(1, (abs(testRes(1)-2)<ellOptions.abs_tol) &&...
                (abs(testRes(2)-4)<ellOptions.abs_tol));
            
            %distance between ellipsoid and point in the ellipsoid
            %and point on the boader of the ellipsoid
            testEllipsoid = ellipsoid([1,2,3]',0.25*eye(3,3));
            testPoints = [2,3,2; 1,2,5]';
            testRes = distance(testEllipsoid, testPoints);
            mlunit.assert_equals(1, testRes(1)==-1 && testRes(2)==0);
            
            
            %distance between two ellipsoids and two vectors
            testEllipsoids = [ellipsoid([5,2,0;2,5,0;0,0,1]),...
                ellipsoid([0,0,5]',[1/4, 0, 0; 0, 1/9 , 0; 0,0, 1/25])];
            testPoints = [0,0,5; 0,5,5]';
            testRes = distance(testEllipsoids, testPoints);
            mlunit.assert_equals(1, (abs(testRes(1)-4)<ellOptions.abs_tol) &&...
                (abs(testRes(2)-2)<ellOptions.abs_tol));
           
            
            %distance between two ellipsoids and a vector
            testEllipsoids = [ellipsoid([5,5,0]',[1,0,0;0,5,0;0,0,10]),...
                ellipsoid([0,10,0]',[10, 0, 0; 0, 1/16 , 0; 0,0, 5])];
            testPoints = [0,5,0]';
            testRes = distance(testEllipsoids, testPoints);
            mlunit.assert_equals(1, (abs(testRes(1)-4)<ellOptions.abs_tol) &&...
                (abs(testRes(2)-1)<ellOptions.abs_tol));
           
            
            
            
%             testEllipsoid1 = ellipsoid([0,0,0]',[1,0,0; 0,2,0;0,0,4]);
%             testEllipsoid2 = ellipsoid([0,0,4]',[3,0,0; 0,5,0; 0,0,1]);
%             testRes=distance(testEllipsoid1,testEllipsoid2);
%             mlunit.assert_equals(1,abs(testRes-1)<ellOptions.abs_tol);
         end
    end
end