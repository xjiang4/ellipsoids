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
            isError = isempty(eval('eq(testEllipsoidEmpty, testNotEllipsoid)', '[]'));
            mlunitext.assert(isError);
            
            %'==: sizes of ellipsoidal arrays do not match.'
            isError = isempty(eval('eq([testEllipsoidEmpty testEllipsoidEmpty], [testEllipsoidEmpty; testEllipsoidEmpty])', '[]'));
            mlunitext.assert(isError);
            
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
            
            testNotEllipsoid = [];
            %'==: both arguments must be ellipsoids.'
            isError = isempty(eval('ne(testEllipsoidEmpty, testNotEllipsoid)', '[]'));
            mlunitext.assert(isError);
            
            %'==: sizes of ellipsoidal arrays do not match.'
            isError = isempty(eval('ne([testEllipsoidEmpty testEllipsoidEmpty], [testEllipsoidEmpty; testEllipsoidEmpty])', '[]'));
            mlunitext.assert(isError);
            
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
            
            testRes = ge(testEllipsoid1, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = ge(testEllipsoid2, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = ge(testEllipsoid2, testEllipsoid3);
            mlunit.assert_equals(0, testRes);
            
            testNotEllipsoid = [];
            %'both arguments must be ellipsoids.'
            isError = isempty(eval('ge(testEllipsoidEmpty, testNotEllipsoid)', '[]'));
            mlunitext.assert(isError);
            
            %'sizes of ellipsoidal arrays do not match.'
            isError = isempty(eval('ge([testEllipsoidEmpty testEllipsoidEmpty], [testEllipsoidEmpty; testEllipsoidEmpty])', '[]'));
            mlunitext.assert(isError);
            
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
            
            testRes = gt(testEllipsoid1, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = gt(testEllipsoid2, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = gt(testEllipsoid2, testEllipsoid3);
            mlunit.assert_equals(0, testRes);
            
            testNotEllipsoid = [];
            %'both arguments must be ellipsoids.'
            isError = isempty(eval('gt(testEllipsoidEmpty, testNotEllipsoid)', '[]'));
            mlunitext.assert(isError);
            
            %'sizes of ellipsoidal arrays do not match.'
            isError = isempty(eval('gt([testEllipsoidEmpty testEllipsoidEmpty], [testEllipsoidEmpty; testEllipsoidEmpty])', '[]'));
            mlunitext.assert(isError);
            
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
            
            testRes = lt(testEllipsoid1, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = lt(testEllipsoid2, testEllipsoid1);
            mlunit.assert_equals(0, testRes);
            
            testRes = lt(testEllipsoid2, testEllipsoid3);
            mlunit.assert_equals(1, testRes);
            
            testNotEllipsoid = [];
            %'both arguments must be ellipsoids.'
            isError = isempty(eval('lt(testEllipsoidEmpty, testNotEllipsoid)', '[]'));
            mlunitext.assert(isError);
            
            %'sizes of ellipsoidal arrays do not match.'
            isError = isempty(eval('lt([testEllipsoidEmpty testEllipsoidEmpty], [testEllipsoidEmpty; testEllipsoidEmpty])', '[]'));
            mlunitext.assert(isError);
            
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
            
            testRes = le(testEllipsoid1, testEllipsoid1);
            mlunit.assert_equals(1, testRes);
            
            testRes = le(testEllipsoid2, testEllipsoid1);
            mlunit.assert_equals(0, testRes);
            
            testRes = le(testEllipsoid2, testEllipsoid3);
            mlunit.assert_equals(1, testRes);
            
            testNotEllipsoid = [];
            %'both arguments must be ellipsoids.'
            isError = isempty(eval('le(testEllipsoidEmpty, testNotEllipsoid)', '[]'));
            mlunitext.assert(isError);
            
            %'sizes of ellipsoidal arrays do not match.'
            isError = isempty(eval('le([testEllipsoidEmpty testEllipsoidEmpty], [testEllipsoidEmpty; testEllipsoidEmpty])', '[]'));
            mlunitext.assert(isError);
            
            testRes = le([testEllipsoid2 testEllipsoid1], [testEllipsoid1 testEllipsoid2]);
            if (testRes == [0 1])
                testRes = 1;
            else 
                testRes = 0;
            end
            mlunit.assert_equals(1, testRes);
        end
        
        
        function self = testMtimes(self)
            global  ellOptions;
            testEllipsoid1 = ellipsoid([1; 1], eye(2));
            
            A = 2*eye(2);
            testEllipsoid2 = mtimes(A, testEllipsoid1);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = 0;
            if ((max(max(abs(testEllCenterVec - [2; 2])))  <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllMat - 4*eye(2))))  <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            A = eye(3);
            %'MTIMES: dimensions do not match.'
            isError = isempty(eval('mtimes(A, testEllipsoid1)', '[]'));
            mlunitext.assert(isError);
            
            A = cell(2);
            %'MTIMES: first multiplier is expected to be a matrix or a scalar,\n        and second multiplier - an ellipsoid.'
            isError = isempty(eval('mtimes(A, testEllipsoid1)', '[]'));
            mlunitext.assert(isError);
            
            A = 0*eye(2);
            testEllipsoid2 = mtimes(A, testEllipsoid1);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = 0;
            if ((max(max(abs(testEllCenterVec - [0; 0]))) <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllMat - 0*eye(2))))  <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            A = [1 2; 3 4; 5 6];        
            testEllipsoid2 = mtimes(A, testEllipsoid1);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = 0;
            if ((max(max(abs(testEllCenterVec - [3; 7; 11]))) <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllMat - [5 11 17; 11 25 39; 17 39 61]))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);     
            
            testEllipsoid1 = ellipsoid([0; 0], zeros(2));
            A = [1 2; 3 4; 5 6];        
            testEllipsoid2 = mtimes(A, testEllipsoid1);
            [testEllCenterVec testEllMat] = double(testEllipsoid2);
            isEq = 0;
            if ((max(max(abs(testEllCenterVec - [0; 0; 0]))) <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllMat - [0 0 0; 0 0 0; 0 0 0]))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);  
        end
        
        
        function self = testMinkdiff_ea(self)
            global  ellOptions;
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([1; 0], eye(2));
            testEllipsoid3 = ellipsoid([1; 2], [1 0; 0 1]);
            testNotEllipsoid = [];
            
            testLVec = [0; 1];
            externalApprox = minkdiff_ea(testEllipsoid1, testEllipsoid2, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = 0;
            if ((max(max(abs(testEllMat - [0 0; 0 0]))) <= ellOptions.abs_tol) && ... 
                    (max(max(abs(testEllCenterVec - [-1; 0]))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            testLVec = [1; 1];
            %'MINKDIFF_EA: first and second arguments must be single ellipsoids.'
            isError = isempty(eval('minkdiff_ea(testEllipsoid1, testNotEllipsoid, testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testLVec = [1; 1];
            %'MINKDIFF_EA: first and second arguments must be single ellipsoids.'
            isError = isempty(eval('minkdiff_ea([2*testEllipsoid1 2*testEllipsoid1], [testEllipsoid3 testEllipsoid3], testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testLVec = [1; 1; 1];
            %'MINKDIFF_EA: dimension of the direction vectors must be the same as dimension of ellipsoids.'
            isError = isempty(eval('minkdiff_ea(2*testEllipsoid1, testEllipsoid3, testLVec)', '[]'));
            mlunitext.assert(isError);
        end 
        
        function self = testMinkdiff_ia(self)
            global  ellOptions;            
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 1], eye(2));
            testEllipsoid3 = ellipsoid([0; 0], [4 0; 0 1]);
            testNotEllipsoid = [];
            
            testLVec = [0; 1];
            internalApprox = minkdiff_ia(testEllipsoid1, testEllipsoid2, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = 0;
            if ((max(max(abs(testEllMat - [0 0; 0 0]))) <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllCenterVec - [0; -1]))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            testLVec = [0; 1];
            internalApprox = minkdiff_ia(testEllipsoid3, testEllipsoid2, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = 0;
            if ((max(max(abs(testEllMat - [0 0; 0 0]))) <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllCenterVec - [0; -1]))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            testLVec = [1; 1];
            %'MINKDIFF_IA: first and second arguments must be single ellipsoids.'
            isError = isempty(eval('minkdiff_ia(testEllipsoid1, testNotEllipsoid, testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testLVec = [1; 1];
            %'MINKDIFF_IA: first and second arguments must be single ellipsoids.'
            isError = isempty(eval('minkdiff_ia([testEllipsoid1 testEllipsoid1], [testEllipsoid3 testEllipsoid3], testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testLVec = [1; 1; 1];
            %'MINKDIFF_IA: dimension of the direction vectors must be the same as dimension of ellipsoids.'
            isError = isempty(eval('minkdiff_ia(testEllipsoid3, testEllipsoid1, testLVec)', '[]'));
            mlunitext.assert(isError);
        end
        
        function self = testMinkpm_ea(self)
            global  ellOptions;
            
            testEllipsoid1 = ellipsoid(2, 1);
            testEllipsoid2 = ellipsoid(3, 1);
            testEllipsoid3 = ellipsoid(1, 1);
            testLVec = 1;
            externalApprox = minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = 0;
            if ((max(max(abs(testEllMat - 1))) <= ellOptions.abs_tol) && (max(max(abs(testEllCenterVec - 4))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([2; 0], [1 0; 0 1]);
            testEllipsoid3 = ellipsoid([0; -1], [1 0; 0 1]);
            testLVec = [1; 0];
            externalApprox = minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = 0;
            if ((max(max(abs(testEllMat - [2 0; 0 2]))) <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllCenterVec - [3; 1]))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            externalApprox = minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(externalApprox(1));
            isEq = 0;
            if ((max(max(abs(testEllMat - [2 0 0; 0 2 0; 0 0 2]))) <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllCenterVec - [3; 1; 0]))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = [];
            testLVec = [1; 0; 0];
            %'MINKPM_EA: first and second arguments must be ellipsoids.'
            isError = isempty(eval('minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testEllipsoid1 = [];
            testEllipsoid2 = [];
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 1; 1];
            %'MINKPM_EA: first and second arguments must be ellipsoids.'
            isError = isempty(eval('minkpm_ea([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);;
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            %'MINKPM_EA: second argument must be single ellipsoid.'
            isError = isempty(eval('minkpm_ea([testEllipsoid1 testEllipsoid2], [testEllipsoid3 testEllipsoid3], testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);;
            testEllipsoid2 = ellipsoid([2; 0], eye(2));
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            %'MINKPM_EA: all ellipsoids must be of the same dimension.'
            isError = isempty(eval('minkpm_ea([testEllipsoid1 testEllipsoid2], [testEllipsoid3 testEllipsoid3], testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);;
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([2; 0], eye(2));
            testLVec = [1; 0; 0];
            %'MINKPM_EA: second argument must be single ellipsoid.'
            isError = isempty(eval('minkpm_ea([testEllipsoid1 testEllipsoid2], [testEllipsoid3 testEllipsoid3], testLVec)', '[]'));
            mlunitext.assert(isError);
             
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);;
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([2; 0; 0], eye(3));
            testLVec = [1; 0];
            %'MINKPM_EA: dimension of the direction vectors must be the same as dimension of ellipsoids.'
            isError = isempty(eval('minkpm_ea([testEllipsoid1 testEllipsoid2], [testEllipsoid3 testEllipsoid3], testLVec)', '[]'));
            mlunitext.assert(isError);
        end
        
        function self = testMinkpm_ia(self)
            global  ellOptions;
            
            testEllipsoid1 = ellipsoid(2, 1);
            testEllipsoid2 = ellipsoid(3, 1);
            testEllipsoid3 = ellipsoid(1, 1);
            testLVec = 1;
            internalApprox = minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = 0;
            if ((max(max(abs(testEllMat - 1))) <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllCenterVec - 4))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([2; 0], [1 0; 0 1]);
            testEllipsoid3 = ellipsoid([0; -1], [1 0; 0 1]);
            testLVec = [1; 0];
            internalApprox = minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = 0;
            if ((max(max(abs(testEllMat - [2 0; 0 2]))) <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllCenterVec - [3; 1]))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            internalApprox = minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec);
            [testEllCenterVec testEllMat] = double(internalApprox(1));
            isEq = 0;
            if ((max(max(abs(testEllMat - [2 0 0; 0 2 0; 0 0 2]))) <= ellOptions.abs_tol) && ...
                    (max(max(abs(testEllCenterVec - [3; 1; 0]))) <= ellOptions.abs_tol))
                isEq = 1;
            end
            mlunit.assert_equals(1, isEq);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = [];
            testLVec = [1; 0; 0];
            %'MINKPM_IA: first and second arguments must be ellipsoids.'
            isError = isempty(eval('minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testEllipsoid1 = [];
            testEllipsoid2 = [];
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            %'MINKPM_IA: first and second arguments must be ellipsoids.'
            isError = isempty(eval('minkpm_ia([testEllipsoid1 testEllipsoid2], testEllipsoid3, testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);;
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            %'MINKPM_IA: second argument must be single ellipsoid.'
            isError = isempty(eval('minkpm_ia([testEllipsoid1 testEllipsoid2], [testEllipsoid3 testEllipsoid3], testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);;
            testEllipsoid2 = ellipsoid([2; 0], eye(2));
            testEllipsoid3 = ellipsoid([0; -1; 1], [1 0 0; 0 1 0; 0 0 1]);
            testLVec = [1; 0; 0];
            %'MINKPM_IA: all ellipsoids must be of the same dimension.'
            isError = isempty(eval('minkpm_ia([testEllipsoid1 testEllipsoid2], [testEllipsoid3 testEllipsoid3], testLVec)', '[]'));
            mlunitext.assert(isError);
            
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);;
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([2; 0], eye(2));
            testLVec = [1; 0; 0];
            %'MINKPM_IA: second argument must be single ellipsoid.'
            isError = isempty(eval('minkpm_ia([testEllipsoid1 testEllipsoid2], [testEllipsoid3 testEllipsoid3], testLVec)', '[]'));
            mlunitext.assert(isError);
             
            testEllipsoid1 = ellipsoid([1; 0; -1], [2 0 0; 0 2 0; 0 0 2]);;
            testEllipsoid2 = ellipsoid([2; 0; 2], [1 0 0; 0 1 0; 0 0 1]);
            testEllipsoid3 = ellipsoid([2; 0; 0], eye(3));
            testLVec = [1; 0];
            %'MINKPM_IA: dimension of the direction vectors must be the same as dimension of ellipsoids.'
            isError = isempty(eval('minkpm_ia([testEllipsoid1 testEllipsoid2], [testEllipsoid3 testEllipsoid3], testLVec)', '[]'));
            mlunitext.assert(isError);          
        end
        
    end      
end

