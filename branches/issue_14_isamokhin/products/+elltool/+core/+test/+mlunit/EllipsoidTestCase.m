classdef EllipsoidTestCase < mlunitext.test_case

    
% $Author: Igor Samokhin, Lomonosov Moscow State University,
% Faculty of Computational Mathematics and Cybernetics, System Analysis
% Department, 02-November-2012, <igorian.vmk@gmail.com>$

    properties (Access=private)
        testDataRootDir
     end

    methods
        function self=EllipsoidTestCase(varargin)
            self=self@mlunitext.test_case(varargin{:});
            [~,className]=modgen.common.getcallernameext(1);
            shortClassName=mfilename('classname');
            self.testDataRootDir=[fileparts(which(className)),filesep,'TestData',...
                filesep,shortClassName];
        end
        
        function self = testIsInside(self)
            E = ellipsoid([2; 1], [4, 1; 1, 1]);
            B = ell_unitball(2);
            testRes = isinside(E, [E B], 'i');
            mlunit.assert_equals(1, testRes);
            E = ellipsoid([2; 1], [4, 1; 1, 1]);
            B = ell_unitball(2);
            testRes = isinside(E, [E B]);
            mlunit.assert_equals(0, testRes);
            E = ellipsoid([2; 1; 0], [4, 1, 1; 1, 2, 1; 1, 1, 5]);
            B = ell_unitball(3);
            testRes = isinside(E, [E B], 'i');
            mlunit.assert_equals(1, testRes);
            E = ellipsoid([2; 1; 0], [4, 1, 1; 1, 2, 1; 1, 1, 5]);
            B = ell_unitball(3);
            testRes = isinside(E, [E B], 'u');
            mlunit.assert_equals(0, testRes);
            E = ellipsoid([5; 5; 5], [4, 1, 1; 1, 2, 1; 1, 1, 5]);
            B = ell_unitball(3);
            testRes = isinside(E, [E B], 'i');
            mlunit.assert_equals(-1, testRes);
            E = ellipsoid([5; 5; 5], [4, 1, 1; 1, 2, 1; 1, 1, 5]);
            B = ell_unitball(3);
            testRes = isinside(E, [E B], 'u');
            mlunit.assert_equals(0, testRes);
            E = ellipsoid([5; 5; 5; 5], [4, 1, 1, 1; 1, 2, 1, 1; 1, 1, 5, 1; 1, 1, 1, 6]);
            B = ell_unitball(4);
            testRes = isinside([E B], E, 'i');
            mlunit.assert_equals(0, testRes);
            E = ellipsoid([5; 5; 5; 5], [4, 1, 1, 1; 1, 2, 1, 1; 1, 1, 5, 1; 1, 1, 1, 6]);
            B = ell_unitball(4);
            testRes = isinside([E B], [E B]);
            mlunit.assert_equals(0, testRes);            
        end
        
        function self = testDistance(self)
            
            global  ellOptions;
