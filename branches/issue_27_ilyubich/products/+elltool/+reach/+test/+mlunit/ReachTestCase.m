classdef ReachTestCase < mlunitext.test_case
   % 
    properties (Access=private)
        testDataRootDir
    end
    %
    methods
        function self = ReachTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
            [~,className]=modgen.common.getcallernameext(1);
            shortClassName=mfilename('classname');
            self.testDataRootDir=[fileparts(which(className)),filesep,'TestData',...
                filesep,shortClassName];
        end
        %  
        function testReachSet = auxGetTestSysParams(self,initialDirectionsMat,timeIntervalVec)
            Options               = [];
            Options.approximation = 2;
            Options.save_all      = 1;
            Options.minmax        = 0;
            linsysACMat = {'0' '-10'; '1/(2+sin(t))' '-4/(2+sin(t))'};
            linsysBCMat ={'10' '0'; '0' '1/(2+sin(t))'};
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
         %   
            stationaryLinsys = linsys(linsysACMat, linsysBCMat, controlBoundsUEll);
         %   
            initialSetEll = ellipsoid(configurationQMat);
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec,Options);
        end    
        %
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
            initialDirectionsMat = [[1 0].',[0 1].'];
            timeIntervalVec = [0 1];
            testReachSet = self.auxGetTestSysParams(initialDirectionsMat,timeIntervalVec);
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
           testAnswer = load(strcat(self.testDataRootDir, '/answer1.mat'),'a');
           testProjection = projection(testReachSet,[1 1 1 0 0].');
           mlunit.assert_equals(eq(get_ea(testAnswer.a), get_ea(testProjection)),ones(size(get_ea(testProjection))));
           mlunit.assert_equals(eq(get_ia(testAnswer.a), get_ia(testProjection)),ones(size(get_ia(testProjection))));
       end
       %
       function self = testRefine(self)
            testReachSet = self.auxGetTestSysParams([[1 0].',[0 1].'],[0 1]);
            testReachSet2 = self.auxGetTestSysParams([[1 0].',[0 1].',[1 1].'],[0 1]);
            testReachSetRefine = refine(testReachSet,[1 1].');
            mlunit.assert_equals(eq(get_ea(testReachSetRefine), get_ea(testReachSet2)),ones(size(get_ea(testReachSet2))));
            mlunit.assert_equals(eq(get_ia(testReachSetRefine), get_ia(testReachSet2)),ones(size(get_ia(testReachSet2))));
            %
            %
            Options               = [];
            Options.approximation = 2;
            Options.save_all      = 1;
            Options.minmax        = 0;
            linsysAMat = load(strcat(self.testDataRootDir, '/testData.mat'),'A');
            linsysBMat = load(strcat(self.testDataRootDir, '/testData.mat'),'B');
            configurationQMat = eye(12);
            controlBoundsUEll = ellipsoid(configurationQMat);
             %
            stationaryLinsys = linsys(linsysAMat.A, linsysBMat.B, controlBoundsUEll);
            %
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [1 1 2 1 0 3 4 2 3 1 2 3].';
            initialDirectionsMat2 = [[1 1 2 1 0 3 4 2 3 1 2 3].',[2 3 5 4 12 3 5 6 3 0 1 2].'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec,Options);      
            testReachSet2 = reach(stationaryLinsys, initialSetEll, initialDirectionsMat2,...
                             timeIntervalVec,Options);  
            testReachSetRefine = refine(testReachSet,[2 3 5 4 12 3 5 6 3 0 1 2].');
            mlunit.assert_equals(eq(get_ea(testReachSetRefine), get_ea(testReachSet2)),ones(size(get_ea(testReachSet2))));
            mlunit.assert_equals(eq(get_ia(testReachSetRefine), get_ia(testReachSet2)),ones(size(get_ia(testReachSet2))));
            %
            %
            Options               = [];
            Options.approximation = 2;
            Options.save_all      = 1;
            Options.minmax        = 0;
            linsysAMat = load(strcat(self.testDataRootDir, '/testData.mat'),'A2');
            linsysBMat = load(strcat(self.testDataRootDir, '/testData.mat'),'B2');
            configurationQMat = eye(12);
            controlBoundsUEll = ellipsoid(configurationQMat);
             %
            stationaryLinsys = linsys(linsysAMat.A2, linsysBMat.B2, controlBoundsUEll);
            %
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [1 1 2 1 0 3 4 2 3 1 2 3].';
            initialDirectionsMat2 = [[1 1 2 1 0 3 4 2 3 1 2 3].',[2 3 5 4 12 3 5 6 3 0 1 2].'];
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec,Options);      
            testReachSet2 = reach(stationaryLinsys, initialSetEll, initialDirectionsMat2,...
                             timeIntervalVec,Options);  
            testReachSetRefine = refine(testReachSet,[2 3 5 4 12 3 5 6 3 0 1 2].');
            mlunit.assert_equals(eq(get_ea(testReachSetRefine), get_ea(testReachSet2)),ones(size(get_ea(testReachSet2))));
            mlunit.assert_equals(eq(get_ia(testReachSetRefine), get_ia(testReachSet2)),ones(size(get_ia(testReachSet2))));
       end
       %
       function self = testPlotEa(self)
            Options               = [];
            Options.approximation = 2;
            Options.save_all      = 1;
            Options.minmax        = 0;
            linsysACMat = {'0' '-10'; '1/(2+sin(t))' '-4/(2+sin(t))'};
            linsysBCMat ={'10' '0'; '0' '1/(2+sin(t))'};
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
            %
            stationaryLinsys = linsys(linsysACMat, linsysBCMat, controlBoundsUEll);
            %
            initialSetEll = ellipsoid(configurationQMat);
            testReachSet = reach(stationaryLinsys, initialSetEll, [1 0].',...
            [0 1],Options);
            hFigure = plot_ea(testReachSet);
            hAxes = findobj(hFigure,'Parent',hFigure,'Type','axes');
            hPlot = findobj(hAxes,'Parent',hAxes,'Type','patch','-or','Type','line');
            [xData] = get(hPlot,'XData');
            [yData] = get(hPlot,'YData');
            [zData] = get(hPlot,'ZData');
            answerData = get_ea(testReachSet);
            [xDataSorted,iDataSorted] = sort(xData(:));
            yDataSorted = yData(iDataSorted);
            zDataSorted = zData(iDataSorted);
            [xDataUnique,iaXData,icXData] = unique(xDataSorted);
            for iPoints=1:size(icXData,1)
                iEllipsoid = icXData(iPoints);
            [qCenter,qMatrix] = double(answerData(iEllipsoid));
             mlunit.assert_equals(abs((([yDataSorted(iPoints);zDataSorted(iPoints)]-qCenter).')*(qMatrix\([yDataSorted(iPoints);zDataSorted(iPoints)]-qCenter))-1)<0.0001,1)
            end
%
%
            linsysAMat = load(strcat(self.testDataRootDir, '/testData2.mat'),'A');
            linsysBMat = load(strcat(self.testDataRootDir, '/testData2.mat'),'B');
            configurationQMat = eye(3);
            controlBoundsUEll = ellipsoid(configurationQMat);
             %
            stationaryLinsys = linsys(linsysAMat.A, linsysBMat.B, controlBoundsUEll);
            %
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [1 0 0].';
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);   
            hFigure = plot_ea(testReachSet);
            hAxes = findobj(hFigure,'Parent',hFigure,'Type','axes');
            hPlot = findobj(hAxes,'Parent',hAxes,'Type','patch','-or','Type','line');
            [xData] = get(hPlot,'XData');
            [yData] = get(hPlot,'YData');
            [zData] = get(hPlot,'ZData');
            answerData = get_ea(testReachSet);
            [qCenter,qMatrix] = double(answerData(end));
            for iPoints=1:size(xData(:),1)       
                mlunit.assert_equals(abs((([xData(iPoints);yData(iPoints);zData(iPoints)]-qCenter).')*(qMatrix\([xData(iPoints);yData(iPoints);zData(iPoints)]-qCenter))-1)<0.0001,1)
            end
            %negative test
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
            self.runAndCheckError('plot_ea(testReachSet)','wrongDimension');
            clear testReachSet;
            clear stationaryLinsys;
       end
       function self = testPlotIa(self)
           Options               = [];
            Options.approximation = 2;
            Options.save_all      = 1;
            Options.minmax        = 0;
            linsysACMat = {'0' '-10'; '1/(2+sin(t))' '-4/(2+sin(t))'};
            linsysBCMat ={'10' '0'; '0' '1/(2+sin(t))'};
            configurationQMat = eye(2);
            controlBoundsUEll = ellipsoid(configurationQMat);
            %
            stationaryLinsys = linsys(linsysACMat, linsysBCMat, controlBoundsUEll);
            %
            initialSetEll = ellipsoid(configurationQMat);
            testReachSet = reach(stationaryLinsys, initialSetEll, [1 0].',...
            [0 1],Options);
            hFigure = plot_ia(testReachSet);
            hAxes = findobj(hFigure,'Parent',hFigure,'Type','axes');
            hPlot = findobj(hAxes,'Parent',hAxes,'Type','patch','-or','Type','line');
            [xData] = get(hPlot,'XData');
            [yData] = get(hPlot,'YData');
            [zData] = get(hPlot,'ZData');
            answerData = get_ia(testReachSet);
            [xDataSorted,iDataSorted] = sort(xData(:));
            yDataSorted = yData(iDataSorted);
            zDataSorted = zData(iDataSorted);
            [xDataUnique,iaXData,icXData] = unique(xDataSorted);
            for iPoints=1:size(icXData,1)
                iEllipsoid = icXData(iPoints);
            [qCenter,qMatrix] = double(answerData(iEllipsoid));
             mlunit.assert_equals(abs((([yDataSorted(iPoints);zDataSorted(iPoints)]-qCenter).')*(qMatrix\([yDataSorted(iPoints);zDataSorted(iPoints)]-qCenter))-1)<0.0001,1)
            end
%             
%
%
             linsysAMat = load(strcat(self.testDataRootDir, '/testData2.mat'),'A');
            linsysBMat = load(strcat(self.testDataRootDir, '/testData2.mat'),'B');
            configurationQMat = eye(3);
            controlBoundsUEll = ellipsoid(configurationQMat);
             %
            stationaryLinsys = linsys(linsysAMat.A, linsysBMat.B, controlBoundsUEll);
            %
            initialSetEll = ellipsoid(configurationQMat);
            initialDirectionsMat = [1 0 0].';
            timeIntervalVec = [0 1];
            testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
                             timeIntervalVec);   
            hFigure = plot_ia(testReachSet);
            hAxes = findobj(hFigure,'Parent',hFigure,'Type','axes');
            hPlot = findobj(hAxes,'Parent',hAxes,'Type','patch','-or','Type','line');
            [xData] = get(hPlot,'XData');
            [yData] = get(hPlot,'YData');
            [zData] = get(hPlot,'ZData');
            answerData = get_ia(testReachSet);
            [qCenter,qMatrix] = double(answerData(end));
            for iPoints=1:size(xData(:),1)       
                mlunit.assert_equals(abs((([xData(iPoints);yData(iPoints);zData(iPoints)]-qCenter).')*(qMatrix\([xData(iPoints);yData(iPoints);zData(iPoints)]-qCenter))-1)<0.0001,1)
            end
              %negative test
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
            self.runAndCheckError('plot_ia(testReachSet)','wrongDimension');
            clear testReachSet;
            clear stationaryLinsys;
       end
       function self = testEvolve(self)
%             linsysAMat = load(strcat(self.testDataRootDir, '/testData.mat'),'A');
%             linsysBMat = load(strcat(self.testDataRootDir, '/testData.mat'),'B');
%             linsysA2Mat = load(strcat(self.testDataRootDir, '/testData.mat'),'A2');
%             linsysB2Mat = load(strcat(self.testDataRootDir, '/testData.mat'),'B2');
%             configurationQMat = eye(12);
%             controlBoundsUEll = ellipsoid(configurationQMat);
%             %
%             stationaryLinsys = linsys(linsysAMat.A, linsysBMat.B, controlBoundsUEll);
%             stationaryLinsys2 = linsys(linsysA2Mat.A2, linsysB2Mat.B2, controlBoundsUEll);
%             %
%             initialSetEll = ellipsoid(configurationQMat);
%             initialDirectionsMat = [1 0 0 0 0 0 0 0 0 0 0 1].';
%             timeIntervalVec = [0 1];
%             testReachSet = reach(stationaryLinsys, initialSetEll, initialDirectionsMat,...
%                              timeIntervalVec);   
%             testEvolveSet = evolve(testReachSet,2,stationaryLinsys2);
%             answerEvolve = load(strcat(self.testDataRootDir, '/answer4.mat'),'evolveSet');
%             mlunit.assert_equals(eq(get_ea(answerEvolve.evolveSet), get_ea(testEvolveSet)),ones(size(get_ea(testEvolveSet))));
%             mlunit.assert_equals(eq(get_ia(answerEvolve.evolveSet), get_ia(testEvolveSet)),ones(size(get_ia(testEvolveSet))));
      

%            initialDirectionsMat = [[1 0].',[0 1].'];
%            timeIntervalVec = [0 1];
%            testReachSet = self.auxGetTestSysParams(initialDirectionsMat,timeIntervalVec);
%            timeIntervalVec2 = [0 2];
%            answerReachSet = self.auxGetTestSysParams(initialDirectionsMat,timeIntervalVec2);
%            evolveReachSet = evolve(testReachSet,2);
%            eaAnswer = get_ea(cut(answerReachSet,[1 2]));
%            iaAnswer = get_ea(cut(answerReachSet,[1 2]));
%            eaTest = get_ea(evolveReachSet);
%            iaTest = get_ia(evolveReachSet);
%            evolveReachSet.time_values(2)
%            c = cut(answerReachSet,[1 2]);
%            c.time_values(2)
%            eaAnswer(1,2)
%             eaTest(1,2)
%             eaAnswer(1,2) == eaTest(1,2)
%            mlunit.assert_equals(eq(eaAnswer(:,2:end),eaTest(:,2:2:end)),ones(size(eaTest(:,2:2:end))));
%            mlunit.assert_equals(eq(iaAnswer(:,2:end), iaTest(:,2:2:end)),ones(size(eaTest(:,2:2:end))));
%negative test
        testReachSet = self.auxGetTestSysParams([[1 0].',[0 1].'],[0 1]);
        self.runAndCheckError('evolve(projection(testReachSet,[1;0]),2)','wrongInput');
       end
    end
end
