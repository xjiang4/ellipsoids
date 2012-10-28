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
            [TestCenterVec, TestShapeMat]=double(testEllipsoid);
            isTestRes=isempty(TestCenterVec)&&isempty(TestShapeMat);
            mlunit.assert_equals(1, isTestRes);
            
            %Chek for one output argument
            testEllipsoid=ellipsoid(-ones(5,1),eye(5,5));
            TestShapeMat=double(testEllipsoid);
            isTestEyeMat=TestShapeMat==eye(5,5);
            isTestRes=all(isTestEyeMat(:));
            mlunit.assert_equals(1, isTestRes);
            
            %Chek for two output arguments
            testEllipsoid=ellipsoid(-(1:10)',eye(10,10));
            [TestCenterVec, TestShapeMat]=double(testEllipsoid);
            isTestRes=(size(TestCenterVec,1)==10)&&(size(TestCenterVec,2)==1)&&...
                (size(TestShapeMat,1)==10)&&(size(TestShapeMat,2)==10);
            mlunit.assert_equals(1, isTestRes);
        end
        function self = testParameters(self)
            %Empty ellipsoid
            testEllipsoid=ellipsoid;
            [TestCenterVec, TestShapeMat]=parameters(testEllipsoid);
            isTestRes=isempty(TestCenterVec)&&isempty(TestShapeMat);
            mlunit.assert_equals(1, isTestRes);
            
            %Chek for one output argument
            testEllipsoid=ellipsoid(-ones(5,1),eye(5,5));
            TestShapeMat=parameters(testEllipsoid);
            isTestEyeMat=TestShapeMat==eye(5,5);
            isTestRes=all(isTestEyeMat(:));
            mlunit.assert_equals(1, isTestRes);
            
            %Chek for two output arguments
            testEllipsoid=ellipsoid(-(1:10)',eye(10,10));
            [TestCenterVec, TestShapeMat]=parameters(testEllipsoid);
            isTestRes=(size(TestCenterVec,1)==10)&&(size(TestCenterVec,2)==1)&&...
                (size(TestShapeMat,1)==10)&&(size(TestShapeMat,2)==10);
            mlunit.assert_equals(1, isTestRes);
        end
        function self = testDimension(self)
            %Chek for one output argument
            %Case 1: Empty ellipsoid
            testEllipsoid=ellipsoid;
            isTestRes = dimension(testEllipsoid);
            mlunit.assert_equals(0, isTestRes);
            %Case 2: Not empty ellipsoid
            testEllipsoid=ellipsoid(0);
            isTestRes = dimension(testEllipsoid);
            mlunit.assert_equals(1, isTestRes);
            
            testEllipsoid=ellipsoid(eye(5,5));
            isTestRes = dimension(testEllipsoid)==5;
            mlunit.assert_equals(1, isTestRes);
            
            %Chek for two output arguments
            %Case 1: Empty ellipsoid
            testEllipsoid=ellipsoid;
            [testDim, testRank]= dimension(testEllipsoid);
            isTestRes=(testDim==0)&&(testRank==0);
            mlunit.assert_equals(1, isTestRes);
            
            %Case 2: Not empty ellipsoid
            testEllipsoid=ellipsoid(ones(4,1), eye(4,4));
            [testDim, testRank]= dimension(testEllipsoid);
            isTestRes=(testDim==4)&&(testRank==4);
            mlunit.assert_equals(1, isTestRes);
            
            testAMat=[ 3 1;0 1; -2 1];
            testEllipsoid=ellipsoid(testAMat*(testAMat'));
            [testDim, testRank]= dimension(testEllipsoid);
            isTestRes=(testDim==3)&&(testRank==2);
            mlunit.assert_equals(1, isTestRes);
        end
        function self = testIsDegenerate(self)
            %Empty ellipsoid
            self.runAndCheckError('isdegenerate(ellipsoid)','wrongInput:emptyEllipsoid');
            
            %Not degerate ellipsoid
            testEllipsoid=ellipsoid(ones(6,1),eye(6,6));
            isTestRes = isdegenerate(testEllipsoid);
            mlunit.assert_equals(0, isTestRes);
            
            %Degenerate ellipsoids
            testEllipsoid=ellipsoid(ones(6,1),zeros(6,6));
            isTestRes = isdegenerate(testEllipsoid);
            mlunit.assert_equals(1, isTestRes);
            
            testAMat=[ 3 1;0 1; -2 1];
            testEllipsoid=ellipsoid(testAMat*(testAMat'));
            isTestRes=isdegenerate(testEllipsoid);
            mlunit.assert_equals(1, isTestRes);
        end
        function self = testIsEmpty(self)
            %Chek realy empty ellipsoid
            testEllipsoid=ellipsoid;
            isTestRes = isempty(testEllipsoid);
            mlunit.assert_equals(1, isTestRes);
            
            %Chek not empty ellipsoid
            testEllipsoid=ellipsoid(eye(10,1),eye(10,10));
            isTestRes = isempty(testEllipsoid);
            mlunit.assert_equals(0, isTestRes);
        end
        function self = testMaxeig(self)
            %Check empty ellipsoid
            self.runAndCheckError('maxeig(ellipsoid)','wrongInput:emptyEllipsoid');
            
            %Check degenerate matrix
            testEllipsoid1=ellipsoid([1; 1], zeros(2,2));
            testEllipsoid2=ellipsoid(zeros(2,2));
            isTestRes=(maxeig(testEllipsoid1)==0)&&(maxeig(testEllipsoid2)==0);
            mlunit.assert_equals(1, isTestRes);
            
            %Check on diaganal matrix
            testEllipsoid=ellipsoid(diag(1:0.2:5.2));
            isTestRes=(maxeig(testEllipsoid)==5.2);
            mlunit.assert_equals(1, isTestRes);
            
            %Check on not diaganal matrix
            testEllipsoid=ellipsoid([1 1 -1; 1 4 -3; -1 -3 9]);
            isTestRes=( (maxeig(testEllipsoid)-max(eig([1 1 -1; 1 4 -3; -1 -3 9])))<=eps );
            mlunit.assert_equals(1, isTestRes);
        end
        function self = testMineig(self)
            %Check empty ellipsoid
            self.runAndCheckError('mineig(ellipsoid)','wrongInput:emptyEllipsoid');
            
            %Check degenerate matrix
            testEllipsoid1=ellipsoid([-2; -2], zeros(2,2));
            testEllipsoid2=ellipsoid(zeros(2,2));
            isTestRes=(mineig(testEllipsoid1)==0)&&(mineig(testEllipsoid2)==0);
            mlunit.assert_equals(1, isTestRes);
            
            %Check on diaganal matrix
            testEllipsoid=ellipsoid(diag(4:-0.2:1.2));
            isTestRes=(mineig(testEllipsoid)==1.2);
            mlunit.assert_equals(1, isTestRes);
            
            %Check on not diaganal matrix
            testEllipsoid=ellipsoid([1 1 -1; 1 4 -4; -1 -4 9]);
            isTestRes=( (mineig(testEllipsoid)-min(eig([1 1 -1; 1 4 -3; -1 -3 9])))<=eps );
            mlunit.assert_equals(1, isTestRes);
        end
        function self = testTrace(self)
            %Empty ellipsoid
            self.runAndCheckError('trace(ellipsoid)','wrongInput:emptyEllipsoid');
            
            %Not empty ellipsoid
            testEllipsoid=ellipsoid(zeros(10,1),eye(10,10));
            isTestRes=trace(testEllipsoid)==10;
            mlunit.assert_equals(1, isTestRes);
            
            testEllipsoid=ellipsoid(-eye(3,1),[1 0 1; 0 0 0; 1 0 2 ]);
            isTestRes=trace(testEllipsoid)==3;
            mlunit.assert_equals(1, isTestRes);
        end
        function self = testVolume(self)
            
            %Check empty ellipsoid
            self.runAndCheckError('volume(ellipsoid)','wrongInput:emptyEllipsoid');
            
            %Check degenerate ellipsoid
            testEllipsoid=ellipsoid([1 0 0;0 1 0;0 0 0]);
            isTestRes=volume(testEllipsoid)==0;
            mlunit.assert_equals(1, isTestRes);
            
            %Check dim=1 with two different centers
            testEllipsoid1=ellipsoid(2,1);
            testEllipsoid2=ellipsoid(1);
            isTestRes=(volume(testEllipsoid1)==2)&&(volume(testEllipsoid2)==2);
            mlunit.assert_equals(1, isTestRes);
            
            %Check dim=2 with two different centers
            testEllipsoid1=ellipsoid([1; -1],eye(2,2));
            testEllipsoid2=ellipsoid(eye(2,2));
            isTestRes=( (volume(testEllipsoid1)-pi)<=eps )&&( (volume(testEllipsoid2)-pi)<=eps );
            mlunit.assert_equals(1, isTestRes);
            
            %Chek dim=3 with not diaganal matrix
            testEllipsoid=ellipsoid([1 1 -1; 1 4 -3; -1 -3 9]);
            isTestRes=( (volume(testEllipsoid)-(8*sqrt(5)*pi/3)<=eps ) );
            mlunit.assert_equals(1, isTestRes);
            
            %Check dim=5
            testEllipsoid=ellipsoid(4*ones(5,1),eye(5,5));
            isTestRes=( (volume(testEllipsoid)-(256*pi*pi/15)<=eps ) );
            mlunit.assert_equals(1, isTestRes);
            %Check dim=6
            testEllipsoid=ellipsoid(-ones(6,1),diag([1, 4, 9, 16,1, 25]));
            isTestRes=( (volume(testEllipsoid)-(20*pi*pi*pi)<=eps ) );
            mlunit.assert_equals(1, isTestRes);
        end
    end      
end
