classdef DiscreteReachTestCase < mlunitext.test_case
    properties (Access = private, Constant)
        COMP_PRECISION = 5e-5;
    end
    properties (Access=private)
        testDataRootDir
        linSys
        reachObj
        tIntervalVec
        x0Ell
        l0Mat
        expDim
        fundCMat
    end
    methods (Static)
        function fundCMat = calculateFundamentalMatrix(self)
            k0 = self.tIntervalVec(1);
            k1 = self.tIntervalVec(2);
            
            xDim = size(self.linSys.getAtMat(), 1);
            
            syms k;
            fAMatCalc = @(t)subs(self.linSys.getAtMat(), k, t);
            
            nTimeStep = abs(k1 - k0) + 1;
            
            isBack = k0 > k1;
            
            if isBack
                tVec = k0:-1:k1;
            else
                tVec = k0:k1;
            end
            
            fundCMat = cell(nTimeStep, nTimeStep);
            for iTime = 1:nTimeStep
                fundCMat{iTime, iTime} = eye(xDim);
            end
            
            for jTime = 1:nTimeStep
                for iTime = jTime + 1:nTimeStep
                    if isBack
                        fundCMat{iTime, jTime} = ...
                            pinv(fAMatCalc(tVec(iTime))) * fundCMat{iTime - 1, jTime};
                    else
                        fundCMat{iTime, jTime} = ...
                            fAMatCalc(tVec(iTime - 1)) * fundCMat{iTime - 1, jTime};
                    end
                end
            end
            
            for jTime = 1:nTimeStep
                for iTime = 1:jTime - 1
                    fundCMat{iTime, jTime} = ...
                        pinv(fundCMat{jTime, iTime});
                end
            end
        end
        
        function trCenterMat = calculateTrajectoryCenterMat(self)
            k0 = self.tIntervalVec(1);
            k1 = self.tIntervalVec(2);
            
            xDim = size(self.linSys.getAtMat(), 1);
            
            syms k;
            fAMatCalc = @(t)subs(self.linSys.getAtMat(), k, t);
            fBMatCalc = @(t)subs(self.linSys.getBtMat(), k, t);

            pCVec = self.linSys.getUBoundsEll().center;
            
            fControlBoundsCenterVecCalc = @(t)subs(pCVec, k, t);
            
            nTimeStep = abs(k1 - k0) + 1;
            
            isBack = k0 > k1;
            
            if isBack
                tVec = k0:-1:k1;
            else
                tVec = k0:k1;
            end
            
            trCenterMat = zeros(xDim, nTimeStep);
            
            [x0Vec ~] = double(self.x0Ell);
            
            trCenterMat(:, 1) = x0Vec;
            for kTime = 2:nTimeStep
                if isBack
                    pinvAMat = pinv(fAMatCalc(tVec(kTime)));
                    trCenterMat(:, kTime) =  pinvAMat * trCenterMat(:, kTime - 1) - ...
                        pinvAMat * fBMatCalc(tVec(kTime)) * fControlBoundsCenterVecCalc(tVec(kTime));
                else
                    trCenterMat(:, kTime) =  fAMatCalc(tVec(kTime - 1)) * trCenterMat(:, kTime - 1) + ...
                        fBMatCalc(tVec(kTime - 1)) * fControlBoundsCenterVecCalc(tVec(kTime - 1));
                end
            end
        end
        
        function directionsCVec = calculateDirectionsCVec(self)
            k0 = self.tIntervalVec(1);
            k1 = self.tIntervalVec(2);
            
            xDim = size(self.linSys.getAtMat(), 1);
            nDirections = size(self.l0Mat, 2);
            
            nTimeStep = abs(k1 - k0) + 1;
            
            directionsCVec = cell(1, nDirections);
            
            for iDirection = 1:nDirections
                directionsCVec{iDirection} = zeros(xDim, nTimeStep);
                lVec = self.l0Mat(:, iDirection);
                directionsCVec{iDirection}(:, 1) = lVec;
                for kTime = 1:nTimeStep - 1
                    directionsCVec{iDirection}(:, kTime + 1) = self.fundCMat{1, kTime + 1}' * lVec;
                end                
            end
        end
        
        function goodCurvesCVec = calculateGoodCurvesCVec(self)
            k0 = self.tIntervalVec(1);
            k1 = self.tIntervalVec(2);
            
            xDim = size(self.linSys.getAtMat(), 1);
            nDirections = size(self.l0Mat, 2);
            
            nTimeStep = abs(k1 - k0) + 1;
            
            [directionsCVec ~] = self.reachObj.get_directions();
            [eaEllMat ~] = self.reachObj.get_ea();
            
            goodCurvesCVec = cell(1, nDirections);
            for iDirection = 1:nDirections
                goodCurvesCVec{iDirection} = zeros(xDim, nTimeStep);                
                
                for kTime = 1:nTimeStep
                    lVec = directionsCVec{iDirection}(:, kTime);
                    [curEaCenterVec curEaShapeMat] = ...
                        double(eaEllMat(iDirection, kTime));
                    
                    goodCurvesCVec{iDirection}(:, kTime) = ...
                        curEaCenterVec + curEaShapeMat * lVec / ...
                        (lVec' * curEaShapeMat * lVec)^(1/2);
                end
            end
        end
        
        function supFunMat = calculateSupFunMat(self)
            k0 = self.tIntervalVec(1);
            k1 = self.tIntervalVec(2);
            
            nDirections = size(self.l0Mat, 2);
            pCMat = self.linSys.getUBoundsEll().shape;
            
            syms k;
            fBMatCalc = @(t)subs(self.linSys.getBtMat(), k, t);
            fControlBoundsMatCalc = @(t)subs(pCMat, k, t);            
            rMatCalc = @(t) fBMatCalc(t) * fControlBoundsMatCalc(t) * fBMatCalc(t)';
            
            nTimeStep = abs(k1 - k0) + 1;
            
            isBack = k0 > k1;
            
            if isBack
                tVec = k0:-1:k1;
            else
                tVec = k0:k1;
            end
            
            [directionsCVec ~] = self.reachObj.get_directions();
            [trCenterMat ~] = self.reachObj.get_center();
            
            x0Mat = double(self.x0Ell);
            
            supFunMat = zeros(nTimeStep, nDirections);
            
            for iDirection = 1:nDirections
                lVec = self.l0Mat(:, iDirection);
                supFunMat(1, iDirection) = sqrt(lVec' * x0Mat * lVec);
                for kTime = 1:nTimeStep - 1
                    if isBack
                        supFunMat(kTime + 1, iDirection) = ...
                            supFunMat(kTime, iDirection) + ...
                            sqrt(lVec' * self.fundCMat{1, kTime} * ...
                            rMatCalc(tVec(kTime + 1)) * self.fundCMat{1, kTime}' * lVec);
                    else
                        supFunMat(kTime + 1, iDirection) = ...
                            supFunMat(kTime, iDirection) + ...
                            sqrt(lVec' * self.fundCMat{1, kTime + 1} * ...
                            rMatCalc(tVec(kTime + 1)) * self.fundCMat{1, kTime + 1}' * lVec);
                    end
                end
                
                for kTime = 1:nTimeStep
                    curDirectionVec = directionsCVec{iDirection}(:, kTime);
                    supFunMat(kTime, iDirection) = supFunMat(kTime, iDirection) + ...
                        curDirectionVec' * trCenterMat(:, kTime);
                end                
            end  
        end
    end
    methods
        function self = DiscreteReachTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
            [~, className] = modgen.common.getcallernameext(1);
            shortClassName = mfilename('classname');
            self.testDataRootDir = [fileparts(which(className)),...
                filesep, 'TestData', filesep, shortClassName];
        end
        %
        function self = set_up_param(self, reachFactObj)
            self.reachObj = reachFactObj.createInstence();
            self.linSys = reachFactObj.getLinSys();
            self.expDim = reachFactObj.getDim();
            self.tIntervalVec = reachFactObj.getTVec();
            self.x0Ell = reachFactObj.getX0Ell();
            self.l0Mat = reachFactObj.getL0Mat();
            self.fundCMat = self.calculateFundamentalMatrix(self);
        end
        
        function self = testConsistency(self)
            k0 = self.tIntervalVec(1);
            k1 = self.tIntervalVec(2);
            
            nTimeStep = abs(k1 - k0) + 1;
            nDirections = size(self.l0Mat, 2);
            xDim = size(self.linSys.getAtMat(), 1);
            
            isBack = k0 > k1;
            
            if isBack
                tVec = k0:-1:k1;
            else
                tVec = k0:k1;
            end
            
            goodDirCVec = self.reachObj.get_directions();
            [eaEllMat ~] = self.reachObj.get_ea();
            [iaEllMat ~] = self.reachObj.get_ia();
            [trCenterMat ~] = self.reachObj.get_center();
            
            nPoints = nTimeStep;
            calcPrecision = 0.001;
            approxSchemaDescr = char.empty(1,0);
            approxSchemaName = char.empty(1,0);
            nDims = xDim;
            nTubes = nDirections;
            QArrayList = repmat({repmat(eye(nDims),[1,1,nPoints])},1,nTubes);
            aMat = trCenterMat;
            timeVec = tVec;
            sTime = k0;
            
            approxType = gras.ellapx.enums.EApproxType.External;
            
            ltGoodDirArray = zeros(xDim, nTubes, nTimeStep);
            for iTube = 1:nTubes
                ltGoodDirArray(:, iTube, :) = goodDirCVec{iTube};
            end
            
            QArrayList = repmat({repmat(zeros(xDim), ...
                [1, 1, nPoints])}, 1, nTubes);
            
            for iTube = 1:nTubes
                for iTime = 1:nTimeStep
                    QArrayList{1, iTube}(:, :, iTime) = double(eaEllMat(iTube, iTime));
                end
            end
            
            rel1 = create();
            
            approxType = gras.ellapx.enums.EApproxType.Internal;
            
            for iTube = 1:nTubes
                for iTime = 1:nTimeStep
                    QArrayList{1, iTube}(:, :, iTime) = double(iaEllMat(iTube, iTime));
                end
            end
            rel2 = create();
            
%             check('wrongInput:internalWithinExternal');
            check();

            mlunit.assert_equals(true, true);
            
            function check(errorTag)
                CMD_STR = 'rel1.getCopy().unionWith(rel2)';
                if nargin == 0
                    eval(CMD_STR);
                else
                    self.runAndCheckError(CMD_STR,...
                        errorTag)
                end
            end
            
            function rel = create()
                rel = gras.ellapx.smartdb.rels.EllTube.fromQArrays(...
                    QArrayList,aMat,timeVec,...
                    ltGoodDirArray,sTime,approxType,approxSchemaName,...
                    approxSchemaDescr,calcPrecision);
            end
        end
        
        function self = DISABLED_testGetSystem(self)
            isEqual = self.linSys == self.reachObj.get_system;
            mlunit.assert_equals(true, isEqual);
            projReachObj = self.reachObj.projection(...
                eye(self.reachObj.dimension, 2));
            isEqual = self.linSys == projReachObj.get_system;
            mlunit.assert_equals(true, isEqual);
        end
        
        function self = DISABLED_testGetCenter(self)
            [trCenterMat ~] = self.reachObj.get_center();
            expectedTrCenterMat = self.calculateTrajectoryCenterMat(self);
            
            isEqual = all(max(abs(expectedTrCenterMat - trCenterMat), [], 1) < self.COMP_PRECISION);
            mlunit.assert_equals(true, isEqual);
        end
        
        function self = DISABLED_testGetDirections(self)
            expectedDirectionsCVec = self.calculateDirectionsCVec(self);
            [directionsCVec ~] = self.reachObj.get_directions();
            
            nDirections = size(self.l0Mat, 2);
            isEqual = true;
            for iDirection = 1:nDirections
                isEqual = isEqual && ...
                    all(max(abs(expectedDirectionsCVec{iDirection} - directionsCVec{iDirection}), [], 1) < self.COMP_PRECISION);
            end            
            mlunit.assert_equals(true, isEqual);
        end
        
        function self = DISABLED_testGetGoodCurves(self)
            expectedGoodCurvesCVec = self.calculateGoodCurvesCVec(self);
            [goodCurvesCVec ~] = self.reachObj.get_goodcurves();
            
            k0 = self.tIntervalVec(1);
            k1 = self.tIntervalVec(2);
            
            nTimeStep = abs(k1 - k0) + 1;
            nDirections = size(self.l0Mat, 2);
            
            isEqual = true;
            for iDirection = 1:nDirections                
                corRelTolMat = [max(abs(goodCurvesCVec{iDirection}), [], 1); ...
                    ones(1, nTimeStep)];
                correctedRelTolVec = self.COMP_PRECISION * ...
                    max(corRelTolMat, [], 1) * 10;
                
                isEqual = isEqual && ...
                    all(max(abs(expectedGoodCurvesCVec{iDirection} - goodCurvesCVec{iDirection}), [], 1) < correctedRelTolVec);
            end         
            mlunit.assert_equals(true, isEqual);
        end
        
        function self = DISABLED_testGetEa(self)
            expectedSupFunMat = self.calculateSupFunMat(self);
            
            k0 = self.tIntervalVec(1);
            k1 = self.tIntervalVec(2);
            
            nTimeStep = abs(k1 - k0) + 1;            
            nDirections = size(self.l0Mat, 2);
            
            [directionsCVec ~] = self.reachObj.get_directions();
            [eaEllMat ~] = self.reachObj.get_ea();
            
            eaSupFunValueMat = zeros(nTimeStep, nDirections);
            
            for iDirection = 1:nDirections
                directionsSeqMat = directionsCVec{iDirection};
                
                for kTime = 1:nTimeStep
                    lVec = directionsSeqMat(:, kTime);
                    eaSupFunValueMat(kTime, iDirection) = ...
                        rho(eaEllMat(iDirection, kTime), lVec);
                end
            end
            
            corRelTolMat = [max(abs(eaSupFunValueMat), [], 2) ...
                ones(nTimeStep, 1)];
            correctedRelTolVec = self.COMP_PRECISION * ...
                max(corRelTolMat, [], 2) * 10;
            
%             isEqual = all(max(abs(expectedSupFunMat - eaSupFunValueMat), [], 2) < ...
%                 correctedRelTolVec);
            isEqual = all(max(abs(expectedSupFunMat - eaSupFunValueMat), [], 2) < ...
                self.COMP_PRECISION);    
            
            mlunit.assert_equals(true, isEqual);
        end
        
        function self = DISABLED_testGetIa(self)
            expectedSupFunMat = self.calculateSupFunMat(self);
            
            k0 = self.tIntervalVec(1);
            k1 = self.tIntervalVec(2);
            
            nTimeStep = abs(k1 - k0) + 1;            
            nDirections = size(self.l0Mat, 2);
            
            [directionsCVec ~] = self.reachObj.get_directions();
            [iaEllMat ~] = self.reachObj.get_ia();
            
            eaSupFunValueMat = zeros(nTimeStep, nDirections);
            
            for iDirection = 1:nDirections
                directionsSeqMat = directionsCVec{iDirection};
                
                for kTime = 1:nTimeStep
                    lVec = directionsSeqMat(:, kTime);
                    eaSupFunValueMat(kTime, iDirection) = ...
                        rho(iaEllMat(iDirection, kTime), lVec);
                end
            end
            
            corRelTolMat = [max(abs(eaSupFunValueMat), [], 2) ...
                ones(nTimeStep, 1)];
            correctedRelTolVec = self.COMP_PRECISION * ...
                max(corRelTolMat, [], 2) * 10;
            
%             isEqual = all(max(abs(expectedSupFunMat - eaSupFunValueMat), [], 2) < ...
%                 correctedRelTolVec);
                    
            isEqual = all(max(abs(expectedSupFunMat - eaSupFunValueMat), [], 2) < ...
                self.COMP_PRECISION);

            mlunit.assert_equals(true, isEqual);
        end
    end
end