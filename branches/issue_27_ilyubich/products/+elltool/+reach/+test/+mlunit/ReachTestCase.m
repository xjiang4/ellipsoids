classdef ReachTestCase < mlunitext.test_case
   % 
    methods
        function self = ReachTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
      %  
        function self = testDimension(self)
            %simple test without u. dimension 2 
            linsysAMat = eye(2);
            linsysBMat = zeros(2);
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
            %
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
            %
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0].',[0 1].'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);
            [setDimension,spaceDimension] = dimension(testReachSet);
            mlunit.assert_equals(2, spaceDimension);
            mlunit.assert_equals(2, setDimension);
            clear testReachSet;
            clear stationaryLinsys;
        %
        %another simple exaple. dimenson 3. 
        %
            linsysAMat = eye(3);
            linsysBMat = eye(3);
            configurationQMat = eye(3);
            controlBoundsUEll = ellipsoid(configurationQMat);
        %   
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
        %    
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat =[[1 0 0].',[0 0 1].',[1 0 0].'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);
            [setDimension,spaceDimension] = dimension(testReachSet);
            mlunit.assert_equals(3, setDimension);
            mlunit.assert_equals(3, spaceDimension);
            clear testReachSet;
            clear stationaryLinsys;
        %
        % found dimension of projection. dimension of thó system is 4
        %
            linsysAMat = [1 0 0 0 ; 1 0 0 0;0 0 0 1; 1 1 1 1];
            linsysBMat =zeros(4);
            configurationQMat = eye(4);
            controlBoundsUEll = ellipsoid(configurationQMat);
        %   
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
        %    
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0 0 0].',[1 0 0 1].',[1 0 0 1].'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);
            [setDimension,spaceDimension] = dimension(projection(testReachSet,[1 1 0 0;-1 1 0 0].'));
            mlunit.assert_equals(2, setDimension);
            mlunit.assert_equals(4, spaceDimension);
            clear testReachSet;
            clear stationaryLinsys;
        %
        % found dimensions of projection. non linear system.
            options               = [];
            options.approximation = 2;
            options.save_all      = 1;
            options.minmax        = 0;
            linsysAMat = {'0' '-10'; '1/(2+sin(t))' '-4/(2+sin(t))'};
            linsysBMat ={'10' '0'; '0' '1/(2+sin(t))'};
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
         %   
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
         %   
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0].',[0 1].'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec,options);
            [setDimension,spaceDimension] = dimension(projection(testReachSet,[1 1].'));
            mlunit.assert_equals(1, setDimension);
            mlunit.assert_equals(2, spaceDimension);
          %  
          %  
          %  
       end;
       function self = testProjection(self)
           %dimensions of the reach set and the basis vectors do not match.
            linsysAMat = eye(2);
            linsysBMat = zeros(2);
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
            %
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
            %
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0].',[0 1].'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);           
            self.runAndCheckError('projection(testReachSet,testReachSet)','wrongInput');
            clear testReachSet;
            clear stationaryLinsys;
           %
           % 
           %high dimensionality
           linsysAMat = [0.8147,    0.0975,    0.1576,    0.1419,    0.6557;
                         0.9058,    0.2785,    0.9706,    0.4218,    0.0357;
                         0.1270,    0.5469,    0.9572,    0.9157,    0.8491;
                         0.9134,    0.9575,    0.4854,    0.7922,    0.9340;
                         0.6324,    0.9649,    0.8003,    0.9595,    0.6787];
           linsysBMat = [0.7577,    0.7060,    0.8235,    0.4387,    0.4898;
                         0.7431,    0.0318,    0.6948,    0.3816,    0.4456;
                         0.3922,    0.2769,    0.3171,    0.7655,    0.6463;
                         0.6555,    0.0462,    0.9502,    0.7952,    0.7094;
                         0.1712,    0.0971,    0.0344,    0.1869,    0.7547];
           configurationQMat = eye(5);
           controlBoundsUEll = ellipsoid(configurationQMat);
           %
           stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
           %
           initialSetEll = ellipsoid(configurationQMat);
           initialDirectionsMat = [[1 1 2 1 0].',[1 2 1 0 1].'];
           timeIntervalVec = [0 1];
           testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);            
           testAnswer = load('answer1.mat','a');
           testProjection = projection(testReachSet,[1 1 1 0 0].');
           mlunit.assert_equals(testAnswer.a.ea_values{1}, testProjection.ea_values{1});
           mlunit.assert_equals(testAnswer.a.ea_values{2}, testProjection.ea_values{2});
           mlunit.assert_equals(testAnswer.a.ia_values{1}, testProjection.ia_values{1});
           mlunit.assert_equals(testAnswer.a.ia_values{2}, testProjection.ia_values{2});
           mlunit.assert_equals(testAnswer.a.projection_basis, testProjection.projection_basis);
       end
       %
       function self = testRefine(self)
            options               = [];
            options.approximation = 2;
            options.save_all      = 1;
            options.minmax        = 0;
            linsysAMat = {'0' '-10'; '1/(2+sin(t))' '-4/(2+sin(t))'};
            linsysBMat ={'10' '0'; '0' '1/(2+sin(t))'};
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
            %
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
            %
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0].',[0 1].'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec,options);
            initialDirectionsMat2 = [[1 0].',[0 1].',[1 1].'];
            testReachSet2 = reach(stationaryLinsys, initialSetEll, initialDirectionsMat2,...
                             timeIntervalVec,options);
            testReachSetRefine = refine(testReachSet,[1 1].');
            mlunit.assert_equals(testReachSetRefine.ea_values{3}, testReachSet2.ea_values{3});
            mlunit.assert_equals(testReachSetRefine.ia_values{3}, testReachSet2.ia_values{3});
       end
       %
       function self = testPlotEa(self)
           %touch tests
           linsysAMat = {'0' '-10'; '1/(2+sin(t))' '-4/(2+sin(t))'};
            linsysBMat ={'10' '0'; '0' '1/(2+sin(t))'};
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
            %
            stationaryLinsys = linsys(linsysAMat, linsysBMat, controlBoundsUEll);
            %
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [[1 0].',[0 1].'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec,options);
            plot_ea(testReachSet);
    end
end
