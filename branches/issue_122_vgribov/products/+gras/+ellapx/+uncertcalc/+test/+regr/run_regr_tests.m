function results=run_regr_tests(confNameList)
runner = mlunitext.text_test_runner(1, 1);
loader = mlunitext.test_loader;
crm=gras.ellapx.uncertcalc.test.regr.conf.ConfRepoMgr();
if nargin>0
    if ischar(confNameList)
        confNameList={confNameList};
    end
end
%
if nargin==0
    confNameList=crm.deployConfTemplate('*');
end
%confNameList = {'advanced'};
%
notToTestConfNameList = {'discrSecondTest'};
testConfIndArray = ones(1, length(confNameList));
for confName = notToTestConfNameList{:}
    testConfIndArray = testConfIndArray & ...
        ~ismember(confNameList, 'discrSecondTest');
end
confNameList = confNameList(testConfIndArray);
%
crmSys=gras.ellapx.uncertcalc.test.regr.conf.sysdef.ConfRepoMgr();
crmSys.deployConfTemplate('*');
nConfs=length(confNameList);
suiteList=cell(1,nConfs);
for iConf=nConfs:-1:1
    confName=confNameList{iConf};
    suiteList{iConf}=loader.load_tests_from_test_case(...
        'gras.ellapx.uncertcalc.test.regr.mlunit.SuiteRegression',{confName},...
        crm,crmSys,'marker',confName);
end
testLists=cellfun(@(x)x.tests,suiteList,'UniformOutput',false);
suite=mlunitext.test_suite(horzcat(testLists{:}));
%
results=runner.run(suite);