function results = run_control_tests(varargin)


import elltool.reach.ReachFactory;
%
runner = mlunitext.text_test_runner(1, 1);
loader = mlunitext.test_loader;
%
crm=gras.ellapx.uncertcalc.test.regr.conf.ConfRepoMgr();
crmSys=gras.ellapx.uncertcalc.test.regr.conf.sysdef.ConfRepoMgr();
%
confCMat = {
%     'check', [1 0]; %0 1 1 1 0 0 1 0 0 0 0 1];
    'testnull', [0 0]; %0 1 1 1 0 0 1 0 0 0 0 1];
    'testA0Cunitball', [0 0]; %0 1 1 1 0 0 1 0 0 0 0 1];
    'testA0UInterval', [0 0]; %0 1 1 1 0 0 1 0 0 0 0 1];
    'rot2d', [1 0]; %0 1 1 1 0 0 1 0 0 0 0 1];
    'demo3firstTest',  [0 0]; %1 0 1 0 1 0 1 1 0 1 1 0];
    'demo3secondTest', [0 0]; %0 0 0 0 0 0 1 0 0 0 0 0];
    'demo3thirdTest',  [0 0]; %0 0 0 1 0 1 1 0 0 0 0 0];
    'demo3fourthTest', [0 0]; %0 1 1 1 0 0 1 0 0 0 0 1];
    'check', [0 0];
   % 'test2dbad',       [0 0 0 0 0 0 0 0 0 0 1 0 0 0]...
    };
%
nConfs = size(confCMat, 1);
suiteList = {};
% 
for iConf = 1:nConfs
    confName = confCMat{iConf, 1};
    confTestsVec = confCMat{iConf, 2};
    if confTestsVec(1)
        suiteList{end + 1} = loader.load_tests_from_test_case(...
            'elltool.control.test.mlunit.ReachContTC',...
            ReachFactory(confName, crm, crmSys, true, false),...
            'marker',[confName,'_IsBackTrueIsEvolveFalse']);
    end 
%     if confTestsVec(1)
%         suiteList{end + 1} = loader.load_tests_from_test_case(...
%             'elltool.control.test.mlunit.ReachContTC',...
%             ReachFactory(confName, crm, crmSys, true, true),...
%             'marker',[confName,'_IsBackTrueIsEvolveTrue']);
%     end
    
    
    
    
    
end
suiteList{end + 1} = loader.load_tests_from_test_case(...
    'elltool.reach.test.mlunit.MPTIntegrationTestCase');
%%
testLists = cellfun(@(x)x.tests,suiteList,'UniformOutput',false);
testList=horzcat(testLists{:});
suite = mlunitext.test_suite(testList);
suite=suite.getCopyFiltered(varargin{:});
results = runner.run(suite);