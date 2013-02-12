function results = run_continious_reach_tests()
%
runner = mlunit.text_test_runner(1, 1);
loader = mlunitext.test_loader;
%
crm=gras.ellapx.uncertcalc.test.regr.conf.ConfRepoMgr();
crmSys=gras.ellapx.uncertcalc.test.regr.conf.sysdef.ConfRepoMgr();
%
confNameList = {'demo3firstTest', 'demo3secondTest',...
    'demo3thirdTest', 'demo3fourthTest'};
%
nConfs=length(confNameList);
suiteList=cell(1,4*nConfs-1);
%
for iConf=1:1:nConfs
    suiteList{iConf}=loader.load_tests_from_test_case(...
        'elltool.reach.test.mlunit.ContinuousReachReachabilityTestCase',...
        confNameList{iConf}, crm, crmSys);
end
%
for iConf=nConfs:-1:2
    reachObjFact = elltool.reach.test.mlunit.ReachFactory(...
        confNameList{iConf}, crm, crmSys, false, false);
    backReachObjFact = elltool.reach.test.mlunit.ReachFactory(...
        confNameList{iConf}, crm, crmSys, true, false);
    evolveReachObjFact = elltool.reach.test.mlunit.ReachFactory(...
        confNameList{iConf}, crm, crmSys, false, true);
    suiteList{3*(iConf-1)+4}=loader.load_tests_from_test_case(...
        'elltool.reach.test.mlunit.ContiniousReachTestCase',...
        reachObjFact);
    suiteList{3*(iConf-1)-1+4}=loader.load_tests_from_test_case(...
        'elltool.reach.test.mlunit.ContiniousReachTestCase',...
        backReachObjFact);
    suiteList{3*(iConf-1)-2+4}=loader.load_tests_from_test_case(...
        'elltool.reach.test.mlunit.ContiniousReachTestCase',...
        evolveReachObjFact);
end
reachObjFact = elltool.reach.test.mlunit.ReachFactory(...
    'demo3firstTest', crm, crmSys, false, false);
evolveReachObjFact = elltool.reach.test.mlunit.ReachFactory(...
    'demo3firstTest', crm, crmSys, false, true);
suiteList{3*(nConfs-1)+1+4}=loader.load_tests_from_test_case(...
    'elltool.reach.test.mlunit.ContiniousReachTestCase', reachObjFact);
suiteList{3*(nConfs-1)+2+4}=loader.load_tests_from_test_case(...
    'elltool.reach.test.mlunit.ContiniousReachTestCase', evolveReachObjFact);
%
testLists=cellfun(@(x)x.tests,suiteList,'UniformOutput',false);
suite=mlunitext.test_suite(horzcat(testLists{:}));
results=runner.run(suite);
end