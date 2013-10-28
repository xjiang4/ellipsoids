classdef ExamplesTC < mlunitext.test_case
    %
    methods
        function self = ExamplesTC(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        %
        function tear_down(~)
            close all;
        end
        %
        function test_fromQArraysExamples(self)
            
        end
    end
end

