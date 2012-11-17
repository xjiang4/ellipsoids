classdef EllipsoidTestCase < mlunitext.test_case

% $Author: Aushkap Nikolay, Moscow State University by M.V. Lomonosov,
% Faculty of Computational Mathematics and Cybernetics, System Analysis
% Department, 22-October-2012, <n.aushkap@gmail.com>$

    methods
        function self = EllipsoidTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end        
        
        function self = testEq(self)       
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([1; 0], [1 0; 0 1]);
            testEllipsoid3 = ellipsoid([1; 0], [2 0; 0 1]);
            testEllipsoidZeros2 = ellipsoid([0; 0], [0 0; 0 0]);
            testEllipsoidZeros3 = ellipsoid([0; 0; 0], [0 0 0 ;0 0 0; 0 0 0]);
            testEllipsoidEmpty = ellipsoid;
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:6.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:16.5));
            
            testRes = eq(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = eq(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(0, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:10.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:20.5));
            
            testRes = eq(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = eq(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(0, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.1:10.9));
            testEllHighDim2 = ellipsoid(diag(11:0.1:20.9));
            
            testRes = eq(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = eq(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(0, testRes);
            
            testRes = eq(testEllipsoid1, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
                        
            testRes = eq(testEllipsoid2, testEllipsoid1);
            mlunit.assert_equals(0, testRes);    
                  
            testRes = eq(testEllipsoid3, testEllipsoid2);
            mlunit.assert_equals(0, testRes);
                       
            testRes = eq(testEllipsoidZeros2, testEllipsoidZeros3);
            mlunit.assert_equals(0, testRes);
            
            testRes = eq(testEllipsoidZeros2, testEllipsoidEmpty);
            mlunit.assert_equals(0, testRes);
           
            testRes = eq(testEllipsoidEmpty, testEllipsoidEmpty);
            mlunit.assert_equals(1, testRes);
            
            testNotEllipsoid = [];
            %'==: both arguments must be ellipsoids.'
            self.runAndCheckError('eq(testEllipsoidEmpty, testNotEllipsoid)','wrongInput');
            
            %'==: sizes of ellipsoidal arrays do not match.'
            self.runAndCheckError('eq([testEllipsoidEmpty testEllipsoidEmpty], [testEllipsoidEmpty; testEllipsoidEmpty])','wrongSizes');
            
            testRes = eq([testEllipsoidZeros2 testEllipsoidZeros3], [testEllipsoidZeros3 testEllipsoidZeros3]);
            if (testRes == [0 1])
                testRes = 1;
            else 
                testRes = 0;
            end
            mlunit.assert_equals(1, testRes);
        end
        
        
        function self = testNe(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([1; 0], [1 0; 0 1]);
            testEllipsoid3 = ellipsoid([1; 0], [2 0; 0 1]);
            testEllipsoidZeros2 = ellipsoid([0; 0], [0 0; 0 0]);
            testEllipsoidZeros3 = ellipsoid([0; 0; 0], [0 0 0 ;0 0 0; 0 0 0]);
            testEllipsoidEmpty = ellipsoid;
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:6.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:16.5));
            
            testRes = ne(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(0, testRes);
            
            testRes = ne(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(1, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:10.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:20.5));
            
            testRes = ne(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(0, testRes);
            
            testRes = ne(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(1, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.1:10.9));
            testEllHighDim2 = ellipsoid(diag(11:0.1:20.9));
            
            testRes = ne(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(0, testRes);
            
            testRes = ne(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(1, testRes);
            
            testRes = ne(testEllipsoid1, testEllipsoid1);
            mlunit.assert_equals(0, testRes);
                        
            testRes = ne(testEllipsoid2, testEllipsoid1);
            mlunit.assert_equals(1, testRes);    
                  
            testRes = ne(testEllipsoid3, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
                       
            testRes = ne(testEllipsoidZeros2, testEllipsoidZeros3);
            mlunit.assert_equals(1, testRes);
            
            testRes = ne(testEllipsoidZeros2, testEllipsoidEmpty);
            mlunit.assert_equals(1, testRes);
           
            testRes = ne(testEllipsoidEmpty, testEllipsoidEmpty);
            mlunit.assert_equals(0, testRes);
            
            testRes = ne([testEllipsoidZeros2 testEllipsoidZeros3], [testEllipsoidZeros3 testEllipsoidZeros3]);
            if (testRes == [1 0])
                testRes = 1;
            else 
                testRes = 0;
            end
            mlunit.assert_equals(1, testRes);
        end
        
        
        function self = testGe(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid3 = ellipsoid([0; 0], [4 2; 2 4]);
            testEllipsoidEmpty = ellipsoid;
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:6.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:16.5));
            
            testRes = ge(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = ge(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(0, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:10.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:20.5));
            
            testRes = ge(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = ge(testEllHighDim2, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.1:10.9));
            testEllHighDim2 = ellipsoid(diag(11:0.1:20.9));
            
            testRes = ge(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = ge(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(0, testRes);
            
            testRes = ge(testEllipsoid1, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = ge(testEllipsoid2, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = ge(testEllipsoid2, testEllipsoid3);
            mlunit.assert_equals(0, testRes);
            
            testRes = ge([testEllipsoid2 testEllipsoid1], [testEllipsoid1 testEllipsoid2]);
            if (testRes == [1 0])
                testRes = 1;
            else 
                testRes = 0;
            end
            mlunit.assert_equals(1, testRes);
        end    
        
        
        function self = testGt(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid3 = ellipsoid([0; 0], [4 2; 2 4]);
            testEllipsoidEmpty = ellipsoid;
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:6.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:16.5));
            
            testRes = gt(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = gt(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(0, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:10.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:20.5));
            
            testRes = gt(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = gt(testEllHighDim2, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.1:10.9));
            testEllHighDim2 = ellipsoid(diag(11:0.1:20.9));
            
            testRes = gt(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = gt(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(0, testRes);
            
            testRes = gt(testEllipsoid1, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = gt(testEllipsoid2, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = gt(testEllipsoid2, testEllipsoid3);
            mlunit.assert_equals(0, testRes);
            
            testNotEllipsoid = [];
            %'both arguments must be ellipsoids.'
            self.runAndCheckError('gt(testEllipsoidEmpty, testNotEllipsoid)','wrongInput');
            
            %'sizes of ellipsoidal arrays do not match.'
            self.runAndCheckError('gt([testEllipsoidEmpty testEllipsoidEmpty], [testEllipsoidEmpty; testEllipsoidEmpty])','wrongSizes');
            
            testRes = gt([testEllipsoid2 testEllipsoid1], [testEllipsoid1 testEllipsoid2]);
            if (testRes == [1 0])
                testRes = 1;
            else 
                testRes = 0;
            end
            mlunit.assert_equals(1, testRes);
        end  
        
        
        function self = testLt(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid3 = ellipsoid([0; 0], [4 2; 2 4]);
            testEllipsoidEmpty = ellipsoid;
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:6.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:16.5));
            
            testRes = lt(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = lt(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(1, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:10.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:20.5));
            
            testRes = lt(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = lt(testEllHighDim2, testEllHighDim1);
            mlunit.assert_equals(0, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.1:10.9));
            testEllHighDim2 = ellipsoid(diag(11:0.1:20.9));
            
            testRes = lt(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = lt(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(1, testRes);
            
            testRes = lt(testEllipsoid1, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = lt(testEllipsoid2, testEllipsoid1);
            mlunit.assert_equals(0, testRes);
            
            testRes = lt(testEllipsoid2, testEllipsoid3);
            mlunit.assert_equals(1, testRes);
            
            testRes = lt([testEllipsoid2 testEllipsoid1], [testEllipsoid1 testEllipsoid2]);
            if (testRes == [0 1])
                testRes = 1;
            else 
                testRes = 0;
            end
            mlunit.assert_equals(1, testRes);
        end  
        
        
        function self = testLe(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid3 = ellipsoid([0; 0], [4 2; 2 4]);
            testEllipsoidEmpty = ellipsoid;
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:6.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:16.5));
            
            testRes = le(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = le(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(1, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.5:10.5));
            testEllHighDim2 = ellipsoid(diag(11:0.5:20.5));
            
            testRes = le(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = le(testEllHighDim2, testEllHighDim1);
            mlunit.assert_equals(0, testRes);
            
            testEllHighDim1 = ellipsoid(diag(1:0.1:10.9));
            testEllHighDim2 = ellipsoid(diag(11:0.1:20.9));
            
            testRes = le(testEllHighDim1, testEllHighDim1);
            mlunit.assert_equals(1, testRes);
            
            testRes = le(testEllHighDim1, testEllHighDim2);
            mlunit.assert_equals(1, testRes);
            
            testRes = le(testEllipsoid1, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = le(testEllipsoid2, testEllipsoid1);
            mlunit.assert_equals(0, testRes);
            
            testRes = le(testEllipsoid2, testEllipsoid3);
            mlunit.assert_equals(1, testRes);
            
            testRes = le([testEllipsoid2 testEllipsoid1], [testEllipsoid1 testEllipsoid2]);
            if (testRes == [0 1])
                testRes = 1;
            else 
                testRes = 0;
            end
            mlunit.assert_equals(1, testRes);
        end
        
        function self = testMtimes(self)
            testEllipsoid1 = ellipsoid([1; 1], eye(2));
            
            testHighDimShapeMat = diag(1:0.5:6.5);
            testEllHighDim = ellipsoid(testHighDimShapeMat);
            testHighDimMat = diag(11:0.5:16.5);
            
            testEllipsoid2 = mtimes(testHighDimMat, testEllHighDim);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(12, 1), testHighDimMat*testHighDimShapeMat*testHighDimMat');
            mlunit.assert_equals(1, isEq);
            
            testHighDimShapeMat = diag(1:0.5:10.5);
            testEllHighDim = ellipsoid(testHighDimShapeMat);
            testHighDimMat = diag(11:0.5:20.5);
            
            testEllipsoid2 = mtimes(testHighDimMat, testEllHighDim);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(20, 1), testHighDimMat*testHighDimShapeMat*testHighDimMat');
            mlunit.assert_equals(1, isEq);
            
            testHighDimShapeMat = diag(1:0.1:10.9);
            testEllHighDim = ellipsoid(testHighDimShapeMat);
            testHighDimMat = diag(11:0.1:20.9);
            
            testEllipsoid2 = mtimes(testHighDimMat, testEllHighDim);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(100, 1), testHighDimMat*testHighDimShapeMat*testHighDimMat');
            mlunit.assert_equals(1, isEq);
            
            % [~, AMat] = eig(rand(4,4)); fixed case
            AMat = [2.13269424734606 + 0.00000000000000i 0.00000000000000 + 0.00000000000000i 0.00000000000000 + 0.00000000000000i ...
                0.00000000000000 + 0.00000000000000i;0.00000000000000 + 0.00000000000000i -0.511574704257189 + 0.00000000000000i ...
                0.00000000000000 + 0.00000000000000i 0.00000000000000 + 0.00000000000000i;0.00000000000000 + 0.00000000000000i ...
                0.00000000000000 + 0.00000000000000i 0.255693118460086 + 0.343438979993794i 0.00000000000000 + 0.00000000000000i;...
                0.00000000000000 + 0.00000000000000i 0.00000000000000 + 0.00000000000000i 0.00000000000000 + 0.00000000000000i...
                0.255693118460086 - 0.343438979993794i];
            testEllipsoid3 = ellipsoid(diag(1:1:4));
            testEllipsoid2 = mtimes(AMat, testEllipsoid3);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(4, 1), AMat*diag(1:1:4)*AMat');
            mlunit.assert_equals(1, isEq);
            
            AMat = 2*eye(2);
            testEllipsoid2 = mtimes(AMat, testEllipsoid1);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = subTestFunc(testEllCenterVec, testEllMat, [2; 2], 4*eye(2));
            mlunit.assert_equals(1, isEq);
            
            AMat = eye(3);
            %'MTIMES: dimensions do not match.'
            self.runAndCheckError('mtimes(AMat, testEllipsoid1)','wrongSizes');
            
            AMat = cell(2);
            %'MTIMES: first multiplier is expected to be a matrix or a scalar,\n        and second multiplier - an ellipsoid.'
            self.runAndCheckError('mtimes(AMat, testEllipsoid1)','wrongInput');
            
            AMat = 0*eye(2);
            testEllipsoid2 = mtimes(AMat, testEllipsoid1);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = subTestFunc(testEllCenterVec, testEllMat, [0; 0], 0*eye(2));
            mlunit.assert_equals(1, isEq);
            
            AMat = [1 2; 3 4; 5 6];        
            testEllipsoid2 = mtimes(AMat, testEllipsoid1);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = subTestFunc(testEllCenterVec, testEllMat, [3; 7; 11], [5 11 17; 11 25 39; 17 39 61]);
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([0; 0], zeros(2));
            AMat = [1 2; 3 4; 5 6];        
            testEllipsoid2 = mtimes(AMat, testEllipsoid1);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = subTestFunc(testEllCenterVec, testEllMat, [0; 0; 0], [0 0 0; 0 0 0; 0 0 0]);
            mlunit.assert_equals(1, isEq);
        end
        
        
        function self = testMinkdiff_ea(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([1; 0], eye(2));
            testEllipsoid3 = ellipsoid([1; 2], [1 0; 0 1]);
            testNotEllipsoid = [];
            
            testLVec = [0; 1];
            externalApprox = minkdiff_ea(testEllipsoid1, testEllipsoid2, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, [-1; 0], [0 0; 0 0]);
            mlunit.assert_equals(1, isEq);
            
            testLVec = [1; 1];
            %'MINKDIFF_EA: first and second arguments must be single ellipsoids.'
            self.runAndCheckError('minkdiff_ea(testEllipsoid1, testNotEllipsoid, testLVec)','wrongInput');
            
            testLVec = [1; 1];
            %'MINKDIFF_EA: first and second arguments must be single ellipsoids.'
            self.runAndCheckError('minkdiff_ea([2*testEllipsoid1 2*testEllipsoid1], [testEllipsoid3 testEllipsoid3], testLVec)','wrongInput');
            
            testLVec = [1; 1; 1];
            %'MINKDIFF_EA: dimension of the direction vectors must be the same as dimension of ellipsoids.'
            self.runAndCheckError('minkdiff_ea(2*testEllipsoid1, testEllipsoid3, testLVec)','wrongSizes');
            
            testEllipsoid1 = ellipsoid([0; 0], [17 8; 8 17]);
            testEllipsoid2 = ellipsoid([1; 2], [13 12; 12 13]);
            testL = [1; 1];
            externalApprox = minkdiff_ea(testEllipsoid1, testEllipsoid2, testL);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, [-1; -2], [2 -2; -2 2]);
            mlunit.assert_equals(1, isEq);
            
            testEllHighDim1 = ellipsoid(4*eye(12));
            testEllHighDim2 = ellipsoid(eye(12));
            testL = [1 zeros(1, 11)]';
            externalApprox = minkdiff_ea(testEllHighDim1, testEllHighDim2, testL);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(12, 1), eye(12));
            mlunit.assert_equals(1, isEq);
            
            testEllHighDim1 = ellipsoid(4*eye(20));
            testEllHighDim2 = ellipsoid(eye(20));
            testL = [1 zeros(1, 19)]';
            externalApprox = minkdiff_ea(testEllHighDim1, testEllHighDim2, testL);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(20, 1), eye(20));
            mlunit.assert_equals(1, isEq);

            testEllHighDim1 = ellipsoid(4*eye(100));
            testEllHighDim2 = ellipsoid(eye(100));
            testL = [1 zeros(1, 99)]';
            externalApprox = minkdiff_ea(testEllHighDim1, testEllHighDim2, testL);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(100, 1), eye(100));
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid(eye(3));
            testEllipsoid2 = ellipsoid(diag([4, 9, 25]));
            testL = [1; 0; 0];
            externalApprox = minkdiff_ea(testEllipsoid2, testEllipsoid1, testL);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, [0; 0; 0], diag([1, 4, 16]));
            mlunit.assert_equals(1, isEq);
        end 
        
        function self = testMinkdiff_ia(self)          
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 1], eye(2));
            testEllipsoid3 = ellipsoid([0; 0], [4 0; 0 1]);
            testNotEllipsoid = [];
            
            testLVec = [0; 1];
            internalApprox = minkdiff_ia(testEllipsoid1, testEllipsoid2, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = 0;
            isEq = subTestFunc(testEllCenterVec, testEllMat, [0; -1], [0 0; 0 0]);
            mlunit.assert_equals(1, isEq);
            
            testLVec = [0; 1];
            internalApprox = minkdiff_ia(testEllipsoid3, testEllipsoid2, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, [0; -1], [0 0; 0 0]);
            mlunit.assert_equals(1, isEq);
            
            testLVec = [1; 0];
            internalApprox = minkdiff_ia(2*testEllipsoid1, testEllipsoid1, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, [0; 0], [1 0; 0 1]);
            mlunit.assert_equals(1, isEq);
            
            testLVec = [1; 1];
            %'MINKDIFF_IA: first and second arguments must be single ellipsoids.'
            self.runAndCheckError('minkdiff_ia(testEllipsoid1, testNotEllipsoid, testLVec)','wrongInput');
            
            testLVec = [1; 1];
            %'MINKDIFF_IA: first and second arguments must be single ellipsoids.'
            self.runAndCheckError('minkdiff_ia([testEllipsoid1 testEllipsoid1], [testEllipsoid3 testEllipsoid3], testLVec)','wrongInput');
            
            testLVec = [1; 1; 1];
            %'MINKDIFF_IA: dimension of the direction vectors must be the same as dimension of ellipsoids.'
            self.runAndCheckError('minkdiff_ia(testEllipsoid3, testEllipsoid1, testLVec)','wrongSizes');
            
            testEllHighDim1 = ellipsoid(4*eye(12));
            testEllHighDim2 = ellipsoid(eye(12));
            testL = [1 zeros(1, 11)]';
            internalApprox = minkdiff_ia(testEllHighDim1, testEllHighDim2, testL);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(12, 1), eye(12));
            mlunit.assert_equals(1, isEq);
            
            testEllHighDim1 = ellipsoid(4*eye(20));
            testEllHighDim2 = ellipsoid(eye(20));
            testL = [1 zeros(1, 19)]';
            internalApprox = minkdiff_ia(testEllHighDim1, testEllHighDim2, testL);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(20, 1), eye(20));
            mlunit.assert_equals(1, isEq);

            testEllHighDim1 = ellipsoid(4*eye(100));
            testEllHighDim2 = ellipsoid(eye(100));
            testL = [1 zeros(1, 99)]';
            internalApprox = minkdiff_ia(testEllHighDim1, testEllHighDim2, testL);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(100, 1), eye(100));
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid(eye(3));
            testEllipsoid2 = ellipsoid(diag([4, 9, 16]));
            testL = [1; 0; 0];
            internalApprox = minkdiff_ia(testEllipsoid2, testEllipsoid1, testL);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, [0; 0; 0], diag([1, 3.5, 7]));
            mlunit.assert_equals(1, isEq);
        end
        
        function self = testMinkpm_ea(self)
            testEllipsoid1 = ellipsoid(2, 1);
            testEllipsoid2 = ellipsoid(3, 1);
            testEllipsoid3 = ellipsoid(1, 1);
            testLVec = 1;
            externalApprox = minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, 4, 1);
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([2; 0], [1 0; 0 1]);
            testEllipsoid3 = ellipsoid([0; -1], [1 0; 0 1]);
            testLVec = [1; 0];
            externalApprox = minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, [3; 1], [2 0; 0 2]);
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            externalApprox = minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, [3; 1; 0], [2 0 0; 0 2 0; 0 0 2]);
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = [];
            testLVec = [1; 0; 0];
            %'MINKPM_EA: first and second arguments must be ellipsoids.'
            self.runAndCheckError('minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', 'wrongInput');
            
            testEllipsoid1 = [];
            testEllipsoid2 = [];
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 1; 1];
            %'MINKPM_EA: first and second arguments must be ellipsoids.'
            self.runAndCheckError('minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', 'wrongInput');
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            %'MINKPM_EA: second argument must be single ellipsoid.'
            self.runAndCheckError('minkpm_ea([testEllipsoid1 testEllipsoid2], [testEllipsoid3 testEllipsoid3], testLVec)', 'wrongInput');
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0], eye(2));
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            %'MINKPM_EA: all ellipsoids must be of the same dimension.'
            self.runAndCheckError('minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', 'wrongSizes');
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([2; 0], eye(2));
            testLVec = [1; 0; 0];
            %'MINKPM_EA: all ellipsoids must be of the same dimension.'
            self.runAndCheckError('minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', 'wrongSizes');
             
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([2; 0; 0], eye(3));
            testLVec = [1; 0];
            %'MINKPM_EA: dimension of the direction vectors must be the same as dimension of ellipsoids.'
            self.runAndCheckError('minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', 'wrongSizes');
            
            testEllipsoid1 = ellipsoid(eye(12));
            testEllipsoid2 = ellipsoid(eye(12));
            testEllipsoid3 = ellipsoid(eye(12));
            testLVec = [1 zeros(1, 11)]';
            externalApprox = minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(12, 1), eye(12));
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid(eye(20));
            testEllipsoid2 = ellipsoid(eye(20));
            testEllipsoid3 = ellipsoid(eye(20));
            testLVec = [1 zeros(1, 19)]';
            externalApprox = minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(20, 1), eye(20));
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid(eye(100));
            testEllipsoid2 = ellipsoid(eye(100));
            testEllipsoid3 = ellipsoid(eye(100));
            testLVec = [1 zeros(1, 99)]';
            externalApprox = minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(100, 1), eye(100));
            mlunit.assert_equals(1, isEq);
        end
        
        function self = testMinkpm_ia(self)            
            testEllipsoid1 = ellipsoid(2, 1);
            testEllipsoid2 = ellipsoid(3, 1);
            testEllipsoid3 = ellipsoid(1, 1);
            testLVec = 1;
            internalApprox = minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, 4, 1);
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([2; 0], [1 0; 0 1]);
            testEllipsoid3 = ellipsoid([0; -1], [1 0; 0 1]);
            testLVec = [1; 0];
            internalApprox = minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, [3; 1], [2 0; 0 2]);
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            internalApprox = minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, [3; 1; 0], [2 0 0; 0 2 0; 0 0 2]);
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = [];
            testLVec = [1; 0; 0];
            %'MINKPM_IA: first and second arguments must be ellipsoids.'
            self.runAndCheckError('minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', 'wrongInput');
            
            testEllipsoid1 = [];
            testEllipsoid2 = [];
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            %'MINKPM_IA: first and second arguments must be ellipsoids.'
            self.runAndCheckError('minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', 'wrongInput');
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            %'MINKPM_IA: second argument must be single ellipsoid.'
            self.runAndCheckError('minkpm_ia([testEllipsoid1 testEllipsoid2], [testEllipsoid3 testEllipsoid3], testLVec)', 'wrongInput');
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0], eye(2));
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            %'MINKPM_IA: all ellipsoids must be of the same dimension.'
            self.runAndCheckError('minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', 'wrongSizes');
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([2; 0], eye(2));
            testLVec = [1; 0; 0];
            %'MINKPM_IA: all ellipsoids must be of the same dimension.'
            self.runAndCheckError('minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', 'wrongSizes');
             
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([2; 0; 0], eye(3));
            testLVec = [1; 0];
            %'MINKPM_IA: dimension of the direction vectors must be the same as dimension of ellipsoids.'
            self.runAndCheckError('minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', 'wrongSizes');
            
            testEllipsoid1 = ellipsoid(eye(12));
            testEllipsoid2 = ellipsoid(eye(12));
            testEllipsoid3 = ellipsoid(eye(12));
            testLVec = [1 zeros(1, 11)]';
            externalApprox = minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(12, 1), eye(12));
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid(eye(20));
            testEllipsoid2 = ellipsoid(eye(20));
            testEllipsoid3 = ellipsoid(eye(20));
            testLVec = [1 zeros(1, 19)]';
            externalApprox = minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(20, 1), eye(20));
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid(eye(100));
            testEllipsoid2 = ellipsoid(eye(100));
            testEllipsoid3 = ellipsoid(eye(100));
            testLVec = [1 zeros(1, 99)]';
            externalApprox = minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = subTestFunc(testEllCenterVec, testEllMat, zeros(100, 1), eye(100));
            mlunit.assert_equals(1, isEq);
        end
        
    end      
end

function isEq = subTestFunc(testEllCenterVec, testEllMat, testAnalitVec, testAnalitMat)
    global  ellOptions;
    isEq = 0;
    if ((max(max(abs(testEllCenterVec - testAnalitVec)))  <= ellOptions.abs_tol) && ...
            (max(max(abs(testEllMat - testAnalitMat)))  <= ellOptions.abs_tol))
    isEq = 1;
    end
end

