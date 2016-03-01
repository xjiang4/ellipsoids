# Introduction #

MLUNITEXT is a custom-made unit testing framework developed by Peter Gagarinov. At the moment in [r25](https://code.google.com/p/ellipsoids/source/detail?r=25) of trunk the framework is located in
https://ellipsoids.googlecode.com/svn/trunk/lib/mlunitext. It consists of the following packages.

  1. **mlunit** - contains the classes designed for a direct use by a developers. When writing your tests you should inherit from `mlunitext.test_case` class.
  1. **mlunit\_samples** - contain a sample test case for demo purposes. This should be the first place to look for a developer without any experience with MLUNITEXT.
  1. **mlunit\_test** - contains the tests for MLUNITEXT itself (yes, the testing framework also needs to be tested!!!). This is the second place where developer should look for the test case examples. To run all the tests type `mlunitext.test.run_tests()` from Matlab command line.


# Typical use case for MLUNITEXT #

  1. Inherit from mlunitext.test\_case and write you tests in the methods that start with **test**. Using **test** in front of your test methods is obligatory as **test** prefix tells MLUNITEXT that the method in question is a test method.
```
classdef BasicTestCase < mlunitext.test_case
    %
    properties (Access=private)
        someProperty
    end
    methods
        function self = BasicTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        %
        function set_up(self)
           self.someProperty=1;
        end
        %
        function tear_down(self)
           self.someProperty=0;
        end
        %
        function testAlwaysPass(self)
            mlunitext.assert_equals(self.someProperty,1);
        end
        %
        function testNull(self)
            mlunitext.assert_equals(0, sin(0));
        end
        %
        function testSinCos(self)
            mlunitext.assert_equals(cos(0), sin(pi/2));
        end
        function testFailed(self)
            mlunitext.assert_equals(1,0);
        end
        function testSin(self)
            mlunitext.assert_equals(sin(0), 0);
        end
    end
end
```
  1. When you move than one test case created, let's say `BasicTestCase` and `AdvancedTestCase` within `mymainpackage.mychildpackage.test.mlunit' the next step would be writing `run\_tests` function within `mymainpackage.mychildpackage.test` for these two test cases. The following code snippet shows how this can be done.
```
function result=run_tests(varargin)
runner = mlunitext.text_test_runner(1, 1);
loader = mlunitext.test_loader;
suiteBasic = loader.load_tests_from_test_case(...
'mymainpackage.mychildpackage.test.mlunit.BasicTestCase',varargin{:});
%
suiteAdvanced = loader.load_tests_from_test_case(...
'mymainpackage.mychildpackage.test.mlunit.AdvancedTestCase',varargin{:});
%
suite = mlunitext.test_suite(horzcat(...
    suiteBasic.tests,...
    suiteAdvanced.tests));
%
result=runner.run(suite);
```
> > Now you can just type `mymainpackage.mychildpackage.test.run_tests` to run the tests from both use cases.

# Writing negative tests #
A test that causes an exception in the called function/class is also a test aka negative test. `mlunitext.test_case` class has a method  `runAndCheckError` designed for negative testing. Let's consider an example where a call to class method `doSomethingBad1` causes an exception with 'wrongInput' identifier and to method `doSomethingBad1` causes exception 'wrongInput' or 'complexResult'. The test for this case can be written in the following way.
```
function testNegative(self)
obj=...
inpParamList={1,2};
self.runAndCheckError('obj.doSomethingBad1(inpParamList{:})','wrongInput');
errList = {'wrongInput','complexResult'};
self.runAndCheckError('obj.doSomethingBad2(inpParamList{:})',errList);
end
```
The same test can be written in a slightly different manner:
```
function testNegative(self)
obj=...
inpParamList={1,2};
self.runAndCheckError(@check,'wrongInput');
%
  function check()
     obj.doSomethingBad(inpParamList{:});
  end
end
```
# Structuring the tests into packages #
  1. Let's assume that you have a few additional test cases implemented within a different package `mymainpackage.mysecondpackage.test.mlunit` along with 'mymainpackage.mysecondpackage.test.run\_tests' function. Then you can (and actually should) create a higher-level `run_tests`  function in `mymainpackage.test` package that call the lower-level 'run\_test' functions (see the following code snippet)
```
function result=run_tests(varargin)
resList{2}=mymainpackage.mysecondpackage.test.run_tests();
resList{1}=mymainpackage.mychildpackage.test.run_tests();
%
result=[resList{:}];
```
> > The command 'mymainpackage.test.run\_tests` will run all the tests. Please note that 'mymainpackage.test.run_tests` returns results of ALL the tests in both packages.
  1. When you need to run tests from a specific use case (let's say  `mymainpackage.mychildpackage.test.mlunit.BasicTestCase`) directly you can use `mlunitext.runtestcase` function (see the following snippet).
```
mlunitext.runtestcase(...
'mymainpackage.mychildpackage.test.mlunit.BasicTestCase') % runs all tests from the test case
%
mlunitext.runtestcase(...
'mymainpackage.mychildpackage.test.mlunit.BasicTestCase','testSinCos') % runs only testSinCos test
%
mlunitext.runtestcase(...
'mymainpackage.mychildpackage.test.mlunit.BasicTestCase','testSin') % runs only testSinCos and testSin tests
%
mlunitext.runtestcase(...
'mymainpackage.mychildpackage.test.mlunit.BasicTestCase','testSin$') % runs only testSin test
```