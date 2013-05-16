function results=run_tests()
import modgen.containers.*;
import modgen.containers.test.*;
%
runner = mlunitext.text_test_runner(1, 1);
loader = mlunitext.test_loader;
suite = loader.load_tests_from_test_case(...
    'modgen.xml.test.mlunit_test_xmlloadsave');
%
suite_nots = loader.load_tests_from_test_case(...
    'modgen.xml.test.mlunit_test_xmlloadsave','insertTimestamp',false);
%
suite_forceatt = loader.load_tests_from_test_case(...
    'modgen.xml.test.mlunit_test_xmlloadsave','forceon');
%
suite = mlunitext.test_suite(horzcat(...
    suite.tests,...
    suite_nots.tests,...
    suite_forceatt.tests));
%
results=runner.run(suite);