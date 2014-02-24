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
            gras.ellapx.smartdb.test.examples.example_fromQArrays1();
            gras.ellapx.smartdb.test.examples.example_fromQArrays2();
            gras.ellapx.smartdb.test.examples.example_fromQMArrays1();
            gras.ellapx.smartdb.test.examples.example_fromQMArrays2();
            gras.ellapx.smartdb.test.examples.example_fromEllArray();
            gras.ellapx.smartdb.test.examples.example_fromEllMArray();
            gras.ellapx.smartdb.test.examples.example_fromQMScaledArrays1();
            gras.ellapx.smartdb.test.examples.example_fromQMScaledArrays2();
            gras.ellapx.smartdb.test.examples.example_project();
            gras.ellapx.smartdb.test.examples.example_projectToOrths1();
            gras.ellapx.smartdb.test.examples.example_projectToOrths2();
            gras.ellapx.smartdb.test.examples.example_scale();
            gras.ellapx.smartdb.test.examples.example_interp();
            gras.ellapx.smartdb.test.examples.example_thinOutTuples();
            gras.ellapx.smartdb.test.examples.example_cut1();
            gras.ellapx.smartdb.test.examples.example_cut2();
            gras.ellapx.smartdb.test.examples.example_fromEllTubes();
            gras.ellapx.smartdb.test.examples.example_projectStatic();
            gras.ellapx.smartdb.test.examples.example_isEqual1();
            gras.ellapx.smartdb.test.examples.example_isEqual2();
        end
    end
end

