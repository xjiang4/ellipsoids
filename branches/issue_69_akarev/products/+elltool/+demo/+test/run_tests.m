function result=run_tests(varargin)
runner = mlunitext.text_test_runner(1, 1);
loader = mlunitext.test_loader;
suite = loader.load_tests_from_test_case(...
    'elltool.demo.test.mlunit.BasicTestCase');
result=runner.run(suite);