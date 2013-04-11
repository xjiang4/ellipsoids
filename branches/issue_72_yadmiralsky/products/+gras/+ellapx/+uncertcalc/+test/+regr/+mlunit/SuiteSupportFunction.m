classdef SuiteSupportFunction < mlunitext.test_case
% $Author: Kirill Mayantsev  <kirill.mayantsev@gmail.com> $  $Date: 2-11-2012 $
% $Copyright: Moscow State University,
%             Faculty of Computational Mathematics and Computer Science,
%             System Analysis Department 2012 $
    properties (Access=private)
        testDataRootDir
        confNameList
        crm
        crmSys
    end
    properties (Constant, GetAccess = private)
        REL_TOL_FACTOR = 1e-3;
        ABS_TOL_FACTOR = 1e-3;
    end
    methods (Static)
        function difVec = derivativeSupportFunction(t, ~, fxVec, fAMat,...
                fBMat, fPVec, fPMat, nElem)
            difVec =...
                (fxVec(t).') * fBMat(t) * fPVec(t) +...
                sqrt((fxVec(t).') * fBMat(t) * fPMat(t) * (fBMat(t).') ...
                * fxVec(t));
        end
        %
        function fMatCalc = getHandleFromCellMat(inputCMat)
            localCMat = inputCMat;
            [nRows, nColumn] = size(localCMat);
            for iRow = 1 : nRows
                for jColumn = 1 : nColumn
                    if jColumn == nColumn
                        localCMat(iRow, jColumn) =...
                            strcat(localCMat(iRow, jColumn), ';');
                    else
                        localCMat(iRow, jColumn) =...
                            strcat(localCMat(iRow, jColumn), ',');
                    end
                end
            end
            localCMat = localCMat.';
            helpStr = strcat('fRes = @(t) [', localCMat{:}, '];');
            eval(helpStr);
            fMatCalc = fRes;
        end
    end
    methods
        function self = SuiteSupportFunction(varargin)
            self = self@mlunitext.test_case(varargin{:});
            [~, className] = modgen.common.getcallernameext(1);
            shortClassName = mfilename('classname');
            self.testDataRootDir = [fileparts(which(className)),...
                filesep, 'TestData', filesep, shortClassName];
        end
        %
        function self = set_up_param(self, varargin)
            if nargin > 2
                self.crm = varargin{2};
            else
                self.crm =...
                    gras.ellapx.uncertcalc.test.regr.conf.ConfRepoMgr();
            end
            if nargin > 3
                self.crmSys = varargin{3};
            else
                self.crmSys =...
                    gras.ellapx.uncertcalc.test.regr.conf.sysdef.ConfRepoMgr();
            end
            confNameList = varargin{1};
            if strcmp(confNameList, '*')
                self.crm.deployConfTemplate('*');
                confNameList = self.crm.getConfNameList();
            end
            if ischar(confNameList)
                confNameList = {confNameList};
            end
            self.confNameList = confNameList;
        end
        %
        function testSupportCompare(self)
            crm = self.crm;
            crmSys = self.crmSys;
            confNameList = self.confNameList;
            nConfs = length(confNameList);
            for iConf = 1 : nConfs
                crm.deployConfTemplate(confNameList{iConf});
            end
            %
            for iConf = 1 : nConfs
                confName = confNameList{iConf};
                crm.selectConf(confName);
                crm.setParam('plottingProps.isEnabled',false,...
                    'writeDepth','cache');
                %
                SRunProp = gras.ellapx.uncertcalc.run(confName,...
                    'confRepoMgr', crm, 'sysConfRepoMgr', crmSys);
                %
                fGetScaleFactor = @(x)1/x;
                scaleFactorFieldList = {'scaleFactor'};
                SRunProp.ellTubeRel.scale(fGetScaleFactor,...
                    scaleFactorFieldList);
                %
                calcPrecision = crm.getParam('genericProps.calcPrecision');
                isOk = all(SRunProp.ellTubeProjRel.calcPrecision <=...
                    calcPrecision);
                mlunit.assert_equals(true,isOk);
                %
                AtCMat = self.crmSys.getParam('At');
                fAtMatCalc = self.getHandleFromCellMat(AtCMat);
                BtCMat = self.crmSys.getParam('Bt');
                fBtMatCalc = self.getHandleFromCellMat(BtCMat);
                PtCVec = self.crmSys.getParam('control_restriction.a');
                fPtVecCalc = self.getHandleFromCellMat(PtCVec);
                PtCMat = self.crmSys.getParam('control_restriction.Q');
                fPtMatCalc = self.getHandleFromCellMat(PtCMat);
                x0Vec = self.crmSys.getParam('initial_set.a');
                %
                timeCVec = SRunProp.ellTubeRel.timeVec;
                nTuples = SRunProp.ellTubeRel.getNTuples;
                %
                goodDirCMat = SRunProp.ellTubeRel.ltGoodDirMat;
                ellMatCArray = SRunProp.ellTubeRel.QArray;
                ellCenterCMat = SRunProp.ellTubeRel.aMat;
                %
                nElem = size(x0Vec, 1);
                OdeOptionsStruct = odeset(...
                    'RelTol', calcPrecision * self.REL_TOL_FACTOR,...
                    'AbsTol', calcPrecision * self.ABS_TOL_FACTOR);
                lsGoodDirMat = SRunProp.goodDirSetObj.getlsGoodDirMat();
                lsGoodDirCMat = SRunProp.ellTubeRel.lsGoodDirVec();
                for iTuple = 1 : nTuples
                    curTimeVec = timeCVec{iTuple};
                    curGoodDirMat = goodDirCMat{iTuple};
                    curEllMatArray = ellMatCArray{iTuple};
                    curEllCenterMat = ellCenterCMat{iTuple};
                    %
                    % good directions' indexes mapping
                    %
                    curGoodDirVec = lsGoodDirCMat{iTuple};
                    for iGoodDir = 1:size(lsGoodDirMat, 2)
                        isFound = norm(curGoodDirVec - ...
                            lsGoodDirMat(:, iGoodDir)) <= calcPrecision;
                        if isFound
                            break;
                        end
                    end
                    mlunit.assert_equals(true, isFound,...
                        'good dir vector not found');
                    %
                    curGoodDirDynamicsObj = ...
                        SRunProp.goodDirSetObj.getGoodDirOneCurveSpline(...
                        iGoodDir);
                    fCalcXMat = @(t) curGoodDirDynamicsObj.evaluate(t);
                    %
                    supFun0 =...
                        curGoodDirMat(:, 1).' * curEllCenterMat(:, 1) +...
                        sqrt(curGoodDirMat(:, 1).' *...
                        curEllMatArray(:, :, 1) * curGoodDirMat(:, 1));
                    %
                    [~, expResultMat] =...
                        ode45(@(t, x) self.derivativeSupportFunction(t,...
                        x, fCalcXMat, fAtMatCalc, fBtMatCalc, ...
                        fPtVecCalc, fPtMatCalc, nElem), curTimeVec,...
                        supFun0, OdeOptionsStruct);
                    %
                    supFunVec =...
                        sqrt(gras.gen.SquareMatVector.lrMultiplyByVec(...
                        curEllMatArray,curGoodDirMat)) +...
                        sum(curEllCenterMat .* curGoodDirMat, 1);
                    expNormResVec = expResultMat(:, end) ./...
                        norm(expResultMat(:, end));
                    normSupFunVec = supFunVec.' ./ norm(supFunVec);
                    errorSupFunMat =...
                        abs(expNormResVec - normSupFunVec);                    
                    errTol = max(errorSupFunMat(:));
                    isOk = errTol <= calcPrecision;
                    mlunit.assert_equals(true, isOk,...
                        sprintf('errTol=%g>calcPrecision=%g', errTol,...
                        calcPrecision));
                end
            end
        end
    end
end