classdef EllipsoidPlotTestCase < mlunitext.test_case
    %
    properties (Access=private)
        testDataRootDir
    end
    %
    methods
        function self = EllipsoidPlotTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
            [~,className]=modgen.common.getcallernameext(1);
            shortClassName=mfilename('classname');
            self.testDataRootDir=[fileparts(which(className)),filesep,'TestData',...
                filesep,shortClassName];
        end
        function self = testPlot(self)
            qMat1 = [3 2;2 5];
            el1 = ellipsoid(qMat1);
            plObj = plot(el1);
            plotStructure = plObj.getPlotStructure;
            hPlot =  toStruct(plotStructure.figToAxesToPlotHMap);
            num = hPlot.figure_gr1;
            for iEl =1:size(num.ax,2)
                [xData] = get(num.ax(iEl),'XData');
                [yData] = get(num.ax(iEl),'YData');
                for iPoint=1:size(xData,2)-1
                    point = [xData(iPoint);yData(iPoint)];
                    mlunit.assert_equals(abs((point.'/qMat1)*point-1)<elltool.conf.Properties.getAbsTol(),1);
                end
            end
        end
    end
end