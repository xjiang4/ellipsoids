classdef ContiniousReachTestCase < mlunitext.test_case
    properties (Access=private)
        testDataRootDir
        etalonDataRootDir
        etalonDataBranchKey
        confName
        crm
        crmSys
        linSys
        reachObj
        tLims
        calcPrecision
    end
    methods
        function self = ContiniousReachTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
            [~, className] = modgen.common.getcallernameext(1);
            shortClassName = mfilename('classname');
            self.testDataRootDir = [fileparts(which(className)),...
                filesep, 'TestData', filesep, shortClassName];
            % obtain the path of etalon data
            regrClassName =...
                'gras.ellapx.uncertcalc.test.regr.mlunit.SuiteRegression';
            shortRegrClassName = 'SuiteRegression';
            self.etalonDataRootDir = [fileparts(which(regrClassName)),...
                filesep, 'TestData', filesep, shortRegrClassName];
            self.etalonDataBranchKey = 'testRegression_out';
        end
        %
        function self = set_up_param(self, confName, crm, crmSys)
            self.crm = crm;
            self.crmSys = crmSys;
            self.confName = confName;
            %
            self.crm.deployConfTemplate(self.confName);
            self.crm.selectConf(self.confName);
            sysDefConfName = self.crm.getParam('systemDefinitionConfName');
            self.crmSys.selectConf(sysDefConfName, 'reloadIfSelected', false);
            %
            atDefCMat = self.crmSys.getParam('At');
            btDefCMat = self.crmSys.getParam('Bt');
            ctDefCMat = self.crmSys.getParam('Ct');
            ptDefCMat = self.crmSys.getParam('control_restriction.Q');
            ptDefCVec = self.crmSys.getParam('control_restriction.a');
            qtDefCMat = self.crmSys.getParam('disturbance_restriction.Q');
            qtDefCVec = self.crmSys.getParam('disturbance_restriction.a');
            x0DefMat = self.crmSys.getParam('initial_set.Q');
            x0DefVec = self.crmSys.getParam('initial_set.a');
            l0CMat = self.crm.getParam(...
                'goodDirSelection.methodProps.manual.lsGoodDirSets.set1');
            l0Mat = cell2mat(l0CMat.').';
            self.tLims = [self.crmSys.getParam('time_interval.t0'),...
                self.crmSys.getParam('time_interval.t1')];
            self.calcPrecision =...
                self.crm.getParam('genericProps.calcPrecision');
            ControlBounds = struct();
            ControlBounds.center = ptDefCVec;
            ControlBounds.shape = ptDefCMat;
            DistBounds = struct();
            DistBounds.center = qtDefCVec;
            DistBounds.shape = qtDefCMat;
            %
            self.linSys = elltool.linsys.LinSys(atDefCMat, btDefCMat,...
                ControlBounds, ctDefCMat, DistBounds);
            self.reachObj = elltool.reach.ReachContinious(self.linSys,...
                ellipsoid(x0DefVec, x0DefMat), l0Mat, self.tLims);
        end
        %
        function self = testSystem(self)
            import modgen.common.throwerror;
            import elltool.reach.test.mlunit.ContiniousReachTestCase;
            %
            COMPARED_FIELD_LIST = {'ellTubeRel'};
            MAX_TOL=5e-5;
            SSORT_KEYS.ellTubeRel = {'approxSchemaName', 'lsGoodDirVec'};
            ROUND_FIELD_LIST = {'lsGoodDirOrigVec', 'lsGoodDirVec'};
            nRoundDigits = -fix(log(MAX_TOL) / log(10));
            %
            resMap = modgen.containers.ondisk.HashMapMatXML(...
                'storageLocationRoot', self.etalonDataRootDir,...
                'storageBranchKey', self.etalonDataBranchKey,...
                'storageFormat', 'mat', 'useHashedPath', false,...
                'useHashedKeys', true);
            %
            SRunProp = struct();
            SRunProp.ellTubeRel = self.reachObj.getEllTubeRel();
            %
            isOk = all(SRunProp.ellTubeRel.calcPrecision <=...
                self.calcPrecision);
            mlunit.assert_equals(true, isOk);
            %
            SRunProp=pathfilterstruct(SRunProp, COMPARED_FIELD_LIST);
            if resMap.isKey(self.confName);
                SExpRes = resMap.get(self.confName);
                nCmpFields = numel(COMPARED_FIELD_LIST);
                for iField = 1 : nCmpFields
                    fieldName = COMPARED_FIELD_LIST{iField};
                    expRel = SExpRes.(fieldName);
                    rel = SRunProp.(fieldName);
                    %
                    keyList = SSORT_KEYS.(fieldName);
                    isRoundVec = ismember(keyList, ROUND_FIELD_LIST);
                    roundKeyList = keyList(isRoundVec);
                    nRoundKeys = length(roundKeyList);
                    %
                    for iRound = 1 : nRoundKeys
                        roundKey = roundKeyList{iRound};
                        rel.applySetFunc(@(x) roundn(x, -nRoundDigits),...
                            roundKey);
                        expRel.applySetFunc(@(x) roundn(x, -nRoundDigits),...
                            roundKey);
                    end
                    rel.sortBy(SSORT_KEYS.(fieldName));
                    expRel.sortBy(SSORT_KEYS.(fieldName));
                   
                    [isOk, reportStr] = expRel.isEqual(rel, 'maxTolerance',...
                        MAX_TOL, 'checkTupleOrder', true);
                    %
                    reportStr = sprintf('confName=%s\n %s', self.confName,...
                        reportStr);
                    mlunit.assert_equals(true, isOk, reportStr);
                end
            else
                throwerror('Do not exist config mat file.');
            end
        end
        %
        function self = testDisplay(self)
            rxDouble = '([\d.+\-e]+)';
            %
            resStr = evalc('self.reachObj.display');
            % time interval
            tokens = regexp(resStr,...
                ['time interval \[' rxDouble ',\s' rxDouble '\]'],...
                'tokens');
            tLimsRead = str2double(tokens{1}.').';
            difference = abs(tLimsRead(:) - self.tLims(:));
            mlunit.assert_equals(max(difference) < self.calcPrecision, true);
            % continuous-time
            isOk = ~isempty(strfind(resStr, 'continuous-time'));
            mlunit.assert_equals(isOk, true);
            % dimension
            tokens = regexp(resStr,...
                ['linear system in R\^' rxDouble],...
                'tokens');
            dimRead = str2double(tokens{1}{1});
            mlunit.assert_equals(dimRead, self.linSys.dimension());
        end
        %
        function self = testPlotEa(self)
            %
            ellArray = self.reachObj.get_ea;
            ellTubes = self.reachObj.getEllTubeRel.getTuplesFilteredBy(...
                'approxType', gras.ellapx.enums.EApproxType.External);
            goodDirCVec = ellTubes.lsGoodDirVec;
            nGoodDirs = numel(goodDirCVec);
            %
            plotter = self.reachObj.plot_ea;
            plotter.closeAllFigures();
            %
            axesHMapList =...
                plotter.getPlotStructure.figToAxesToPlotHMap.values;
            nFigures = numel(axesHMapList);
            for iAxesHMap = 1 : nFigures
                axesHMap = axesHMapList{iAxesHMap};
                axesHMapKeys = axesHMap.keys;
                %
                indReachTubeAxes = ~cellfun(@isempty,...
                    strfind(axesHMapKeys, 'Ellipsoidal tubes'));
                indGoodDirsAxes = ~cellfun(@isempty,...
                    strfind(axesHMapKeys, 'Good directions'));
                %
                rtObjectHandles = axesHMap(axesHMapKeys{indReachTubeAxes});
                gdObjectHandles = axesHMap(axesHMapKeys{indGoodDirsAxes});
                %
                rtObjectNames = get(rtObjectHandles, 'DisplayName');
                gdObjectNames = get(gdObjectHandles, 'DisplayName');
                indRtObject = ~cellfun(@isempty,...
                    strfind(rtObjectNames, 'Reach Tube'));
                indGdObjects = ~cellfun(@isempty,...
                    strfind(gdObjectNames, 'Good directions curve'));
                rtObject = rtObjectHandles(indRtObject);
                gdObjects = gdObjectHandles(indGdObjects);
                %
                rtVertices = get(rtObject, 'Vertices');
                gdVerticesCVec = get(gdObjects, 'Vertices');
                %
                plottedGoodDirCVec = cellfun(@(x) x(1, 2 : 3).',...
                    gdVerticesCVec, 'UniformOutput', false);
                %
                plottedGoodDirIndex = 0;
                for iGoodDir = 1 : nGoodDirs
                    goodDir = goodDirCVec{iGoodDir};
                    for iPlottedGoodDir = 1 : numel(plottedGoodDirCVec)
                        plottedGoodDir =...
                            plottedGoodDirCVec{iPlottedGoodDir};
                        if all(goodDir == plottedGoodDir)
                            plottedGoodDirIndex = iGoodDir;
                            break;
                        end
                    end
                end
                if plottedGoodDirIndex == 0
                   throwerror('No good direction found.');
                end
                %
                reachTubeEllipsoids = ellArray(plottedGoodDirIndex, :);
                timeVec = ellTubes.timeVec{plottedGoodDirIndex, :};
                nTimePoints = numel(timeVec);
                %
                for iTimePoint = 1 : nTimePoints
                    ell = reachTubeEllipsoids(iTimePoint);
                    curT = timeVec(iTimePoint);
                    pointsMat = rtVertices(rtVertices(:, 1) == curT, 2 : 3);
                    pointsMat =...
                        pointsMat.' / self.reachObj.getEaScaleFactor;
                    [centerVec shapeMat] = parameters(ell);
                    centerPointsMat = pointsMat -...
                        repmat(centerVec, 1, size(pointsMat, 2));
                    sqrtScalProdVec = sqrt(abs(dot(centerPointsMat,...
                        shapeMat\centerPointsMat) - 1));
                    mlunit.assert_equals(...
                        max(sqrtScalProdVec) < self.calcPrecision, true);
                end
            end
        end
        %
        function self = testPlotIa(self)
            %
            ellArray = self.reachObj.get_ia;
            ellTubes = self.reachObj.getEllTubeRel.getTuplesFilteredBy(...
                'approxType', gras.ellapx.enums.EApproxType.Internal);
            goodDirCVec = ellTubes.lsGoodDirVec;
            nGoodDirs = numel(goodDirCVec);
            %
            plotter = self.reachObj.plot_ia;
            plotter.closeAllFigures();
            %
            axesHMapList =...
                plotter.getPlotStructure.figToAxesToPlotHMap.values;
            nFigures = numel(axesHMapList);
            for iAxesHMap = 1 : nFigures
                axesHMap = axesHMapList{iAxesHMap};
                axesHMapKeys = axesHMap.keys;
                %
                indReachTubeAxes = ~cellfun(@isempty,...
                    strfind(axesHMapKeys, 'Ellipsoidal tubes'));
                indGoodDirsAxes = ~cellfun(@isempty,...
                    strfind(axesHMapKeys, 'Good directions'));
                %
                rtObjectHandles = axesHMap(axesHMapKeys{indReachTubeAxes});
                gdObjectHandles = axesHMap(axesHMapKeys{indGoodDirsAxes});
                %
                rtObjectNames = get(rtObjectHandles, 'DisplayName');
                gdObjectNames = get(gdObjectHandles, 'DisplayName');
                indRtObject = ~cellfun(@isempty,...
                    strfind(rtObjectNames, 'Reach Tube'));
                indGdObjects = ~cellfun(@isempty,...
                    strfind(gdObjectNames, 'Good directions curve'));
                rtObject = rtObjectHandles(indRtObject);
                gdObjects = gdObjectHandles(indGdObjects);
                %
                rtVertices = get(rtObject, 'Vertices');
                gdVerticesCVec = get(gdObjects, 'Vertices');
                %
                plottedGoodDirCVec = cellfun(@(x) x(1, 2 : 3).',...
                    gdVerticesCVec, 'UniformOutput', false);
                %
                plottedGoodDirIndex = 0;
                for iGoodDir = 1 : nGoodDirs
                    goodDir = goodDirCVec{iGoodDir};
                    for iPlottedGoodDir = 1 : numel(plottedGoodDirCVec)
                        plottedGoodDir =...
                            plottedGoodDirCVec{iPlottedGoodDir};
                        if all(goodDir == plottedGoodDir)
                            plottedGoodDirIndex = iGoodDir;
                            break;
                        end
                    end
                end
                if plottedGoodDirIndex == 0
                   throwerror('No good direction found.');
                end
                %
                reachTubeEllipsoids = ellArray(plottedGoodDirIndex, :);
                timeVec = ellTubes.timeVec{plottedGoodDirIndex, :};
                nTimePoints = numel(timeVec);
                %
                for iTimePoint = 1 : nTimePoints
                    ell = reachTubeEllipsoids(iTimePoint);
                    curT = timeVec(iTimePoint);
                    pointsMat = rtVertices(rtVertices(:, 1) == curT, 2 : 3);
                    pointsMat =...
                        pointsMat.' / self.reachObj.getIaScaleFactor;
                    [centerVec shapeMat] = parameters(ell);
                    centerPointsMat = pointsMat -...
                        repmat(centerVec, 1, size(pointsMat, 2));
                    sqrtScalProdVec = sqrt(abs(dot(centerPointsMat,...
                        shapeMat\centerPointsMat) - 1));
                    mlunit.assert_equals(...
                        max(sqrtScalProdVec) < self.calcPrecision, true);
                end
            end
        end
        %
        function self = testDimension(self)
            expDim = self.crmSys.getParam('dim');
            projReachSet = self.reachObj.projection(eye(expDim, 1));
            [rsDim ssDim] = projReachSet.dimension();
            isOk = (rsDim == expDim) && (ssDim == 1);
            mlunit.assert_equals(true, isOk);
        end
        %
        function self = testIsEmpty(self)
            emptyRs = elltool.reach.ReachContinious();
            mlunit.assert_equals(true, emptyRs.isempty);
            mlunit.assert_equals(false, self.reachObj.isempty);
        end
    end
end