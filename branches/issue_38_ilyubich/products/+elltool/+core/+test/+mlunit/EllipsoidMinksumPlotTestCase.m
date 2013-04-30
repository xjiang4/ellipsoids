classdef EllipsoidMinksumPlotTestCase < mlunitext.test_case
    properties (Access=private)
        testDataRootDir
        
    end
    %
    methods
        function self = EllipsoidMinksumPlotTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
            [~,className]=modgen.common.getcallernameext(1);
            shortClassName=mfilename('classname');
            self.testDataRootDir=[fileparts(which(className)),filesep,'TestData',...
                filesep,shortClassName];
        end
        function self = tear_down(self,varargin)
            close all;
        end
        function self = testSimpleOptions(self)
            import elltool.plot.test.testMinkFillAndShade
            import elltool.plot.test.testMinkColor
            import elltool.plot.test.testMinkProperties
            testFirEll = ellipsoid(2*eye(2));
            testSecEll = ellipsoid([1, 0].', [9 2;2 4]);
            testThirdEll = ellipsoid([1 0; 0 0]);
            testForthEll = ellipsoid([0, -1, 3].', 1.5*eye(3));
            testFifthEll = ellipsoid([5,5,5]', [6 2 1; 2 4 3; 1 3 5]);
            testSixthEll = ellipsoid([1 0 0; 0 0 0; 0 0 1]);
            self = testMinkFillAndShade(self,@minksum,testFirEll,testSecEll);
            self = testMinkFillAndShade(self,@minksum,testFirEll,[testSecEll,testThirdEll]);
            self = testMinkFillAndShade(self,@minksum,testForthEll,testFifthEll);
            self = testMinkFillAndShade(self,@minksum,testForthEll,[testFifthEll testSixthEll]);
            self = testMinkColor(self,@minksum,testFirEll,testSecEll,2);
            self = testMinkColor(self,@minksum,testFirEll,[testSecEll,testThirdEll],2);
            self = testMinkColor(self,@minksum,testForthEll,testFifthEll,1);
            self = testMinkColor(self,@minksum,testForthEll,[testFifthEll testSixthEll],1); 
            self = testMinkProperties(self,@minksum,testFirEll,testSecEll);
            self = testMinkProperties(self,@minksum,testFirEll,[testSecEll,testThirdEll]);
            self = testMinkProperties(self,@minksum,testForthEll,testFifthEll);
            self = testMinkProperties(self,@minksum,testForthEll,[testFifthEll testSixthEll]); 
            minksum(testFirEll,testSecEll,testThirdEll,'showAll',true);
            minksum(testForthEll,testFifthEll,testSixthEll,'showAll',true);
        end
        function self = test2d(self)
            testFirEll = ellipsoid([1, 0].', [9 2;2 4]);
            testSecEll = ellipsoid(eye(2));
            check(testFirEll,testSecEll);
            
            function check(testFirEll,testSecEll)
                ABS_TOL = 10^(-10);
                [~,boundPointsMat] = minksum(testFirEll,testSecEll);
                [lGridMat] = gras.geom.circlepart(200);
                [supp1Mat,~] = rho(testFirEll,lGridMat.');
                [supp2Mat,~] = rho(testSecEll,lGridMat.');
                rhoDiffVec = supp1Mat+supp2Mat;
                sup = max(lGridMat*boundPointsMat(:,1:end-1),[],2);
                mlunit.assert_equals(abs(sup'-rhoDiffVec) < ABS_TOL,ones(1,size(sup,1)));      
            end
        end
%         function self = test3d(self)           
%             testFirEll = ellipsoid([9 2 0 ;2 4 0; 0 0 4]);
%             testSecEll = ellipsoid(eye(3));
%             check(testFirEll,testSecEll);
%             function check(testFirEll,testSecEll)
%                 ABS_TOL = 10^(-10);
%                 rotMat = [cos(31) sin(31) 0 ; -sin(31) cos(31) 0 ;0 0 1];
%                 firstMat = rotMat*[9 2 0 ;2 4 0; 0 0 4]*rotMat.';
%                 firstMat(1,2) = firstMat(2,1);
%                 testThirdEll = ellipsoid(firstMat);
%                 testForthEll = ellipsoid(rotMat*eye(3)*rotMat.');
%                 [~,boundPoints1Mat] = minksum(testFirEll,testSecEll);
%                 [~,boundPoints2Mat] = minksum(testThirdEll,testForthEll);
%                 mlunit.assert_equals(abs(boundPoints2Mat*rotMat.'-boundPoints1Mat) < ABS_TOL,ones(1,size(boundPoints2Mat,1)));
%             end
%         end
    end
end