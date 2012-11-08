classdef EllipsoidTestCase < mlunitext.test_case

% $Author: Rustam Guliev, Moscow State University by M.V. Lomonosov,
% Faculty of Computational Mathematics and Cybernetics, System Analysis
% Department, 23-October-2012, <glvrst@gmail.com>$

    methods
        function self = EllipsoidTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        function self = testEllipsoid(self)
            %Empty ellipsoid
            testEllipsoid=ellipsoid;
            [testCenterVec, testShapeMat]=double(testEllipsoid);
            isTestRes=isempty(testCenterVec)&&isempty(testShapeMat);
            mlunit.assert_equals(true, isTestRes);
            %One argument
            testEllipsoid=ellipsoid(diag([1 4 9 16]));
            [testCenterVec, testShapeMat]=double(testEllipsoid);
            isTestDiagMat=testShapeMat==diag([1 4  9 16]);
            isTestRes=(numel(testCenterVec)==4) && all(testCenterVec(:)==0)&& all(isTestDiagMat(:));
            mlunit.assert_equals(true, isTestRes);
            %Two arguments
            testEllipsoid=ellipsoid([1; 2; -1],[2.5 -1.5 0; -1.5 2.5 0; 0 0 9]);
            [testCenterVec, testShapeMat]=double(testEllipsoid);
            isTestCVec=testCenterVec==[1;2;-1];
            isTestEyeMat=testShapeMat==[2.5 -1.5 0; -1.5 2.5 0; 0 0 9];
            isTestRes= all(isTestCVec(:))&& all(isTestEyeMat(:));
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoid=ellipsoid(-2*ones(5,1),9*eye(5,5));
            [testCenterVec, testShapeMat]=double(testEllipsoid);
            isTestEyeMat=testShapeMat==9*eye(5,5);
            isTestRes=(numel(testCenterVec)==5) && all(testCenterVec(:)==-2)&& all(isTestEyeMat(:));
            mlunit.assert_equals(true, isTestRes);
            
            %Check wrong inputs
            self.runAndCheckError('ellipsoid(1,2,3)','wrongInput:tooManyArgs');
            self.runAndCheckError('ellipsoid([1 1],eye(2,2))','wrongInput:wrongCenter');
            self.runAndCheckError('ellipsoid([1 1;0 1])','wrongInput:wrongMat');
            self.runAndCheckError('ellipsoid([-1 0;0 -1])','wrongInput:wrongMat');
            self.runAndCheckError('ellipsoid([1;1],eye(3,3))','wrongInput:dimsMismatch');
            
            self.runAndCheckError('ellipsoid([1 -i;-i 1])','wrongInput:imagArgs');
            self.runAndCheckError('ellipsoid([1+i;1],eye(2,2))','wrongInput:imagArgs');
            self.runAndCheckError('ellipsoid([1;0],(1+i)*eye(2,2))','wrongInput:imagArgs');
        end
        function self = testDouble(self)
            %Empty ellipsoid
            testEllipsoid=ellipsoid;
            [testCenterVec, testShapeMat]=double(testEllipsoid);
            isTestRes=isempty(testCenterVec)&&isempty(testShapeMat);
            mlunit.assert_equals(true, isTestRes);
            
            %Chek for one output argument
            testEllipsoid=ellipsoid(-ones(5,1),eye(5,5));
            testShapeMat=double(testEllipsoid);
            isTestEyeMat=testShapeMat==eye(5,5);
            isTestRes=all(isTestEyeMat(:));
            mlunit.assert_equals(true, isTestRes);
            
            %Chek for two output arguments
            testEllipsoid=ellipsoid(-(1:10)',eye(10,10));
            [testCenterVec, testShapeMat]=double(testEllipsoid);
            isTestRes=(size(testCenterVec,1)==10)&&(size(testCenterVec,2)==1)&&...
                (size(testShapeMat,1)==10)&&(size(testShapeMat,2)==10);
            mlunit.assert_equals(true, isTestRes);
        end
        function self = testParameters(self)
            %Empty ellipsoid
            testEllipsoid=ellipsoid;
            [testCenterVec, testShapeMat]=parameters(testEllipsoid);
            isTestRes=isempty(testCenterVec)&&isempty(testShapeMat);
            mlunit.assert_equals(true, isTestRes);
            
            %Chek for one output argument
            testEllipsoid=ellipsoid(-ones(5,1),eye(5,5));
            testShapeMat=parameters(testEllipsoid);
            isTestEyeMat=testShapeMat==eye(5,5);
            isTestRes=all(isTestEyeMat(:));
            mlunit.assert_equals(true, isTestRes);
            
            %Chek for two output arguments
            testEllipsoid=ellipsoid(-(1:10)',eye(10,10));
            [testCenterVec, testShapeMat]=parameters(testEllipsoid);
            isTestRes=(size(testCenterVec,1)==10)&&(size(testCenterVec,2)==1)&&...
                (size(testShapeMat,1)==10)&&(size(testShapeMat,2)==10);
            mlunit.assert_equals(true, isTestRes);
        end
        function self = testDimension(self)
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
            isTestRes=(testDim==0)&&(testRank==0);
            mlunit.assert_equals(true, isTestRes);
            
            %Case 2: Not empty ellipsoid
            testEllipsoid=ellipsoid(ones(4,1), eye(4,4));
            [testDim, testRank]= dimension(testEllipsoid);
            isTestRes=(testDim==4)&&(testRank==4);
            mlunit.assert_equals(true, isTestRes);
            
            testAMat=[ 3 1;0 1; -2 1];
            testEllipsoid=ellipsoid(testAMat*(testAMat'));
            [testDim, testRank]= dimension(testEllipsoid);
            isTestRes=(testDim==3)&&(testRank==2);
            mlunit.assert_equals(true, isTestRes);
        end
        function self = testIsDegenerate(self)
            %Empty ellipsoid
            self.runAndCheckError('isdegenerate(ellipsoid)','wrongInput:emptyEllipsoid');
            
            %Not degerate ellipsoid
            testEllipsoid=ellipsoid(ones(6,1),eye(6,6));
            isTestRes = isdegenerate(testEllipsoid);
            mlunit.assert_equals(false, isTestRes);
            
            %Degenerate ellipsoids
            testEllipsoid=ellipsoid(ones(6,1),zeros(6,6));
            isTestRes = isdegenerate(testEllipsoid);
            mlunit.assert_equals(true, isTestRes);
            
            testAMat=[ 3 1;0 1; -2 1];
            testEllipsoid=ellipsoid(testAMat*(testAMat.'));
            isTestRes=isdegenerate(testEllipsoid);
            mlunit.assert_equals(true, isTestRes);
        end
        function self = testIsEmpty(self)
            %Chek realy empty ellipsoid
            testEllipsoid=ellipsoid;
            isTestRes = isempty(testEllipsoid);
            mlunit.assert_equals(true, isTestRes);
            
            %Chek not empty ellipsoid
            testEllipsoid=ellipsoid(eye(10,1),eye(10,10));
            isTestRes = isempty(testEllipsoid);
            mlunit.assert_equals(false, isTestRes);
        end
        function self = testMaxEig(self)
            %Check empty ellipsoid
            self.runAndCheckError('maxeig(ellipsoid)','wrongInput:emptyEllipsoid');
            
            %Check degenerate matrix
            testEllipsoid1=ellipsoid([1; 1], zeros(2,2));
            testEllipsoid2=ellipsoid(zeros(2,2));
            isTestRes=(maxeig(testEllipsoid1)==0)&&(maxeig(testEllipsoid2)==0);
            mlunit.assert_equals(true, isTestRes);
            
            %Check on diaganal matrix
            testEllipsoid=ellipsoid(diag(1:0.2:5.2));
            isTestRes=(maxeig(testEllipsoid)==5.2);
            mlunit.assert_equals(true, isTestRes);
            
            %Check on not diaganal matrix
            testEllipsoid=ellipsoid([1 1 -1; 1 4 -3; -1 -3 9]);
            isTestRes=( (maxeig(testEllipsoid)-max(eig([1 1 -1; 1 4 -3; -1 -3 9])))<=eps );
            mlunit.assert_equals(true, isTestRes);
        end
        function self = testMinEig(self)
            %Check empty ellipsoid
            self.runAndCheckError('mineig(ellipsoid)','wrongInput:emptyEllipsoid');
            
            %Check degenerate matrix
            testEllipsoid1=ellipsoid([-2; -2], zeros(2,2));
            testEllipsoid2=ellipsoid(zeros(2,2));
            isTestRes=(mineig(testEllipsoid1)==0)&&(mineig(testEllipsoid2)==0);
            mlunit.assert_equals(true, isTestRes);
            
            %Check on diaganal matrix
            testEllipsoid=ellipsoid(diag(4:-0.2:1.2));
            isTestRes=(mineig(testEllipsoid)==1.2);
            mlunit.assert_equals(true, isTestRes);
            
            %Check on not diaganal matrix
            testEllipsoid=ellipsoid([1 1 -1; 1 4 -4; -1 -4 9]);
            isTestRes=( (mineig(testEllipsoid)-min(eig([1 1 -1; 1 4 -3; -1 -3 9])))<=eps );
            mlunit.assert_equals(true, isTestRes);
        end
        function self = testTrace(self)
            %Empty ellipsoid
            self.runAndCheckError('trace(ellipsoid)','wrongInput:emptyEllipsoid');
            
            %Not empty ellipsoid
            testEllipsoid=ellipsoid(zeros(10,1),eye(10,10));
            isTestRes=trace(testEllipsoid)==10;
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoid=ellipsoid(-eye(3,1),[1 0 1; 0 0 0; 1 0 2 ]);
            isTestRes=trace(testEllipsoid)==3;
            mlunit.assert_equals(true, isTestRes);
        end
        function self = testVolume(self)
            
            %Check empty ellipsoid
            self.runAndCheckError('volume(ellipsoid)','wrongInput:emptyEllipsoid');
            
            %Check degenerate ellipsoid
            testEllipsoid=ellipsoid([1 0 0;0 1 0;0 0 0]);
            isTestRes=volume(testEllipsoid)==0;
            mlunit.assert_equals(true, isTestRes);
            
            %Check dim=1 with two different centers
            testEllipsoid1=ellipsoid(2,1);
            testEllipsoid2=ellipsoid(1);
            isTestRes=(volume(testEllipsoid1)==2)&&(volume(testEllipsoid2)==2);
            mlunit.assert_equals(true, isTestRes);
            
            %Check dim=2 with two different centers
            testEllipsoid1=ellipsoid([1; -1],eye(2,2));
            testEllipsoid2=ellipsoid(eye(2,2));
            isTestRes=( (volume(testEllipsoid1)-pi)<=eps )&&( (volume(testEllipsoid2)-pi)<=eps );
            mlunit.assert_equals(true, isTestRes);
            
            %Chek dim=3 with not diaganal matrix
            testEllipsoid=ellipsoid([1 1 -1; 1 4 -3; -1 -3 9]);
            isTestRes=( (volume(testEllipsoid)-(8*sqrt(5)*pi/3)<=eps ) );
            mlunit.assert_equals(true, isTestRes);
            
            %Check dim=5
            testEllipsoid=ellipsoid(4*ones(5,1),eye(5,5));
            isTestRes=( (volume(testEllipsoid)-(256*pi*pi/15)<=eps ) );
            mlunit.assert_equals(true, isTestRes);
            %Check dim=6
            testEllipsoid=ellipsoid(-ones(6,1),diag([1, 4, 9, 16,1, 25]));
            isTestRes=( (volume(testEllipsoid)-(20*pi*pi*pi)<=eps ) );
            mlunit.assert_equals(true, isTestRes);
        end
        function self = testMinkMP(self)
            global ellOptions;
            testTol=ellOptions.abs_tol;
            %1D case
            testEllipsoidMin=ellipsoid(2,4);
            testEllipsoidSub=ellipsoid(2,9);
            testEllipsoidSum1=ellipsoid(1,25);
            testEllipsoidSum2=ellipsoid(2,16);
            [testCenter testPointsVec]=minkmp(testEllipsoidMin,testEllipsoidSub,[testEllipsoidSum1,testEllipsoidSum2]);
            isTestRes = isempty(testCenter) && isempty(testPointsVec);
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoidMin=ellipsoid(2,4);
            testEllipsoidSub=ellipsoid(2,0);
            testEllipsoidSum=ellipsoid(1,0);
            [testCenter testPointsVec]=minkmp(testEllipsoidMin,testEllipsoidSub,testEllipsoidSum);
            isTestRes = (testCenter==1) && all( (abs(testPointsVec-1)-2) <= testTol);
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoidMin=ellipsoid(4);
            testEllipsoidSub=ellipsoid(1);
            testEllipsoidSum=ellipsoid(0);
            [testCenter testPointsVec]=minkmp(testEllipsoidMin,testEllipsoidSub,testEllipsoidSum);
            isTestRes = (testCenter==0) && all( (abs(testPointsVec)-1)<= testTol );
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoidMin=ellipsoid(4);
            testEllipsoidSub=ellipsoid(0);
            testEllipsoidSum=ellipsoid(0.25);
            [testCenter testPointsVec]=minkmp(testEllipsoidMin,testEllipsoidSub,testEllipsoidSum);
            isTestRes = (testCenter==0) && all( (abs(testPointsVec)-2.5)<= testTol );
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoidMin=ellipsoid(1,4);
            testEllipsoidSub=ellipsoid(1,2.25);
            testEllipsoidSum1=ellipsoid(1,0);
            testEllipsoidSum2=ellipsoid(1,1);
            testEllipsoidSum3=ellipsoid(1,9);
            [testCenter testPointsVec]=minkmp(testEllipsoidMin,testEllipsoidSub,[testEllipsoidSum1, testEllipsoidSum2, testEllipsoidSum3]);
            isTestRes = (testCenter==3) && all( (abs(testPointsVec-3)-4.5) <= testTol);
            mlunit.assert_equals(true, isTestRes);
            
            %2D case
            testEllipsoidMin=ellipsoid([2;2], 4*eye(2,2));
            testEllipsoidSub=ellipsoid([2;1], 16*eye(2,2));
            testEllipsoidSum1=ellipsoid([2;1], 25*eye(2,2));
            testEllipsoidSum2=ellipsoid([2;1], 36*eye(2,2));
            [testCenterVec testPointsMat]=minkmp(testEllipsoidMin,testEllipsoidSub,[testEllipsoidSum1, testEllipsoidSum2]);
            isTestRes = isempty(testCenterVec) && isempty( testPointsMat);
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoidMin=ellipsoid([2;2], 4*eye(2,2));
            testEllipsoidSub=ellipsoid([2;1], zeros(2,2));
            testEllipsoidSum=ellipsoid([2;1], zeros(2,2));
            [testCenterVec testPointsMat]=minkmp(testEllipsoidMin,testEllipsoidSub,testEllipsoidSum);
            testDistSqr = (testPointsMat(1,:)-testCenterVec(1)).*(testPointsMat(1,:)-testCenterVec(1))...
                +(testPointsMat(2,:)-testCenterVec(2)).*(testPointsMat(2,:)-testCenterVec(2));
            isTestRes = all( testCenterVec==2 ) && all( abs(testDistSqr - 4) <= testTol );
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoidMin=ellipsoid(4*eye(2,2));
            testEllipsoidSub=ellipsoid([1 0;0 0]);
            testEllipsoidSum=ellipsoid(zeros(2,2));
            [testCenterVec testPointsMat]=minkmp(testEllipsoidMin,testEllipsoidSub,testEllipsoidSum);
            testDistSqr1 = (testPointsMat(1,:)-1).*(testPointsMat(1,:)-1)+(testPointsMat(2,:)).*(testPointsMat(2,:));
            testDistSqr2 = (testPointsMat(1,:)+1).*(testPointsMat(1,:)+1)+(testPointsMat(2,:)).*(testPointsMat(2,:));
            isTestRes = all( testCenterVec==0 ) && all( (abs(testDistSqr1 - 4) <= 0.000001) | (abs(testDistSqr2 - 4) <= 0.000001) );
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoidMin=ellipsoid([4 0; 0 9]);
            testEllipsoidSub=ellipsoid(4*eye(2,2));
            testEllipsoidSum1=ellipsoid([1;0],eye(2,2));
            testEllipsoidSum2=ellipsoid([0;1],eye(2,2));
            [testCenterVec testPointsMat]=minkmp(testEllipsoidMin,testEllipsoidSub,[testEllipsoidSum1 testEllipsoidSum2]);
            testDistSqr = (testPointsMat(1,:)-1).*(testPointsMat(1,:)-1)+(testPointsMat(2,:)-1).*(testPointsMat(2,:)-1);
            isTestRes = all( testCenterVec==1 ) && all( (abs(testDistSqr - 4) <= testTol) );
            mlunit.assert_equals(true, isTestRes);
             
            testEllipsoidMin=ellipsoid([2;2], 4*eye(2,2));
            testEllipsoidSub=ellipsoid([2;1], eye(2,2));
            testEllipsoidSum1=ellipsoid([1;1], eye(2,2));
            testEllipsoidSum2=ellipsoid([1;0], 9*eye(2,2));
            [testCenterVec testPointsMat]=minkmp(testEllipsoidMin,testEllipsoidSub,[testEllipsoidSum1 testEllipsoidSum2]);
            testDistSqr = (testPointsMat(1,:)-testCenterVec(1)).*(testPointsMat(1,:)-testCenterVec(1))+(testPointsMat(2,:)-testCenterVec(2)).*(testPointsMat(2,:)-testCenterVec(2));
            isTestRes = all( testCenterVec==2 ) && all( abs(testDistSqr - 25) <= testTol );
            mlunit.assert_equals(true, isTestRes);
            
            %3D case
            testEllipsoidMin=ellipsoid(eye(3,3));
            testEllipsoidSub=ellipsoid(2.25*eye(3,3));
            testEllipsoidSum1=ellipsoid([1;0;0], 25*eye(3,3));
            testEllipsoidSum2=ellipsoid([0;1;0], 36*eye(3,3));
            [testCenterVec testPointsMat]=minkmp(testEllipsoidMin,testEllipsoidSub,[testEllipsoidSum1, testEllipsoidSum2]);
            isTestRes = isempty(testCenterVec) && isempty( testPointsMat);
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoidMin=ellipsoid([1;1;1], diag([1,4,9]));
            testEllipsoidSub=ellipsoid([2;1;-1], zeros(3,3));
            testEllipsoidSum=ellipsoid([2;1;-1], zeros(3,3));
            [testCenterVec testPointsMat]=minkmp(testEllipsoidMin,testEllipsoidSub,testEllipsoidSum);
            testDistSqr = (testPointsMat(1,:)-testCenterVec(1)).*(testPointsMat(1,:)-testCenterVec(1)) +...
                (testPointsMat(2,:)-testCenterVec(2)).*(testPointsMat(2,:)-testCenterVec(2))/4+...
                (testPointsMat(3,:)-testCenterVec(3)).*(testPointsMat(3,:)-testCenterVec(3))/9;
            isTestRes = all( testCenterVec==1 ) && all( abs(testDistSqr - 1) <= testTol );
            mlunit.assert_equals(true, isTestRes);
            
            testEllipsoidMin=ellipsoid([1;1;1], 25*eye(3,3));
            testEllipsoidSub=ellipsoid([1;0;1], 4*eye(3,3));
            testEllipsoidSum=ellipsoid([0;-1;0], eye(3,3));
            [testCenterVec testPointsMat]=minkmp(testEllipsoidMin,testEllipsoidSub,testEllipsoidSum);
            testDistSqr = (testPointsMat(1,:)-testCenterVec(1)).*(testPointsMat(1,:)-testCenterVec(1)) +...
                (testPointsMat(2,:)-testCenterVec(2)).*(testPointsMat(2,:)-testCenterVec(2))+...
                (testPointsMat(3,:)-testCenterVec(3)).*(testPointsMat(3,:)-testCenterVec(3));
            isTestRes = all( testCenterVec==0 ) && all( abs(testDistSqr - 16) <= testTol );
            mlunit.assert_equals(true, isTestRes);
            
            
            testEllipsoidMin=ellipsoid(diag([25,4,9]));
            testEllipsoidSub=ellipsoid(4*eye(3,3));
            testEllipsoidSum1=ellipsoid([1;0;-1], eye(3,3));
            testEllipsoidSum2=ellipsoid([0;1;2], eye(3,3));
            testEllipsoidSum3=ellipsoid(eye(3,3));
            [testCenterVec testPointsMat]=minkmp(testEllipsoidMin,testEllipsoidSub,[testEllipsoidSum1, testEllipsoidSum2, testEllipsoidSum3]);
            testDistSqr = (testPointsMat(1,:)-testCenterVec(1)).*(testPointsMat(1,:)-testCenterVec(1)) +...
                (testPointsMat(2,:)-testCenterVec(2)).*(testPointsMat(2,:)-testCenterVec(2))+...
                (testPointsMat(3,:)-testCenterVec(3)).*(testPointsMat(3,:)-testCenterVec(3));
            isTestRes = all( testCenterVec==1 ) && all( abs(testDistSqr - 9) <= testTol );
            mlunit.assert_equals(true, isTestRes);
        end
    end      
end
