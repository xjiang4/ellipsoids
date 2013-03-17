function results = run_discrete_reach_tests(varargin)
    runner = mlunitext.text_test_runner(1, 1);
    loader = mlunitext.test_loader;
    
    testFileNameList = {'test1', 'test2', 'test3', 'test4'};
    nTest = length(testFileNameList);
    suiteList = cell(1, nTest);
    
    for iTest = 1:nTest
        suiteList{iTest} = ...
            loader.load_tests_from_test_case(...
            'elltool.reach.test.mlunit.DiscreteReachTestCase', ...
            testFileNameList{iTest});
    end
    
    testLists = cellfun(@(x)x.tests,suiteList,'UniformOutput',false);
    suite = mlunitext.test_suite(horzcat(testLists{:}));
    results = runner.run(suite);
end