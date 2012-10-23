function result=run_tests(varargin)
runner = mlunitext.text_test_runner(1, 1);
loader = mlunitext.test_loader;
suiteETC = loader.load_tests_from_test_case(...
'elltool.core.test.mlunit.EllipsoidTestCase',varargin{:});
suite = mlunit.test_suite(suiteETC.tests);
result=runner.run(suite);