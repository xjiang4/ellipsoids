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
        function test_examples(~)
            gras.ellapx.smartdb.test.examples.example_fromQArrays();
            gras.ellapx.smartdb.test.examples.example_fromQMArrays();
            %gras.ellapx.smartdb.test.examples.example_fromEllArray();
            %gras.ellapx.smartdb.test.examples.example_fromEllMArray();
            gras.ellapx.smartdb.test.examples.example_fromQMScaledArrays();
            gras.ellapx.smartdb.test.examples.example_project();
            gras.ellapx.smartdb.test.examples.example_projectToOrths();
            gras.ellapx.smartdb.test.examples.example_scale();
            gras.ellapx.smartdb.test.examples.example_interp();
            gras.ellapx.smartdb.test.examples.example_thinOutTuples();
            gras.ellapx.smartdb.test.examples.example_cut();
            gras.ellapx.smartdb.test.examples.example_fromEllTubes();
            gras.ellapx.smartdb.test.examples.example_projectStatic();
            gras.ellapx.smartdb.test.examples.example_isEqual();
        end
    end
end

