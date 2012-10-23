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
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = eq(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
            
            testEllipsoid1 = ellipsoid([1; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = eq(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(0, testRes);    
            
                        
            testEllipsoid1 = ellipsoid([1; 0], [2 0; 0 1]);
            testEllipsoid2 = ellipsoid([1; 0], [1 0; 0 1]);
            testRes = eq(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(0, testRes);
            
                        
            testEllipsoid1 = ellipsoid([0; 0], [0 0; 0 0]);
            testEllipsoid2 = ellipsoid([0; 0; 0], [0 0 0 ;0 0 0; 0 0 0]);
            testRes = eq(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(0, testRes);
            
            testEllipsoid1 = ellipsoid([0; 0], [0 0; 0 0]);
            testEllipsoid2 = ellipsoid;
            testRes = eq(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(0, testRes);
           
            testEllipsoid1 = ellipsoid;
            testEllipsoid2 = ellipsoid;
            testRes = eq(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
        end
        
        function self = testNe(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = ne(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(0, testRes);
            
            testEllipsoid1 = ellipsoid([1; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = ne(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);    
            
                        
            testEllipsoid1 = ellipsoid([1; 0], [2 0; 0 1]);
            testEllipsoid2 = ellipsoid([1; 0], [1 0; 0 1]);
            testRes = ne(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
            
                        
            testEllipsoid1 = ellipsoid([0; 0], [0 0; 0 0]);
            testEllipsoid2 = ellipsoid([0; 0; 0], [0 0 0 ;0 0 0; 0 0 0]);
            testRes = ne(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
            
            testEllipsoid1 = ellipsoid([0; 0], [0 0; 0 0]);
            testEllipsoid2 = ellipsoid;
            testRes = ne(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
            
            testEllipsoid1 = ellipsoid;
            testEllipsoid2 = ellipsoid;
            testRes = ne(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(0, testRes);
        end
        
        function self = testGe(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = ge(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
            
            testEllipsoid1 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = ge(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
            
            %testEllipsoid1 = ellipsoid([1; 0], [1 0; 0 1]);
            %testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            %testRes = ge(testEllipsoid1, testEllipsoid2);
            %mlunit.assert_equals(0, testRes);
            %self.runAndCheckError('ge(testEllipsoid1, testEllipsoid2)','DifferentCenters');
            
            testEllipsoid1 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([0; 0], [4 2; 2 4]);
            testRes = ge(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(0, testRes);
        end    
        
        function self = testGt(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = gt(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
            
            testEllipsoid1 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = gt(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
            
            %testEllipsoid1 = ellipsoid([1; 0], [1 0; 0 1]);
            %testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            %testRes = gt(testEllipsoid1, testEllipsoid2);
            %mlunit.assert_equals(0, testRes);
            %self.runAndCheckError('ge(testEllipsoid1, testEllipsoid2)','DifferentCenters');
            
            testEllipsoid1 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([0; 0], [4 2; 2 4]);
            testRes = gt(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(0, testRes);
        end  
        
        function self = testLt(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = lt(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
            
            testEllipsoid1 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = lt(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(0, testRes);
            
            %testEllipsoid1 = ellipsoid([1; 0], [1 0; 0 1]);
            %testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            %testRes = lt(testEllipsoid1, testEllipsoid2);
            %mlunit.assert_equals(0, testRes);
            %self.runAndCheckError('ge(testEllipsoid1, testEllipsoid2)','DifferentCenters');
            
            testEllipsoid1 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([0; 0], [4 2; 2 4]);
            testRes = lt(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
        end  
        
        function self = testLe(self)
            testEllipsoid1 = ellipsoid([0; 0], [1 0; 0 1]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = lt(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
            
            testEllipsoid1 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            testRes = le(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(0, testRes);
            
            %testEllipsoid1 = ellipsoid([1; 0], [1 0; 0 1]);
            %testEllipsoid2 = ellipsoid([0; 0], [1 0; 0 1]);
            %testRes = lt(testEllipsoid1, testEllipsoid2);
            %mlunit.assert_equals(0, testRes);
            %self.runAndCheckError('ge(testEllipsoid1, testEllipsoid2)','DifferentCenters');
            
            testEllipsoid1 = ellipsoid([0; 0], [2 0; 0 2]);
            testEllipsoid2 = ellipsoid([0; 0], [4 2; 2 4]);
            testRes = le(testEllipsoid1, testEllipsoid2);
            mlunit.assert_equals(1, testRes);
        end
        
        function self = testMtimes(self)
            testEllipsoid1 = ellipsoid([1; 1], eye(2));
            A = 2*eye(2);
            testEllipsoid2 = mtimes(A, testEllipsoid1);
            [testEllCenter testEllMatrix] = double(testEllipsoid2);
            isequal = 0;
            if (min(min(testEllCenter == [2; 2])) && min(min(testEllMatrix == 4*eye(2))))
                isequal = 1;
            end
            mlunit.assert_equals(1, isequal);
            
            testEllipsoid1 = ellipsoid([1; 1], eye(2));
            A = eye(3);
            iserror = isempty(eval('mtimes(A, testEllipsoid1)', '[]'));
            mlunit.assert_equals(1, iserror);
            
            testEllipsoid1 = ellipsoid([1; 1], eye(2));
            A = 0*eye(2);
            testEllipsoid2 = mtimes(A, testEllipsoid1);
            [testEllCenter testEllMatrix] = double(testEllipsoid2);
            isequal = 0;
            if (min(min(testEllCenter == [0; 0])) && min(min(testEllMatrix == 0*eye(2))))
                isequal = 1;
            end
            mlunit.assert_equals(1, isequal);
            
            testEllipsoid1 = ellipsoid([1; 1], eye(2));
            A = [1 2; 3 4; 5 6];
            iserror = isempty(eval('mtimes(A, testEllipsoid1)', '[]'));
            testEllipsoid2 = mtimes(A, testEllipsoid1);
            [testEllCenter testEllMatrix] = double(testEllipsoid2);
            isequal = 0;
            if (min(min(testEllCenter == [3; 7; 11])) && min(min(testEllMatrix == [5 11 17; 11 25 39; 17 39 61])))
                isequal = 1;
            end
            mlunit.assert_equals(1, isequal);
            
        end 
        
    end      
end

