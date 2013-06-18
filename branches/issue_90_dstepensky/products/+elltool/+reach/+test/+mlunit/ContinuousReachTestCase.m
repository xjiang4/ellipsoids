classdef ContinuousReachTestCase < mlunitext.test_case
    properties (Access=private, Constant)
        FIELDS_NOT_TO_COMPARE={'LT_GOOD_DIR_MAT';'LT_GOOD_DIR_NORM_VEC';...
            'LS_GOOD_DIR_NORM';'LS_GOOD_DIR_VEC';'IND_S_TIME';'S_TIME'};
        COMP_PRECISION = 5e-3;
        REL_TOL = 1e-5;
    end
    properties (Access=private)
        testDataRootDir
        linSys
        reachObj
        tVec
        x0Ell
        l0Mat
        expDim
        reachFactoryObj
    end
    methods (Access=private, Static)
        function verticesCVec =...
                getVerticesFromHMap(axesHMap, specStr)
            axesHMapKeysCVec = axesHMap.keys;
            if strcmp(specStr, 'Ellipsoidal tubes')
                findStr = 'Reach Tube';
            else
                findStr = 'Good directions curve';
            end
            isIndAxesVec =...
                ~cellfun(@isempty, strfind(axesHMapKeysCVec, specStr));
            objectHandlesVec = axesHMap(axesHMapKeysCVec{isIndAxesVec});
            %
            objectNamesCVec = get(objectHandlesVec, 'DisplayName');
            isIndObjectVec = ~cellfun(@isempty,...
                strfind(objectNamesCVec, findStr));
            object = objectHandlesVec(isIndObjectVec);
            %
            verticesCVec = get(object, 'Vertices');
        end
    end
    methods (Access=private)
        function plotApproxTest(self, reachObj, approxType)
            import gras.ellapx.enums.EApproxType;
            import modgen.common.throwerror;
            if approxType == EApproxType.External
                ellArray = reachObj.get_ea();
                dim = ellArray(1, 1).dimension;
                if ~reachObj.isprojection()
                    projReachObj = reachObj.projection(eye(dim, 2));
                else
                    projReachObj = reachObj.getCopy();
                end
                plotter = projReachObj.plot_ea();
                scaleFactor = reachObj.getEaScaleFactor();
            elseif approxType == EApproxType.Internal
                ellArray = reachObj.get_ia();
                dim = ellArray(1, 1).dimension;
                if ~reachObj.isprojection()
                    projReachObj = reachObj.projection(eye(dim, 2));
                else
                    projReachObj = reachObj.getCopy();
                end
                plotter = projReachObj.plot_ia();
                scaleFactor = reachObj.getIaScaleFactor();
            end
            [dirCVec timeVec] = reachObj.get_directions();
            goodDirCVec =...
                cellfun(@(x) x(:, 1), dirCVec.', 'UniformOutput', false);
            
            if dim > 2
                ellArray = ellArray.projection(eye(dim, 2));
                goodDirCVec = cellfun(@(x) x(1:2), goodDirCVec,...
                    'UniformOutput', false);
            end
            nGoodDirs = numel(goodDirCVec);
            %
            axesHMapList =...
                plotter.getPlotStructure.figToAxesToPlotHMap.values;
            nFigures = numel(axesHMapList);
            for iAxesHMap = 1 : nFigures
                axesHMap = axesHMapList{iAxesHMap};
                %
                rtVerticesVec = self.getVerticesFromHMap(axesHMap,...
                    'Ellipsoidal tubes');
                gdVerticesCVec = self.getVerticesFromHMap(axesHMap,...
                    'Good directions');
                %
                plottedGoodDirCVec = cellfun(@(x) x(1, 2 : 3).',...
                    gdVerticesCVec, 'UniformOutput', false);
                %
                normalizeCVecFunc =...
                    @(v)cellfun(@(x) x / realsqrt(sum(x.*x)),...
                    v, 'UniformOutput', false);
                goodDirCVec = normalizeCVecFunc(goodDirCVec);
                plottedGoodDirCVec = normalizeCVecFunc(plottedGoodDirCVec);
                plottedGoodDirIndex = 0;
                for iGoodDir = 1 : nGoodDirs
                    goodDir = goodDirCVec{iGoodDir};
                    for iPlottedGoodDir = 1 : numel(plottedGoodDirCVec)
                        plottedGoodDir =...
                            plottedGoodDirCVec{iPlottedGoodDir};
                        if max(abs(goodDir - plottedGoodDir)) < self.REL_TOL
                            plottedGoodDirIndex = iGoodDir;
                            break;
                        end
                    end
                end
                if plottedGoodDirIndex == 0
                    throwerror('wrongData', 'No good direction found.');
                end
                %
                reachTubeEllipsoids = ellArray(plottedGoodDirIndex, :);
                nTimePoints = numel(timeVec);
                %
                for iTimePoint = 1 : nTimePoints
                    ell = reachTubeEllipsoids(iTimePoint);
                    curT = timeVec(iTimePoint);
                    pointsMat =...
                        rtVerticesVec(rtVerticesVec(:, 1) == curT, 2 : 3);
                    pointsMat = pointsMat.';
                    [centerVec shapeMat] = parameters(ell);
                    centerPointsMat = pointsMat -...
                        repmat(centerVec, 1, size(pointsMat, 2));
                    sqrtScalProdVec = realsqrt(abs(dot(centerPointsMat,...
                        shapeMat\centerPointsMat) - 1));
                    mlunitext.assert_equals(...
                        max(sqrtScalProdVec) < self.COMP_PRECISION, true);
                end
            end
            plotter.closeAllFigures();
        end
        %
        function displayTest(self, reachObj, timeVec)
            rxDouble = '([\d.+\-e]+)';
            %
            resStr = evalc('reachObj.display()');
            % time interval
            tokens = regexp(resStr,...
                ['time interval \[' rxDouble ',\s' rxDouble '\]'],...
                'tokens');
            tLimsRead = str2double(tokens{1}.').';
            difference = abs(tLimsRead(:) - timeVec(:));
            mlunitext.assert_equals(...
                max(difference) < self.COMP_PRECISION, true);
            % time typez
            if isa(reachObj, 'elltool.reach.ReachContinuous')
                isOk = ~isempty(strfind(resStr, 'continuous-time'));
            else
                isOk = ~isempty(strfind(resStr, 'discrete-time'));
            end
            mlunitext.assert_equals(isOk, true);
            % dimension
            tokens = regexp(resStr,...
                ['linear system in R\^' rxDouble],...
                'tokens');
            dimRead = str2double(tokens{1}{1});
            mlunitext.assert_equals(dimRead, reachObj.dimension);
        end
        %
        function runPlotTest(self, approxType)
            self.plotApproxTest(self.reachObj, approxType);
            newTimeVec = [sum(self.tVec) / 2, self.tVec(2)];
            cutReachObj = self.reachObj.cut(newTimeVec);
            self.plotApproxTest(cutReachObj, approxType);
            projReachObj =...
                self.reachObj.projection(eye(self.reachObj.dimension(), 2));
            self.plotApproxTest(projReachObj, approxType);
        end
    end
    methods
        function self = ContinuousReachTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
            [~, className] = modgen.common.getcallernameext(1);
            shortClassName = mfilename('classname');
            self.testDataRootDir = [fileparts(which(className)),...
                filesep, 'TestData', filesep, shortClassName];
        end
        %
        function self = set_up_param(self, reachFactObj)
            self.reachFactoryObj=reachFactObj;
            self.reachObj = reachFactObj.createInstance();
            self.linSys = reachFactObj.getLinSys();
            self.expDim = reachFactObj.getDim();
            self.tVec = reachFactObj.getTVec();
            self.x0Ell = reachFactObj.getX0Ell();
            self.l0Mat = reachFactObj.getL0Mat();
        end
        %
        function self = testDisplay(self)
            self.displayTest(self.reachObj, self.tVec);
            newTimeVec = [sum(self.tVec)/2, self.tVec(2)];
            cutReachObj = self.reachObj.cut(newTimeVec);
            self.displayTest(cutReachObj, newTimeVec);
            projReachObj =...
                self.reachObj.projection(eye(self.reachObj.dimension(), 2));
            self.displayTest(projReachObj, self.tVec);
        end
        %
        function self = testPlotEa(self)
            import gras.ellapx.enums.EApproxType;
            self.runPlotTest(EApproxType.External);
            self.reachObj.plot_ea();
        end
        %
        function self = testPlotIa(self)
            import gras.ellapx.enums.EApproxType;
            self.runPlotTest(EApproxType.Internal);
            self.reachObj.plot_ia();
        end
        %
        function self = testDimension(self)
            newTimeVec = [sum(self.tVec) / 2, self.tVec(2)];
            cutReachObj = self.reachObj.cut(newTimeVec);
            cutDim = cutReachObj.dimension();
            projReachObj =...
                self.reachObj.projection(eye(self.reachObj.dimension(), 1));
            [rsDim ssDim] = projReachObj.dimension();
            isOk = (rsDim == self.expDim) && (ssDim == 1) &&...
                (cutDim == self.expDim);
            mlunitext.assert_equals(true, isOk);
        end
        %
        function self = testIsEmpty(self)
            emptyRs = feval(class(self.reachObj));
            newTimeVec = [sum(self.tVec)/2, self.tVec(2)];
            cutReachObj = self.reachObj.cut(newTimeVec);
            projReachObj =...
                self.reachObj.projection(eye(self.reachObj.dimension(), 1));
            mlunitext.assert_equals(true, emptyRs.isempty());
            mlunitext.assert_equals(false, self.reachObj.isempty());
            mlunitext.assert_equals(false, cutReachObj.isempty());
            mlunitext.assert_equals(false, projReachObj.isempty());
        end
        %
        function self = testEvolve(self)
            import gras.ellapx.smartdb.F;
            %
            timeVec = [self.tVec(1), sum(self.tVec)/2];
            newReachObj = feval(class(self.reachObj), ...
                self.linSys, self.x0Ell, self.l0Mat, timeVec);
            %
            indSTimeVec = newReachObj.getEllTubeRel().indSTime;
            mlunitext.assert_equals(true, all(indSTimeVec == 1));
            %
            evolveReachObj = newReachObj.evolve(self.tVec(2));
            indSTimeVec = evolveReachObj.getEllTubeRel().indSTime;
            mlunitext.assert_equals(true, all(indSTimeVec == 1));
            %
            isEqual = self.reachObj.isEqual(evolveReachObj);
            mlunitext.assert_equals(true, isEqual);
        end
        %
        function self = testGetSystem(self)
            isEqual = self.linSys.isEqual(self.reachObj.get_system());
            mlunitext.assert_equals(true, isEqual);
            projReachObj = self.reachObj.projection(...
                eye(self.reachObj.dimension(), 2));
            isEqual = self.linSys.isEqual(projReachObj.get_system());
            mlunitext.assert_equals(true, isEqual);
        end
        %
        function self = testCut(self)
            %
            cutReachObj = self.reachObj.cut(self.tVec(end));
            cutReachObj.dimension();
            cutReachObj = self.reachObj.cut(self.tVec(1));
            cutReachObj.dimension();
            %
            checkCut([sum(self.tVec)/2, self.tVec(2)]);
            % TODO: please investigate why this check fails:
            checkCut([self.tVec(1), self.tVec(end)]);
            checkCut([self.tVec(1), (self.tVec(1) + self.tVec(end))/2]);            
            %
            function checkCut(newTimeVec)
                import gras.ellapx.enums.EApproxType;    
                import gras.ellapx.smartdb.F;
                %
                NOT_COMPARED_FIELD_CODE_LIST=...
                    {'LT_GOOD_DIR_MAT','LS_GOOD_DIR_VEC',...
                        'LT_GOOD_DIR_NORM_VEC','LS_GOOD_DIR_NORM'};
                notComparedFieldList=...
                    F().getNameList(NOT_COMPARED_FIELD_CODE_LIST);
                %
                newTimeVec = [sum(self.tVec)/2, self.tVec(2)];
                cutReachObj = self.reachObj.cut(newTimeVec);
                check('get_ea',[false, true]);
                check('get_ia',[true, false]);
                %
                function check(fGetApx,isIntExtApxVec)
                    [apxEllMat,timeVec] = feval(fGetApx,cutReachObj);
                    nTuples = size(apxEllMat, 1);
                    if self.reachObj.isbackward()
                        isOk=all(cutReachObj.getEllTubeRel().indSTime==...
                            cellfun(@numel,cutReachObj.getEllTubeRel().timeVec));
                        mlunitext.assert(isOk);
                        timeDif = timeVec(end) - newTimeVec(1);
                    else
                        isOk=all(cutReachObj.indSTime==1);
                        mlunitext.assert(isOk);
                        timeDif = timeVec(1) - newTimeVec(1);
                    end
                    for iTuple = 1 : nTuples
                        directionsCVec = cutReachObj.get_directions();
                        if self.reachObj.isbackward()
                            x0ApxEll = apxEllMat(iTuple, end);
                            l0Vec = directionsCVec{iTuple}(:, end);
                        else
                            x0ApxEll = apxEllMat(iTuple, 1);
                            l0Vec = directionsCVec{iTuple}(:, 1);
                        end
                        l0Vec = l0Vec ./ norm(l0Vec);
                        newApxReachObj = feval(class(self.reachObj), ...
                            self.linSys, x0ApxEll, l0Vec, newTimeVec + timeDif);
                        [isApxEqual, repStr] = cutReachObj.getCopy(...
                            'isIntExtApxVec',isIntExtApxVec,...
                            'l0Mat',l0Vec).isEqual(...
                            newApxReachObj.getCopy(...
                            'isIntExtApxVec',isIntExtApxVec),...
                            'notComparedFieldList',notComparedFieldList);
                        %
                        mlunitext.assert_equals(true, isApxEqual,repStr);
                    end
                end
            end
        end
        %
        function self = testNegativeCut(self)
            projReachObj =...
                self.reachObj.projection(eye(self.reachObj.dimension(), 2));
            newTimeVec = [sum(self.tVec)/2, self.tVec(2)];
            self.runAndCheckError('projReachObj.cut(newTimeVec)',...
                'wrongInput');
        end
        %
        function self = testNegativePlot(self)
            dim = self.reachObj.dimension();
            if dim == 2
                projReachSet =...
                    self.reachObj.projection(eye(dim, 1));
            else
                projReachSet =...
                    self.reachObj.projection(eye(dim, 3));
            end
            self.runAndCheckError('projReachSet.plot_ea()', 'wrongInput');
            self.runAndCheckError('projReachSet.plot_ia()', 'wrongInput');
        end
        %
        function self = testGetCopy(self)
            copiedReachObj = self.reachObj.getCopy();
            isEqual = copiedReachObj.isEqual(self.reachObj);
            mlunitext.assert_equals(true, isEqual);
        end
        %
        %
        function self = testGetCopyAdvanced(self)
            initL0Mat=self.l0Mat;
            nDims=size(initL0Mat,1);
            nOrigDirs=size(initL0Mat,2);
            expL0Mat=[initL0Mat, initL0Mat-1, initL0Mat+1];
            expL0Mat=expL0Mat./...
                repmat(realsqrt(dot(expL0Mat,expL0Mat,1)),nDims,1);
            %
            reachObj=self.reachFactoryObj.createInstance('l0Mat',expL0Mat);
            checkApxFilter(reachObj,[true,false]);
            checkApxFilter(reachObj,[false,true]);
            %
            nOrigTuples=reachObj.getEllTubeRel().getNTuples();
            copyReachObj=reachObj.getCopy('isIntExtApxVec',[true,false]);
            nCopiedTuples=copyReachObj.getEllTubeRel().getNTuples();
            mlunitext.assert(nCopiedTuples==0.5*nOrigTuples);
            %
            [~,~,l0Mat]=reachObj.get_directions();
            %
            mlunitext.assert_equals(true, getIsEqual(expL0Mat,l0Mat));
            indSubDirVec=[1,nOrigDirs+1,2*nOrigDirs+1];
            l0SubMat=expL0Mat(:,indSubDirVec);
            %
            copiedReachObj = reachObj.getCopy('l0Mat',l0SubMat);
            expReachObj=self.reachFactoryObj.createInstance('l0Mat',l0SubMat);
            %
            [isEqual,reportStr] = copiedReachObj.isEqual(expReachObj);
            mlunitext.assert_equals(true, isEqual,reportStr);
            %
            copyIntReachObj=...
                expReachObj.getCopy('l0Mat',l0SubMat,...
                'isIntExtApxVec',[true,false]);
            copyExtReachObj=...
                expReachObj.getCopy('l0Mat',l0SubMat,...
                'isIntExtApxVec',[false,true]);
            %
            allTubeRel=copyIntReachObj.getEllTubeRel();
            allTubeRel.unionWith(copyExtReachObj.getEllTubeRel());
            [isEqual,reportStr]=allTubeRel.isEqual(...
                expReachObj.getEllTubeRel());
            mlunitext.assert(isEqual,reportStr);
            %
            function checkApxFilter(reachObj,isIntExptApxVec)
                nOrigTuples=reachObj.getEllTubeRel().getNTuples();
                copyReachObj=reachObj.getCopy('isIntExtApxVec',...
                    isIntExptApxVec);
                nCopiedTuples=copyReachObj.getEllTubeRel().getNTuples();
                mlunitext.assert(nCopiedTuples==0.5*nOrigTuples);
            end
            %
            function isPos=getIsEqual(leftDirMat,rightDirMat)
                CMP_TOL=1e-15;
                diffMat=sortrows(leftDirMat.')-sortrows(rightDirMat.');
                isPos=max(abs(diffMat(:)))<=CMP_TOL;
            end
        end
        %
        function self = testSortedTimeVec(self)
            ellTube = self.reachObj.getEllTubeRel();
            switchTimeVec = self.reachObj.getSwitchTimeVec();
            timeVec = ellTube.timeVec{1};
            if numel(switchTimeVec) == 1
                isOk = numel(timeVec) == 1;
                mlunitext.assert_equals(true, isOk);
            else
                isnOk = any(diff(switchTimeVec) <= 0);
                mlunitext.assert_equals(false, isnOk);
                isOk = switchTimeVec(1) <= timeVec(1) ||...
                    switchTimeVec(end) >= timeVec(end);
                mlunitext.assert_equals(true, isOk);
            end
        end
    end
end
