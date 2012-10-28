classdef ReachTestCase < mlunitext.test_case
    
    methods
        function self = ReachTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        
        function self = testDimension(self)
            %simple test without u. dimension 2 
            linsysAMat = eye(2);
            linsysBMat = zeros(2);
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
            
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
            
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0]',[0 1]'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);
            [setDimension,spaceDimension] = dimension(testReachSet);
            mlunit.assert_equals(2, spaceDimension);
            mlunit.assert_equals(2, setDimension);
            clear testReachSet;
            clear stationaryLinsys;
        
        %another simple exaple. dimenson 3. 
        
            linsysAMat = eye(3);
            linsysBMat = eye(3);
            configurationQMat = eye(3);
            controlBoundsUEll = ellipsoid(configurationQMat);
            
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
            
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat =[[1 0 0]',[0 0 1]',[1 0 0]'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);
            [setDimension,spaceDimension] = dimension(testReachSet);
            mlunit.assert_equals(3, setDimension);
            mlunit.assert_equals(3, spaceDimension);
            clear testReachSet;
            clear stationaryLinsys;
       
        % found dimension of projection. dimension of thó system is 4
        
            linsysAMat = [1 0 0 0 ; 1 0 0 0;0 0 0 1; 1 1 1 1];
            linsysBMat =zeros(4);
            configurationQMat = eye(4);
            controlBoundsUEll = ellipsoid(configurationQMat);
            
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
            
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0 0 0]',[1 0 0 1]',[1 0 0 1]'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);
            [setDimension,spaceDimension] = dimension(projection(testReachSet,[1 1 0 0;-1 1 0 0].'));
            mlunit.assert_equals(2, setDimension);
            mlunit.assert_equals(4, spaceDimension);
            clear testReachSet;
            clear stationaryLinsys;
       
        % found dimensions of projection. non linear system.
            options               = [];
            options.approximation = 2;
            options.save_all      = 1;
            options.minmax        = 0;
            linsysAMat = {'0' '-10'; '1/(2+sin(t))' '-4/(2+sin(t))'};
            linsysBMat ={'10' '0'; '0' '1/(2+sin(t))'};
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
            
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
            
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0]',[0 1]'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec,options);
            [setDimension,spaceDimension] = dimension(projection(testReachSet,[1 1].'));
            mlunit.assert_equals(1, setDimension);
            mlunit.assert_equals(2, spaceDimension);
            
            
            
       end;
       function self = testProjection(self)
           %dimensions of the reach set and the basis vectors do not match.
            linsysAMat = eye(2);
            linsysBMat = zeros(2);
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
            
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
            
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0]',[0 1]'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);           
            self.runAndCheckError('projection(testReachSet,testReachSet)','wrongInput');
            clear testReachSet;
            clear stationaryLinsys;
       end
       function self = testRefine(self)
            options               = [];
            options.approximation = 2;
            options.save_all      = 1;
            options.minmax        = 0;
            linsysAMat = {'0' '-10'; '1/(2+sin(t))' '-4/(2+sin(t))'};
            linsysBMat ={'10' '0'; '0' '1/(2+sin(t))'};
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
            
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
            
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0]',[0 1]'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec,options);
            initialDirectionsMat2 = [[1 0]',[0 1]',[1 1]'];
            testReachSet2 = reach(stationaryLinsys, initialSetEll, initialDirectionsMat2,...
                             timeIntervalVec,options);
            testReachSetRefine = refine(testReachSet,[1 1]');
            mlunit.assert_equals(testReachSetRefine.ea_values{3}, testReachSet2.ea_values{3});
            mlunit.assert_equals(testReachSetRefine.ia_values{3}, testReachSet2.ia_values{3});
       end
    end
end
