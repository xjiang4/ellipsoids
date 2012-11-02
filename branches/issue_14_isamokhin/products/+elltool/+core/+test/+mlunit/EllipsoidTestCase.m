classdef EllipsoidTestCase < mlunitext.test_case

    
% $Author: Igor Samokhin, Lomonosov Moscow State University,
% Faculty of Computational Mathematics and Cybernetics, System Analysis
% Department, 22-October-2012, <igorian.vmk@gmail.com>$


    methods
        function self = EllipsoidTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        
        function self = disabledtestIsInside(self)
            ellOptions.abs_tol
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
            global ellOptions;
            E = ell_unitball(4);
            testRes = distance(E, [0; 0; 0; 0]);
            mlunit.assert_equals(-1, testRes);
            E = ell_unitball(4);
            testRes = distance(E, [2 0 0 0; 0 2 0 0]');
            flag = abs((testRes - [1 1])) < [ellOptions.abs_tol, ellOptions.abs_tol];
            mlunit.assert_equals(true, all(flag));
            E1 = ell_unitball(4);
            E2 = ellipsiod([5; 0; 0; 0], diag(ones(1, 4)));
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
            testRes = distance(E1, E2, 1);
            flag = abs(testRes - 1) < ellOptions.abs_tol;
            mlunit.assert_equals(true, flag);
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
            q = [1; 0.5; 0.5; 0.5; 0.5];
            Q = diag([1 / 4, 1 / 16, 1 / 16, 1 / 16, 1 / 16]);
            E = ellipsoid(q, Q);
            testRes = minkmp_ea(ell0, E, EE, L);
            analyticResVec = e0 - q + ee1 + ee2;
            lVec = L(:, 1);
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
            analyticRes = ellipsoid(analyticResVec, analyticResMat);
            mlunit.assert_equals(analyticRes, testRes); 
            
        end
        
        
        
    end
end