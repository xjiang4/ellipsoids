function results = run_discrete_reach_tests(varargin)
import elltool.reach.ReachFactory;
%
runner = mlunitext.text_test_runner(1, 1);
loader = mlunitext.test_loader;
%
crm = gras.ellapx.uncertcalc.test.regr.conf.ConfRepoMgr();
crmSys = gras.ellapx.uncertcalc.test.regr.conf.sysdef.ConfRepoMgr();
%
confList = {
    'discrFirstTest',  [1 1 1 1];
    'discrSecondTest',  [1 1 1 0];
    };
%
nConfs = size(confList, 1);
suiteList = {};
%
for iConf = 1:nConfs
    confName = confList{iConf, 1};
    confTestsVec = confList{iConf, 2};
    if confTestsVec(1)
        suiteList{end + 1} = loader.load_tests_from_test_case(...
            'elltool.reach.test.mlunit.DiscreteReachTestCase', ...
            ReachFactory(confName, crm, crmSys, false, false, true), ...
            'marker', [confName,'_IsBackFalseIsEvolveFalse']);
        suiteList{end + 1} = loader.load_tests_from_test_case(...
            'elltool.reach.test.mlunit.DiscreteReachTestCase', ...
            ReachFactory(confName, crm, crmSys, true, false, true), ...
            'marker', [confName,'_IsBackTrueIsEvolveFalse']);
    end
    if confTestsVec(2)
        suiteList{end + 1} = loader.load_tests_from_test_case(...
            'elltool.reach.test.mlunit.ContinuousReachTestCase', ...
            ReachFactory(confName, crm, crmSys, false, false, true), ...
            'marker', [confName,'_IsBackFalseIsEvolveFalse']);
        suiteList{end + 1} = loader.load_tests_from_test_case(...
            'elltool.reach.test.mlunit.ContinuousReachTestCase', ...
            ReachFactory(confName, crm, crmSys, true, false, true), ...
            'marker', [confName,'_IsBackTrueIsEvolveFalse']);
        suiteList{end + 1} = loader.load_tests_from_test_case(...
            'elltool.reach.test.mlunit.ContinuousReachTestCase', ...
            ReachFactory(confName, crm, crmSys, false, true, true), ...
            'marker', [confName,'_IsBackFalseIsEvolveTrue']);
        suiteList{end + 1} = loader.load_tests_from_test_case(...
            'elltool.reach.test.mlunit.ContinuousReachTestCase', ...
            ReachFactory(confName, crm, crmSys, true, true, true), ...
            'marker', [confName,'_IsBackTrueIsEvolveTrue']);
    end
    if confTestsVec(3)
        suiteList{end + 1} = loader.load_tests_from_test_case(...
            'elltool.reach.test.mlunit.DiscreteReachProjTestCase', ...
            confName, crm, crmSys, 'marker', confName);
    end
    if confTestsVec(4)
        suiteList{end + 1} = loader.load_tests_from_test_case(...
            'elltool.reach.test.mlunit.ContinuousReachRefineTestCase',...
            ReachFactory(confName, crm, crmSys, false, false),...
            'marker',confName);
    end
end
%
testLists = cellfun(@(x)x.tests,suiteList,'UniformOutput',false);
suite = mlunitext.test_suite(horzcat(testLists{:}));
%
resList{1} = runner.run(suite);
testCaseNameStr = 'elltool.reach.test.mlunit.DiscreteReachProjAdvTestCase';
resList{2} = elltool.reach.test.run_reach_proj_adv_tests(testCaseNameStr);
results = [resList{:}];

end