classdef HyperplaneTestCase < mlunitext.test_case
   % 
    properties (Access=private)
        testDataRootDir
    end
    %
    methods
        function self = HyperplaneTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
            [~,className]=modgen.common.getcallernameext(1);
            shortClassName=mfilename('classname');
            self.testDataRootDir=[fileparts(which(className)),filesep,'TestData',...
                filesep,shortClassName];
        end
        function self = testPlot(self)
            left = [1:5;1:2:10;1:3:15];
            right = ones(1,5);
            testHyperplane  = hyperplane(left,right);
            plObj = plot(testHyperplane);
            plotStructure = plObj.getPlotStructure;
            hPlot =  toStruct(plotStructure.figToAxesToPlotHMap);
            num = hPlot.figure_gr1;
            for iHyp =1:size(num.ax,2)
                [xData] = get(num.ax(iHyp),'XData');
                [yData] = get(num.ax(iHyp),'YData');
                [zData] = get(num.ax(iHyp),'ZData');
                answer = xData.*left(1,iHyp)+yData.*left(2,iHyp)+zData.*left(3,iHyp);
                mlunit.assert_equals(abs(answer-ones(size(answer)).*right(iHyp))<elltool.conf.Properties.getAbsTol(),ones(size(answer)));
            end
        end
    end
end