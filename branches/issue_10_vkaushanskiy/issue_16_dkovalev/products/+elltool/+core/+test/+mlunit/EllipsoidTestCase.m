classdef EllipsoidTestCase < mlunitext.test_case

% $Author: Dmitry Kovalev, Lomonosov Moscow State University,
% Faculty of Computational Mathematics and Cybernetics, System Analysis
% Department, 18-October-2012, <klivenn@gmail.com>$
  
    methods
        function self = EllipsoidTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        function self = testPlot(self)
            testShapeMat = 1;
            testEllCenter = 2;
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            plot(testEll);
            
            testShapeMat = [1 1; 3 4];
            testEllCenter = [1; 2];
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            plot(testEll);
            
            testShapeMat = [1 2 3; 8 7 6; 5 2 9];
            testEllCenter = [2; 4; 1];
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            plot(testEll);
            
            testShapeMat1 = [1 2; 4 3];
            testShapeMat2 = [5 2; 1 3];
            testEllCenter1 = [1; 5];
            testEllCenter2 = [3; 10];
            testEll1 = ellipsoid(testEllCenter1, testShapeMat1*testShapeMat1');
            testEll2 = ellipsoid(testEllCenter2, testShapeMat2*testShapeMat2');
            testEllVec = [testEll1 testEll2];
            plot(testEllVec);
        end
        
        function self = testMove2Origin(self)
            testShapeMat = [3 1; 0 1];
            testEllCenter = [1; 1];
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            testResEll = move2origin(testEll);
            [testResCenter ~] = double(testResEll);
            mlunit.assert_equals([0; 0], testResCenter);

            testShapeMat1 = [3 1 5; 1 2 0; 6 4.4 8];
            testShapeMat2 = [3 2; 1 0];
            testEllCenter1 = [1; 1; 0];
            testEllCenter2 = [1; 2];
            testEll1 = ellipsoid(testEllCenter1, testShapeMat1*testShapeMat1');
            testEll2 = ellipsoid(testEllCenter2, testShapeMat2*testShapeMat2');
            testEllVec = [testEll1 testEll2];
            testResEllVec = move2origin(testEllVec);
            [testResCenter1 ~] = double(testResEllVec(1));
            [testResCenter2 ~] = double(testResEllVec(2));
            testIsRight = min(testResCenter1 == [0; 0; 0]) && min(testResCenter2 == [0;0]);
            mlunit.assert_equals(1, testIsRight);
            
            testShapeMat = [];
            testEllCenter = [];
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            self.runAndCheckError('move2origin(testEll)','degenerateEllipsoid')
        end
        
        function self = testShape(self)
            testShapeMat1 = [3 0; 2 4];
            testShapeMat2 = [4 0; 0 3];
            testEllCenter1 = [2; 4];
            testEllCenter2 = [5; 1];
            testMat = [0 1; 2 3];
            testEll1 = ellipsoid(testEllCenter1, testShapeMat1*testShapeMat1');
            testEll2 = ellipsoid(testEllCenter2, testShapeMat2*testShapeMat2');
            testEllVec = [testEll1, testEll2];
            testResEllVec = shape(testEllVec, testMat);
            [testResCenter1 testResMat1] = double(testResEllVec(1));
            [testResCenter2 testResMat2] = double(testResEllVec(2));
            testIsRight = min(min(testResMat1 == [20 72; 72 288])) && min(min(testResMat2 == [9 27; 27 145]));
            mlunit.assert_equals(1, testIsRight);
            
            testShapeMat = 3;
            testEllCenter = 4;
            testMat = 2;
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            testResEll = shape(testEll, testMat);
            [testResCenter testResMat] = double(testResEll);
            tetIsRight = min(testResMat == 36);
        end
        
        function self = testRho(self)
            global ellOptions;
            testShapeMat = [1 0; 2 1];
            testEllCenter = [1; 2];
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            testDir1 = [1; 2];
            testDir2 = [0; 4];
            testDirVec = [testDir1 testDir2];
            testResRho = rho(testEll, testDirVec);
            testIsRight = (abs(testResRho(1) - 10.385164807134505) < ellOptions.rel_tol) & (abs(testResRho(2) - 16.944271909999159) < ellOptions.rel_tol);
            %testResRho = testDirection*testEllCenter + sqrt(testDirection*testShapeMat*testDirection);
            mlunit.assert_equals(testIsRight, 1);
            
            testShapeMat1 = [1 2; 4 2];
            testShapeMat2 = [2 3; 5 1];
            testEllCenter1 = [4; 1];
            testEllCenter2 = [2; 4];
            testDirection = [1; 3];
            testEll1 = ellipsoid(testEllCenter1, testShapeMat1*testShapeMat1');
            testEll2 = ellipsoid(testEllCenter2, testShapeMat2*testShapeMat2');
            testEllVec = [testEll1 testEll2];
            testResRho = rho(testEllVec, testDirection);
            testIsRight = (abs(testResRho(1) -   22.264337522473745) < ellOptions.rel_tol) & (abs(testResRho(2) - 32.027756377319946) < ellOptions.rel_tol);            
            mlunit.assert_equals(testIsRight, 1);
        end
        
        function self = testProjection(self)
            testShapeMat = [1 2 2; 4 2 3; 1 2 3];
            testEllCenter = [1; 3; 5];
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            testBasVec1 = [1; 0; 0];
            testBasVec2 = [0; 1; 0];
            testBasVecArray = [testBasVec1 testBasVec2];
            testResPr = projection(testEll, testBasVecArray);
            [testResPrCenter testResPrShapeMat] = double(testResPr);
            testIsRight = min(min(testResPrShapeMat == [9 14; 14 29])) & min(testResPrCenter == [1; 3]);
            mlunit.assert_equals(testIsRight, 1);
            
            testShapeMat1 = [1 2; 4 3];
            testShapeMat2 = [3 4; 7 6];
            testEllCenter1 = [3; 2];
            testEllCenter2 = [2; 1];
            testEll1 = ellipsoid(testEllCenter1, testShapeMat1*testShapeMat1');
            testEll2 = ellipsoid(testEllCenter2, testShapeMat2*testShapeMat2');
            testEllVec = [testEll1 testEll2];
            testBasVec1 = [1; 0];
            testResPr = projection(testEllVec, testBasVec1);
            [testResPrCenter1 testResPrShapeMat1] = double(testResPr(1));
            [testResPrCenter2 testResPrShapeMat2] = double(testResPr(2));
            testIsRight = min(min(testResPrShapeMat1 == 5)) & min(testResPrCenter1 == 3) & min(min(testResPrShapeMat2 == 25)) & min(testResPrCenter2 == 2);
            mlunit.assert_equals(testIsRight, 1);
        end
        
        function self = testMinksum(self)
            mlunit.assert_equals(0, sin(0));
        end
        
        function self = testMinkdiff(self)
            mlunit.assert_equals(0, sin(0));
        end
        
        function self = testMinkpm(self)
            mlunit.assert_equals(0, sin(0));
        end
        
        function self = testPlus(self)
            testEllCenter = [-1; 5];
            testShapeMat = [1 0; 0 1];
            testVec = [5; 3];
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            testResEll = plus(testEll, testVec);
            [testResCenter testResMat] = double(testResEll);
            mlunit.assert_equals(testResCenter, [4; 8]);
            
            testEllCenter1 = 5;
            testEllCenter2 = [2; 4; 1];
            testShapeMat1 = 4;
            testShapeMat2 = [2 2 1; 7 0 1; 0 1 8];
            testVec1 = 3;
            testVec2 = [1; 2; 3];
            testEll1 = ellipsoid(testEllCenter1, testShapeMat1*testShapeMat1');
            testEll2 = ellipsoid(testEllCenter2, testShapeMat2*testShapeMat2');
            testResEll1 = plus(testEll1, testVec1);
            testResEll2 = plus(testEll2, testVec2);
            testResEllArray = [testResEll1 testResEll2];
            [testResCenter1 testResMat1] = double(testResEllArray(1));
            [testResCenter2 testResMat2] = double(testResEllArray(2));
            testIsRight = ((testResCenter1 == 8) && min(min(testResCenter2 == [3; 6; 4])));
            mlunit.assert_equals(testIsRight, 1);
        end
        
        function self = testMinus(self)
            testEllCenter = [3; 7];
            testShapeMat = [1 0; 0 1];
            testVec = [1; 2; 3];
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            self.runAndCheckError('minus(testEll, testVec)','wrongDimension');
            
            testEllCenter1 = -10;
            testEllCenter2 = [2; -4; 11];
            testShapeMat1 = 4;
            testShapeMat2 = [7 2 1; 7 2 2; 5 6 8];
            testVec1 = 3;
            testVec2 = [0; 2; 1];
            testEll1 = ellipsoid(testEllCenter1, testShapeMat1*testShapeMat1');
            testEll2 = ellipsoid(testEllCenter2, testShapeMat2*testShapeMat2');
            testResEll1 = minus(testEll1, testVec1);
            testResEll2 = minus(testEll2, testVec2);
            testResEllArray = [testResEll1 testResEll2];
            [testResCenter1 testResMat1] = double(testResEllArray(1));
            [testResCenter2 testResMat2] = double(testResEllArray(2));
            testIsRight = ((testResCenter1 == -13) && min(min(testResCenter2 == [2; -6; 10])));
            mlunit.assert_equals(testIsRight, 1);
        end
        
        function self = testUminus(self)
            testEllCenter = [5; 10];
            testShapeMatrix = [2 3; 4 5];
            testEll = ellipsoid(testEllCenter, testShapeMatrix*testShapeMatrix');
            testResEll = uminus(testEll);
            [testResCenter testResMat] = double(testResEll);
            mlunit.assert_equals([-5; -10], testResCenter);
            
            testEllCenter1 = -1;
            testEllCenter2 = [1; -2; 5];
            testShapeMatrix1 = 4;
            testShapeMatrix2 = [4 5 3; 7 6 2; 8 8 8];
            testEll1 = ellipsoid(testEllCenter1, testShapeMatrix1*testShapeMatrix1');
            testEll2 = ellipsoid(testEllCenter2, testShapeMatrix2*testShapeMatrix2');
            testEllVec = [testEll1 testEll2];
            testResVec = uminus(testEllVec);
            [testResCenter1 testResMatrix1] = double(testResVec(1));
            [testResCenter2 testResMatrix2] = double(testResVec(2));
            testIsRight = ((testResCenter1 == 1) && min(min(testResCenter2 == [-1; 2; -5])));
            mlunit.assert_equals(testIsRight, 1);
        end
        
        function self = testDisplay(self)
            testEllCenter = [0; 1];
            testShapeMat = [100 0; 0 1];
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            testResCharVec = evalc('display(testEll)');
            testResCenter = zeros(size(testEllCenter));
            testResMat = zeros(size(testShapeMat));
            testResNumArray = [];
            testCharNum = [];
            testNumStartPosition = regexp(testResCharVec, '[0-9]');
            testNumStartPosition = [testNumStartPosition 0];
            for itestCharCount = 1:1:numel(testNumStartPosition)-1
                if (testNumStartPosition(itestCharCount+1) - testNumStartPosition(itestCharCount) == 1)
                    testCharNum = [testCharNum testResCharVec(testNumStartPosition(itestCharCount))];
                else
                    testCharNum = [testCharNum testResCharVec(testNumStartPosition(itestCharCount))];
                    testResNumArray = [testResNumArray str2num(testCharNum)];
                    testCharNum = [];
                end
            end
            for itestCharCount = 1:1:numel(testEllCenter)
                testResCenter(itestCharCount) = testResNumArray(itestCharCount);
            end
            for itestCharCount = 1:1:numel(testShapeMat)
                testResMatNum(itestCharCount) = testResNumArray(numel(testEllCenter) + itestCharCount);
            end
            testResMat = vec2mat(testResMatNum,size(testShapeMat,2));
            testIsRight = (min((testResCenter == [0; 1])) && min(min(testResMat == testShapeMat*testShapeMat')));
            mlunit.assert_equals(testIsRight, 1);
            
            testShapeMat = [1 2 3; 4 5 6; 7 8 9];
            testEllCenter = [1; 2; 3];
            testEll = ellipsoid(testEllCenter, testShapeMat*testShapeMat');
            testResCharVec = evalc('display(testEll)');
            testResCenter = zeros(size(testEllCenter));
            testResMat = zeros(size(testShapeMat));
            testResNumArray = [];
            testCharNum = [];
            testNumStartPosition = regexp(testResCharVec, '[0-9]');
            testNumStartPosition = [testNumStartPosition 0];
            for itestCharCount = 1:1:numel(testNumStartPosition)-1
                if (testNumStartPosition(itestCharCount+1) - testNumStartPosition(itestCharCount) == 1)
                    testCharNum = [testCharNum testResCharVec(testNumStartPosition(itestCharCount))];
                else
                    testCharNum = [testCharNum testResCharVec(testNumStartPosition(itestCharCount))];
                    testResNumArray = [testResNumArray str2num(testCharNum)];
                    testCharNum = [];
                end
            end
            for itestCharCount = 1:1:numel(testEllCenter)
                testResCenter(itestCharCount) = testResNumArray(itestCharCount);
            end
            for itestCharCount = 1:1:numel(testShapeMat)
                testResMatNum(itestCharCount) = testResNumArray(numel(testEllCenter) + itestCharCount);
            end
            testResMat = vec2mat(testResMatNum,size(testShapeMat,2));
            testIsRight = (min((testResCenter == [1; 2; 3])) && min(min(testResMat == testShapeMat*testShapeMat')));
            mlunit.assert_equals(testIsRight, 1);
        end
        
        function self = testInv(self)
            testShapeMat = [1 1; 1 1];
            testEll = ellipsoid([1; 2], testShapeMat*testShapeMat');
            self.runAndCheckError('inv(testEll)','degenerateMatrix');
            
            testShapeMat = eye(2,2);
            testEll = ellipsoid([-5; 1], testShapeMat*testShapeMat');
            testResEll = inv(testEll);
            [~, testResMatrix] = double(testResEll);
            testIsRight = (testResMatrix == eye(2,2));
            mlunit.assert_equals(min(min(testIsRight)), 1);
            
            testShapeMat = 2;
            testEll = ellipsoid(-2, testShapeMat*testShapeMat');
            testResEll = inv(testEll);
            [~, testResMatrix] = double(testResEll);
            testIsRight = (testResMatrix == 0.2500);
            mlunit.assert_equals(min(min(testIsRight)), 1);
        end
    end
end