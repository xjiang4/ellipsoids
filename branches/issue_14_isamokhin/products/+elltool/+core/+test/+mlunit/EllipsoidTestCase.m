classdef EllipsoidTestCase < mlunitext.test_case

% $Author: Igor Samokhin, Lomonosov Moscow State University,
% Faculty of Computational Mathematics and Cybernetics, System Analysis
% Department, 22-October-2012, <igorian.vmk@gmail.com>$

    methods
        function self = EllipsoidTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        
        function self = testIsInside(self)
            %figure(1)
            %hold on;
            E = ellipsoid([2; 1], [4, 1; 1, 1]);
            B = ell_unitball(2);
            testRes = isinside(E, [E B], 'i');
            mlunit.assert_equals(1, testRes);
            %figure(2);
            %hold on;
            E = ellipsoid([2; 1], [4, 1; 1, 1]);
            %plot(E);
            B = ell_unitball(2);
            %plot(B);
            testRes = isinside(E, [E B], 'u');
            mlunit.assert_equals(0, testRes);
            %figure(3);
            %hold on;
            %rotate3d;
            E = ellipsoid([2; 1; 0], [4, 1, 1; 1, 2, 1; 1, 1, 5]);
            %plot(E, 'c');
            B = ell_unitball(3);
            %plot(B);
            testRes = isinside(E, [E B], 'i');
            mlunit.assert_equals(1, testRes);
            %figure(4);
            %hold on;
            %rotate3d;
            E = ellipsoid([2; 1; 0], [4, 1, 1; 1, 2, 1; 1, 1, 5]);
            %plot(E, 'c');
            B = ell_unitball(3);
            %plot(B);
            testRes = isinside(E, [E B], 'u');
            mlunit.assert_equals(0, testRes);
            %figure(5);
            %hold on;
            %rotate3d;
            E = ellipsoid([5; 5; 5], [4, 1, 1; 1, 2, 1; 1, 1, 5]);
            %plot(E, 'c');
            B = ell_unitball(3);
            %plot(B);
            testRes = isinside(E, [E B], 'u');
            mlunit.assert_equals(-1, testRes);
        end
        
        function self = testDistance(self)
            testRes = distance([0;0], [1; 0]);
            mlunit.assert_equals(1, testRes);
        end
        
        
        
        
    end
end