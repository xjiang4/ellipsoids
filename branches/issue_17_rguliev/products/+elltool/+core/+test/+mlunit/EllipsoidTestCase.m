classdef EllipsoidTestCase < mlunitext.test_case

% $Author: Rustam Guliev, Moscow State University by M.V. Lomonosov,
% Faculty of Computational Mathematics and Cybernetics, System Analysis
% Department, 23-October-2012, <glvrst@gmail.com>$

    methods
        function self = EllipsoidTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        %function self = testEllipsoid(self)
        %end
        function self = testDouble(self)
            %Empty ellipsoid
            testEllipsoid=ellipsoid;
            [testCenter, testMatrix]=double(testEllipsoid);
            testRes=isempty(testCenter)&&isempty(testMatrix);
            mlunit.assert_equals(1, testRes);
            
            %Chek for one output argument
            testEllipsoid=ellipsoid(-ones(5,1),eye(5,5));
            testMatrix=double(testEllipsoid);
            testIsEye=testMatrix==eye(5,5);
            testRes=min(testIsEye(1:end));
            mlunit.assert_equals(1, testRes);
            
            %Chek for two output arguments
            testEllipsoid=ellipsoid(-(1:10)',eye(10,10));
            [testCenter, testMatrix]=double(testEllipsoid);
            testRes=(size(testCenter,1)==10)&&(size(testCenter,2)==1)&&...
                (size(testMatrix,1)==10)&&(size(testMatrix,2)==10);
            mlunit.assert_equals(1, testRes);
        end
        function self=testParameters(self)
            %Empty ellipsoid
            testEllipsoid=ellipsoid;
            [testCenter, testMatrix]=parameters(testEllipsoid);
            testRes=isempty(testCenter)&&isempty(testMatrix);
            mlunit.assert_equals(1, testRes);
            
            %Chek for one output argument
            testEllipsoid=ellipsoid(-ones(5,1),eye(5,5));
            testMatrix=parameters(testEllipsoid);
            testIsEye=testMatrix==eye(5,5);
            testRes=min(testIsEye(1:end));
            mlunit.assert_equals(1, testRes);
            
            %Chek for two output arguments
            testEllipsoid=ellipsoid(-(1:10)',eye(10,10));
            [testCenter, testMatrix]=parameters(testEllipsoid);
            testRes=(size(testCenter,1)==10)&&(size(testCenter,2)==1)&&...
                (size(testMatrix,1)==10)&&(size(testMatrix,2)==10);
            mlunit.assert_equals(1, testRes);
        end
        function self=testDimension(self)
            %Chek for one output argument
            %Case 1: Empty ellipsoid
            testEllipsoid=ellipsoid;
            testRes = dimension(testEllipsoid);
            mlunit.assert_equals(0, testRes);
            %Case 2: Not empty ellipsoid
            testEllipsoid=ellipsoid(0);
            testRes = dimension(testEllipsoid);
            mlunit.assert_equals(1, testRes);
            
            testEllipsoid=ellipsoid(eye(5,5));
            testRes = dimension(testEllipsoid);
            mlunit.assert_equals(5, testRes);
            
            %Chek for two output arguments
            %Case 1: Empty ellipsoid
            testEllipsoid=ellipsoid;
            [testDim, testRank]= dimension(testEllipsoid);
            testRes=(testDim==0)&&(testRank==0);
            mlunit.assert_equals(1, testRes);
            
            %Case 2: Not empty ellipsoid
            testEllipsoid=ellipsoid(ones(4,1), eye(4,4));
            [testDim, testRank]= dimension(testEllipsoid);
            testRes=(testDim==4)&&(testRank==4);
            mlunit.assert_equals(1, testRes);
            
            testA=[ 3 1;0 1; -2 1];
            testEllipsoid=ellipsoid(testA*(testA'));
            [testDim, testRank]= dimension(testEllipsoid);
            testRes=(testDim==3)&&(testRank==2);
            mlunit.assert_equals(1, testRes);
        end
        %function self=testIsDegenerate(self)
        %end
        function self=testIsEmpty(self)
            %Chek realy empty ellipsoid
            testEllipsoid=ellipsoid;
            testRes = isempty(testEllipsoid);
            mlunit.assert_equals(1, testRes);
            
            %Chek not empty ellipsoid
            testEllipsoid=ellipsoid(eye(10,1),eye(10,10));
            testRes = isempty(testEllipsoid);
            mlunit.assert_equals(0, testRes);
        end
        %function self = testMaxeig(self)
        %end
        %function self = testMineig(self)
        %end
        %function self = testTrace(self)
        %end
        %function self = testVolume(self)
        %end
    end      
end