%             load(strcat(self.testDataRootDir,filesep,'testEllEllRMat.mat'),...
%                  'testOrth50Mat','testOrth100Mat','testOrth3Mat','testOrth2Mat');
%             %
%             %testing vector-ellipsoid distance
%             %
%             %distance between ellipsoid and two vectors
%             testEllipsoid = ellipsoid([1,0,0;0,5,0;0,0,10]);
%             testPointMat = [3,0,0; 5,0,0].';
%             testResVec = distance(testEllipsoid, testPointMat);
%             mlunit.assert_equals(1, (abs(testResVec(1)-2)<ellOptions.abs_tol) &&...
%                 (abs(testResVec(2)-4)<ellOptions.abs_tol));
%             %
%             %distance between ellipsoid and point in the ellipsoid
%             %and point on the boader of the ellipsoid
%             testEllipsoid = ellipsoid([1,2,3].',4*eye(3,3));
%             testPointMat = [2,3,2; 1,2,5].';
%             testResVec = distance(testEllipsoid, testPointMat);
%             mlunit.assert_equals(1, testResVec(1)==-1 && testResVec(2)==0);
%             %           
%             %distance between two ellipsoids and two vectors
%             testEllipsoidVec = [ellipsoid([5,2,0;2,5,0;0,0,1]),...
%                 ellipsoid([0,0,5].',[4, 0, 0; 0, 9 , 0; 0,0, 25])];
%             testPointMat = [0,0,5; 0,5,5].';
%             testResVec = distance(testEllipsoidVec, testPointMat);
%             mlunit.assert_equals(1, (abs(testResVec(1)-4)<ellOptions.abs_tol) &&...
%                 (abs(testResVec(2)-2)<ellOptions.abs_tol));
%             %
%             %distance between two ellipsoids and a vector
%             testEllipsoidVec = [ellipsoid([5,5,0].',[1,0,0;0,5,0;0,0,10]),...
%                 ellipsoid([0,10,0].',[10, 0, 0; 0, 16 , 0; 0,0, 5])];
%             testPointVec = [0,5,0].';
%             testResVec = distance(testEllipsoidVec, testPointVec);
%             mlunit.assert_equals(1, (abs(testResVec(1)-4)<ellOptions.abs_tol) &&...
%                 (abs(testResVec(2)-1)<ellOptions.abs_tol));
%             %
%             %negative test: matrix Q of ellipsoid has very large
%             %eigenvalues.
%             testEllipsoid = ellipsoid([1e+15,0;0,1e+15]);
%             testPointVec = [3e+15,0].';
%             self.runAndCheckError('distance(testEllipsoid, testPointVec)',...
%                 'notSecant');
%             %
%             %random ellipsoid matrix, low dimension case
%             nDim=2;
%             testEllMat=diag(1:2);
%             testEllMat=testOrth2Mat*testEllMat*testOrth2Mat.';
%             testEllMat=0.5*(testEllMat+testEllMat.');
%             testEllipsoid=ellipsoid(testEllMat);
%             testPoint=testOrth2Mat*[10;zeros(nDim-1,1)];
%             testRes=distance(testEllipsoid, testPoint);
%             mlunit.assert_equals(1,abs(testRes-9)<ellOptions.abs_tol);
%             %
%             %high dimensional tests with rotated ellipsoids
%             nDim=50;
%             testEllMat=diag(nDim:-1:1);
%             testEllMat=testOrth50Mat*testEllMat*testOrth50Mat.';
%             testEllMat=0.5*(testEllMat+testEllMat.');
%             testEllipsoid=ellipsoid(testEllMat);
%             testPoint=testOrth50Mat*[zeros(nDim-1,1);10];
%             testRes=distance(testEllipsoid, testPoint);
%             mlunit.assert_equals(1,abs(testRes-9)<ellOptions.abs_tol);
%             
%             %distance between two ellipsoids with random matrices and two vectors
%             testEll1Mat=[5,2,0;2,5,0;0,0,1];
%             testEll1Mat=testOrth3Mat*testEll1Mat*testOrth3Mat.';
%             testEll1Mat=0.5*(testEll1Mat+testEll1Mat.');
%             testEll2Mat=[4,0,0;0,9,0;0,0,25];
%             testEll2Mat=testOrth3Mat*testEll2Mat*testOrth3Mat.';
%             testEll2Mat=0.5*(testEll2Mat+testEll2Mat.');
%             testEll2CenterVec=testOrth3Mat*[0;0;5];
%             testEllipsoidVec = [ellipsoid(testEll1Mat),...
%                 ellipsoid(testEll2CenterVec,testEll2Mat)];
%             testPointMat = testOrth3Mat*([0,0,5; 0,5,5].');
%             testResVec = distance(testEllipsoidVec, testPointMat);
%             mlunit.assert_equals(1, (abs(testResVec(1)-4)<ellOptions.abs_tol) &&...
%                 (abs(testResVec(2)-2)<ellOptions.abs_tol));
%             %
%             %
%             %
%             %
%             %Testing ellipsoid-ellipsoid distance
%             %
%             %distance between two ellipsoids
%             testEllipsoid1 = ellipsoid([25,0;0,9]);
%             testEllipsoid2 = ellipsoid([10;0],[4,0;0,9]);
%             testRes=distance(testEllipsoid1,testEllipsoid2);
%             mlunit.assert_equals(1, (abs(testRes-3)<ellOptions.abs_tol));
%             %    
%             testEllipsoid1 = ellipsoid([0,-15,0].',[25,0,0;0,100,0;0,0,9]);
%             testEllipsoid2 = ellipsoid([0,7,0].',[9,0,0;0,25,0;0,0,100]);
%             testRes=distance(testEllipsoid1,testEllipsoid2);
%             mlunit.assert_equals(1, (abs(testRes-7)<ellOptions.abs_tol));
%             %
%             % case of ellipses with common center
%             testEllipsoid1 = ellipsoid([1 2 3].',[1,2,5;2,5,3;5,3,100]);
%             testEllipsoid2 = ellipsoid([1,2,3].',[1,2,7;2,10,5;7,5,100]);
%             testRes=distance(testEllipsoid1,testEllipsoid2);
%             mlunit.assert_equals(1, (abs(testRes)<ellOptions.abs_tol));
%             %
%             % distance between two pairs of ellipsoids 
%             testEllipsoid1Vec=[ellipsoid([0, -6, 0].',[100,0,0; 0,4,0; 0,0, 25]),...
%                 ellipsoid([0,0,-4.5].',[100,0,0; 0, 25,0; 0,0,4])];
%             testEllipsoid2Vec=[ellipsoid([0, 6, 0].',[100,0,0; 0,4,0; 0,0, 25]),...
%                 ellipsoid([0,0,4.5].',[100,0,0; 0, 25,0; 0,0,4])];
%             testResVec=distance(testEllipsoid1Vec,testEllipsoid2Vec);
%             mlunit.assert_equals(1, (abs(testResVec(1)-8)<ellOptions.abs_tol) &&...
%                 (abs(testResVec(2)-5)<ellOptions.abs_tol));
%             %            
%             % distance between two ellipsoids and an ellipsoid 
%             testEllipsoidVec=[ellipsoid([0, 0, 0].',[9,0,0; 0,25,0; 0,0, 1]),...
%                 ellipsoid([-5,0,0].',[9,0,0; 0, 25,0; 0,0,1])];
%             testEllipsoid=ellipsoid([5, 0, 0].',[25,0,0; 0,100,0; 0,0, 1]);
%             testResVec=distance(testEllipsoidVec,testEllipsoid);
%             mlunit.assert_equals(1, (abs(testResVec(1))<ellOptions.abs_tol) &&...
%                 (abs(testResVec(2)-2)<ellOptions.abs_tol));
%             %
%             %distance between two ellipsoids of high dimensions
%             nDim=100;
%             testEllipsoid1=ellipsoid(diag(1:2:2*nDim));
%             testEllipsoid2=ellipsoid([5;zeros(nDim-1,1)],diag(1:nDim));
%             testRes=distance(testEllipsoid1,testEllipsoid2);
%             mlunit.assert_equals(1,abs(testRes-3)<ellOptions.abs_tol);
%             %
%             %distance between two vectors of ellipsoids of rather high
%             %dimension (12<=nDim<=26) with matrices that have nonzero non
%             %diagonal elements
%             load(strcat(self.testDataRootDir,filesep,'testEllEllDist.mat'),...
%                  'testEllipsoid1Vec','testEllipsoid2Vec','testAnswVec','nEllVec');
%             testResVec=distance(testEllipsoid1Vec,testEllipsoid2Vec);
%             mlunit.assert_equals(ones(1,nEllVec),...
%                  abs(testResVec-testAnswVec)<ellOptions.abs_tol);
%             %
%             %distance between two ellipsoids and an ellipsoid (of 3-dimension), 
%             %all matrices with nonzero nondiagonal elements 
%             testEll1Mat=[9,0,0; 0,25,0; 0,0, 1];
%             testEll1Mat=testOrth3Mat*testEll1Mat*testOrth3Mat.';
%             testEll1Mat=0.5*(testEll1Mat+testEll1Mat.');
%             testEll2Mat=[9,0,0; 0, 25,0; 0,0,1];
%             testEll2Mat=testOrth3Mat*testEll2Mat*testOrth3Mat.';
%             testEll2Mat=0.5*(testEll2Mat+testEll2Mat.');
%             testEll2CenterVec=testOrth3Mat*[-5;0;0];
%             testEll3Mat=[25,0,0; 0,100,0; 0,0, 1];
%             testEll3Mat=testOrth3Mat*testEll3Mat*testOrth3Mat.';
%             testEll3Mat=0.5*(testEll3Mat+testEll3Mat.');
%             testEll3CenterVec=testOrth3Mat*[5;0;0];
%             testEllipsoidVec=[ellipsoid(testEll1Mat),...
%                 ellipsoid(testEll2CenterVec,testEll2Mat)];
%             testEllipsoid=ellipsoid(testEll3CenterVec,testEll3Mat);
%             testResVec=distance(testEllipsoidVec,testEllipsoid);
%             mlunit.assert_equals(1, (abs(testResVec(1))<ellOptions.abs_tol) &&...
%                 (abs(testResVec(2)-2)<ellOptions.abs_tol));
%             %
%             %distance between two ellipsoids of high dimensions and random
%             %matrices
%             nDim=100;
%             testEll1Mat=diag(1:2:2*nDim);
%             testEll1Mat=testOrth100Mat*testEll1Mat*testOrth100Mat.';
%             testEll1Mat=0.5*(testEll1Mat+testEll1Mat.');
%             testEll2Mat=diag([25;(1:(nDim-1)).']);
%             testEll2Mat=testOrth100Mat*testEll2Mat*testOrth100Mat.';
%             testEll2Mat=0.5*(testEll2Mat+testEll2Mat.');
%             testEll2CenterVec=testOrth100Mat*[9;zeros(nDim-1,1)];            
%             testEllipsoid1=ellipsoid(testEll1Mat);
%             testEllipsoid2=ellipsoid(testEll2CenterVec,testEll2Mat);
%             testRes=distance(testEllipsoid1,testEllipsoid2);
%             mlunit.assert_equals(1,abs(testRes-3)<ellOptions.abs_tol);
%             %
%             %
%             %
%             %distance between an ellipsoid (with nonzeros nondiagonal elements)
%             %and a hyperplane in 2 dimensions
%             testEllMat=[9 0; 0 4];
%             testEllMat=testOrth2Mat*testEllMat*testOrth2Mat.';
%             testEllMat=0.5*(testEllMat+testEllMat.');
%             testEllCenterVec=testOrth2Mat*[0;5];
%             testHypVVec=testOrth2Mat*[0;1];
%             testHypC=0;
%             testEllipsoid=ellipsoid(testEllCenterVec,testEllMat);
%             testHyp=hyperplane(testHypVVec,testHypC);
%             testRes=distance(testEllipsoid,testHyp);
%             mlunit.assert_equals(1,abs(testRes-3)<ellOptions.abs_tol);
%             %
%             %distance between an ellipsoid (with nonzero nondiagonal elements)
%             %and a hyperplane in 3 dimensions
%             testEllMat=[100,0,0;0,25,0;0,0,9];
%             testEllMat=testOrth3Mat*testEllMat*testOrth3Mat.';
%             testEllMat=0.5*(testEllMat+testEllMat.');
%             testHypVVec=testOrth3Mat*[0;1;0];
%             testHypC=10;
%             testEllipsoid=ellipsoid(testEllMat);
%             testHyp=hyperplane(testHypVVec,testHypC);
%             testRes=distance(testEllipsoid,testHyp);
%             mlunit.assert_equals(1,abs(testRes-5)<ellOptions.abs_tol);
%             %
%             %distance between two high dimensional ellipsoids (with nonzero
%             %nondiagonal elements) and a hyperplane
%             nDim=100;
%             testEll1Mat=diag(1:nDim);
%             testEll1Mat=testOrth100Mat*testEll1Mat*testOrth100Mat.';
%             testEll1Mat=0.5*(testEll1Mat+testEll1Mat.');
%             testEll1CenterVec=testOrth100Mat*[-8;zeros(nDim-1,1)];    
%             testEll2Mat=diag([25;(1:(nDim-1)).']);
%             testEll2Mat=testOrth100Mat*testEll2Mat*testOrth100Mat.';
%             testEll2Mat=0.5*(testEll2Mat+testEll2Mat.');
%             testEll2CenterVec=testOrth100Mat*[10;zeros(nDim-1,1)];    
%             testHypVVec=testOrth100Mat*[1;zeros(nDim-1,1)];
%             testHypC=0;
%             testEllipsoid=[ellipsoid(testEll1CenterVec,testEll1Mat),...
%                 ellipsoid(testEll2CenterVec,testEll2Mat)];
%             testHyp=hyperplane(testHypVVec,testHypC);
%             testRes=distance(testEllipsoid,testHyp);
%             mlunit.assert_equals(1,abs(testRes(1)-7)<ellOptions.abs_tol&&...
%                 abs(testRes(2)-5)<ellOptions.abs_tol);    
%             %
            E = ell_unitball(4);
            testRes = distance(E, [0; 0; 0; 0]);
            mlunit.assert_equals(-1, testRes);
            E = ell_unitball(4);
            testRes = distance(E, [2 0 0 0; 0 2 0 0]');
            flag = abs((testRes - [1 1])) < [ellOptions.abs_tol, ellOptions.abs_tol];
            mlunit.assert_equals(true, all(flag));
            E1 = ell_unitball(4);
            E2 = ellipsoid([5; 0; 0; 0], diag(ones(1, 4)));
            testRes = distance(E1, E2);
            flag = abs(testRes - 3) < ellOptions.abs_tol;
            mlunit.assert_equals(true, flag);
            E1 = ellipsoid([5; 0], diag([4, 1]));
            E2 = ellipsoid([0; 0], diag([1, 4]));
            testRes = distance(E1, E2);
            flag = abs(testRes - 2) < ellOptions.abs_tol;
            mlunit.assert_equals(true, flag);
            A = [cos(pi / 4), sin(pi / 4); - sin(pi / 4), cos(pi / 4)];
            E1 = A * ellipsoid([5; 0], diag([4, 1]));
            E2 = A * ellipsoid([0; 0], diag([1, 4]));
            testRes = distance(E1, E2);
            flag = abs(testRes - 2) < ellOptions.abs_tol;
            mlunit.assert_equals(true, flag);
%             testRes = distance(E1, E2, 1);
%             flag = abs(testRes - 1) < ellOptions.abs_tol;
%             mlunit.assert_equals(true, flag);
        end
        
        function self = testIsBadDirection(self)
            E1 = ell_unitball(6);
            E2 = ellipsoid(zeros(6, 1), diag(0.5 * ones(6, 1)));
            L = [diag(ones(6, 1)), [1; 2; 3; 3; 4; 5]];
            testRes = isbaddirection(E1, E2, L);
            testRes = any(testRes);
            mlunit.assert_equals(0, testRes);
            E1 = ellipsoid([5; 0], diag([4, 1]));
            E2 = ellipsoid([0; 0], diag([1 / 8, 1/ 2]));
            L = [1, -1; 0, 0];
            testRes = isbaddirection(E1, E2, L);
            testRes = all(testRes);
            mlunit.assert_equals(1, testRes);
            L = [1, -1; 2, 3];
            testRes = isbaddirection(E1, E2, L);
            testRes = any(testRes);
            mlunit.assert_equals(0, testRes);
            E1 = ellipsoid([0; 0; 0], diag([4, 1, 1]));
            E2 = ellipsoid([0; 0; 0], diag([1 / 8, 1/ 2, 1 / 2]));
            L = [1, -1, 1000, 1000; 0, 0, 0.5, 0.5; 0, 0, -0.5, -1];
            testRes = isbaddirection(E1, E2, L);
            testRes = all(testRes);
            mlunit.assert_equals(1, testRes);
            L = [1, -1, 0, 0; 1, -2, 1, 2; 7, 3, 2, 1];
            testRes = isbaddirection(E1, E2, L);
            testRes = any(testRes);
            mlunit.assert_equals(0, testRes); 
        end
        
        function self = disabledtestMinkmp_ea(self)
            e0 = zeros(5, 1);
            E0 = diag(ones(1, 5));
            ell0 = ellipsoid(e0, E0);
            q = [6.5; 1; 1; 1; 1];
            Q = diag([5, 2, 2, 2, 2]);
            E = ellipsoid(q, Q);
            ee1 = [3; 3; 65; 4; 23];
            EE1 = diag([13, 3, 2, 2, 2]);
            ell1 = ellipsoid(ee1, EE1);
            ee2 = [3; 8; 3; 2; 6];
            EE2 = diag([7, 2, 6, 2, 2]);
            ell2 = ellipsoid(ee2, EE2);
            EE = [ell1, ell2];
            L = diag(ones(1, 5));
            testRes = minkmp_ea(ell0, E, EE, L);
            mlunit.assert_equals([], testRes); 
            E = 0.5 * ell_unitball(5);
            testRes = minkmp_ea(ell0, E, EE, L);
            analyticResVec = e0 - q + ee1 + ee2;
            analyticRes = [ell0, ell0, ell0, ell0];
            for indi = 1 : 5
                lVec = L(:, indi);
                supp1Mat = sqrt(E0);
                supp1Mat = 0.5 * (supp1Mat + supp1Mat.');
                supp1Vec = supp1Mat * lVec;
                supp2Mat = sqrt(Q);
                supp2Mat = 0.5 * (supp2Mat + supp2Mat.');
                supp2Vec = supp2Mat * lVec;
                [U1, ~, V1] = svd(supp1Vec);
                [U2, ~, V2] = svd(supp2Vec);
                S = U1 * V1 * V2' * U2';
                S = real(S);
                Q_starMat = supp1Mat + S * supp2Mat;
                Q_plusMat = Q_starMat.' * Q_starMat;
                Q_plusMat = 0.5 * (Q_plusMat + Q_plusMat.');
                aDouble = sqrt(dot(lVec, Q_plusMat * lVec));
                a1Double = sqrt(dot(lVec, EE1 * lVec));
                a2Double = sqrt(dot(lVec, EE2 * lVec));
                analyticResMat = (aDouble + a1Double + a2Double) .* ( Q_plusMat ./ aDouble + EE1 ./ a1Double + EE2 ./ a2Double);
                analyticRes(1, indi) = ellipsoid(analyticResVec, analyticResMat);
            end
            
            mlunit.assert_equals(analyticRes, testRes); 
%             q = [1; 0.5; 0.5; 0.5; 0.5];
%             Q = diag([1 / 4, 1 / 16, 1 / 16, 1 / 16, 1 / 16]);
%             E = ellipsoid(q, Q);
%             testRes = minkmp_ea(ell0, E, EE, L);
%             analyticResVec = e0 - q + ee1 + ee2;
%             lVec = L(:, 1);
%             supp1Mat = sqrt(E0);
%             supp1Mat = 0.5 * (supp1Mat + supp1Mat.');
%             supp1Vec = supp1Mat * lVec;
%             supp2Mat = sqrt(Q);
%             supp2Mat = 0.5 * (supp2Mat + supp2Mat.');
%             supp2Vec = supp2Mat * lVec;
%             [U1, ~, V1] = svd(supp1Vec);
%             [U2, ~, V2] = svd(supp2Vec);
%             S = U1 * V1 * V2' * U2';
%             S = real(S);
%             Q_starMat = supp1Mat + S * supp2Mat;
%             Q_plusMat = Q_starMat.' * Q_starMat;
%             Q_plusMat = 0.5 * (Q_plusMat + Q_plusMat.');
%             aDouble = sqrt(dot(lVec, Q_plusMat * lVec));
%             a1Double = sqrt(dot(lVec, EE1 * lVec));
%             a2Double = sqrt(dot(lVec, EE2 * lVec));
%             analyticResMat = (aDouble + a1Double + a2Double) .* ( Q_plusMat ./ aDouble + EE1 ./ a1Double + EE2 ./ a2Double);
%             analyticRes = ellipsoid(analyticResVec, analyticResMat);
%             mlunit.assert_equals(analyticRes, testRes); 
            
        end
        
        
        
    end
end