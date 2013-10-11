function result=run_tests_by_factory(className, varargin)

    if (strcmp(className, 'GenEllipsoid')) || (strcmp(className, 'ellipsoid'))
        import elltool.core.test.EllFactory;
                runner = mlunitext.text_test_runner(1, 1);
                testCaseList = {'EllipsoidIntUnionTC'...
                    'EllipsoidTestCase',...
                    'EllipsoidSecTestCase',...
                    'HyperplaneTestCase',...
                    'ElliIntUnionTCMultiDim',...                    
                    'EllSecTCMultiDim',...
                    'MPTIntegrationTestCase',...
                    'EllipsoidPlotTestCase',...
                    'EllAuxTestCase',...
                    'HyperplanePlotTestCase',...
                    'EllipsoidMinkPlotTestCase',...
                    'EllipsoidBasicSecondTC'};%,...
                     %'EllipsoidDispStructTC'
                    %};%'EllTCMultiDim',...
        
                testCaseList = strcat('elltool.core.test.mlunit.',testCaseList);
                suite = mlunitext.test_suite.fromTestCaseNameList(testCaseList,{EllFactory(className)});
                result = runner.run(suite);
    else
        'Wrong name of class for EllFactory';
    end
