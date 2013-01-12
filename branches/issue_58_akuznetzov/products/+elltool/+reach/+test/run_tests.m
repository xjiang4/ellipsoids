function result = run_tests(varargin)
    runner = mlunitext.text_test_runner(1, 1);
    loader = mlunitext.test_loader;
    suiteBasic =...
        loader.load_tests_from_test_case(...
        'elltool.reach.test.mlunit.ReachTestCase', varargin{:});
    %
    suiteDiscrete = ...
        loader.load_tests_from_test_case(...
        'elltool.reach.test.mlunit.ReachDiscrTestCase', varargin{:});
    
    suite = mlunit.test_suite(horzcat(...
        suiteBasic.tests,...
        suiteDiscrete.tests));
    %
result = runner.run(suite);