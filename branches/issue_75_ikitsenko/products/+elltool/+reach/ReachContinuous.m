classdef ReachContinuous < elltool.reach.AReach
    % Continuous reach set library of the Ellipsoidal Toolbox.
    %
    %
    % Constructor and data accessing functions:
    % -----------------------------------------
    %  ReachContinuous - Constructor of the reach set object, performs the
    %                    computation of the specified reach set approximations.
    %  dimension       - Returns the dimension of the reach set, which can be
    %                    different from the state space dimension of the system
    %                    if the reach set is a projection.
    %  get_system      - Returns the linear system object, for which the reach set
    %                    was computed.
    %                    Warning: returns the last lin system.
    %  get_directions  - Returns the values of the direction vectors corresponding
    %                    to the values of the time grid.
    %  get_center      - Returns points of the reach set center trajectory
    %                    corresponding to the values of the time grid.
    %  get_ea          - Returns external approximating ellipsoids corresponding
    %                    to the values of the time grid.
    %  get_ia          - Returns internal approximating ellipsoids corresponding
    %                    to the values of the time grid.
    %  get_goodcurves  - Returns points of the 'good curves' corresponding
    %                    to the values of the time grid.
    %  intersect       - Checks if external or internal reach set approximation
    %                    intersects with given ellipsoid, hyperplane or polytope.
    %  iscut           - Checks if given reach set object is a cut of another reach set.
    %  isprojection    - Checks if given reach set object is a projection.
    %
    %
    % Reach set data manipulation and plotting functions:
    % ---------------------------------------------------
    %  cut        - Extracts a piece of the reach set that corresponds to the
    %               specified time value or time interval.
    %  projection - Projects the reach set onto a given orthogonal basis.
    %  evolve     - Computes further evolution in time for given reach set
    %               for the same or different dynamical system.
    %  plot_ea    - Plots external approximation of the reach set.
    %  plot_ia    - Plots internal approximation of the reach set.
    %
    %
    % Overloaded functions:
    % ---------------------
    %  display - Displays the reach set object.
    %            Warning: displays only the last linear system.
    %
    %
    % $Authors: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
    %           Kirill Mayantsev  <kirill.mayantsev@gmail.com> $  $Date: March-2012 $
    % $Copyright: Moscow State University,
    %            Faculty of Computational Mathematics and Computer Science,
    %            System Analysis Department 2012 $
    properties (Constant, GetAccess = ?elltool.reach.AReach)
        DISPLAY_PARAMETER_STRINGS = {'continuous-time', 'k0 = ', 'k1 = '}
    end
    %
    methods (Access = private)
        function dataCVec = evolveApprox(self,...
                newTimeVec, newLinSys, approxType)
            import gras.ellapx.smartdb.F;
            APPROX_TYPE = F.APPROX_TYPE;
            OldData = self.ellTubeRel.getTuplesFilteredBy(...
                APPROX_TYPE, approxType);
            sysDimRows = size(OldData.QArray{1}, 1);
            sysDimCols = size(OldData.QArray{1}, 2);
            %
            dataDimVec = OldData.dim;
            l0VecNum = size(dataDimVec, 1);
            l0Mat = zeros(dataDimVec(1), l0VecNum);
            x0VecMat = zeros(sysDimRows, l0VecNum);
            x0MatArray = zeros(sysDimRows, sysDimCols, l0VecNum);
            for il0Num = 1 : l0VecNum
                l0Mat(:, il0Num) = OldData.ltGoodDirMat{il0Num}(:, end);
                x0VecMat(:, il0Num) = OldData.aMat{il0Num}(:, end);
                x0MatArray(:, :, il0Num) =...
                    OldData.QArray{il0Num}(:, :, end);
            end
            [atStrCMat btStrCMat gtStrCMat ptStrCMat ptStrCVec...
                qtStrCMat qtStrCVec] =...
                self.prepareSysParam(newLinSys, newTimeVec);
            %% Normalize good ext/int-directions
            sysDim = size(atStrCMat, 1);
            l0Mat = self.getNormMat(l0Mat, sysDim);
            %% ext/int-approx on the next time interval
            dataCVec = cell(1, l0VecNum);
            isDisturbance = self.isDisturbance(gtStrCMat, qtStrCMat);
            relTol = elltool.conf.Properties.getRelTol();
            for il0Num = l0VecNum: -1 : 1
                smartLinSys = self.getSmartLinSys(atStrCMat,...
                    btStrCMat, ptStrCMat, ptStrCVec, gtStrCMat,...
                    qtStrCMat, qtStrCVec, x0MatArray(:, :, il0Num),...
                    x0VecMat(:, il0Num), [min(newTimeVec),...
                    max(newTimeVec)], relTol, isDisturbance);
                ellTubeRelVec{il0Num} = self.makeEllTubeRel(...
                    smartLinSys, l0Mat(:, il0Num),...
                    [min(newTimeVec) max(newTimeVec)], isDisturbance,...
                    relTol, approxType);
                dataCVec{il0Num} =...
                    ellTubeRelVec{il0Num}.getTuplesFilteredBy(...
                    APPROX_TYPE, approxType).getData();
            end
        end
        function ellTubeRel = makeEllTubeRel(self, smartLinSys, l0Mat,...
                timeVec, isDisturb, calcPrecision, approxTypeVec)
            import gras.ellapx.enums.EApproxType;
            relTol = elltool.conf.Properties.getRelTol();
            goodDirSetObj =...
                gras.ellapx.lreachplain.GoodDirectionSet(...
                smartLinSys, timeVec(1), l0Mat, calcPrecision);
            if (isDisturb)
                extIntBuilder =...
                    gras.ellapx.lreachuncert.ExtIntEllApxBuilder(...
                    smartLinSys, goodDirSetObj, timeVec,...
                    relTol,...
                    self.DEFAULT_INTAPX_S_SELECTION_MODE,...
                    self.MIN_EIG_Q_REG_UNCERT);
                EllTubeBuilder =...
                    gras.ellapx.gen.EllApxCollectionBuilder({extIntBuilder});
                ellTubeRel = EllTubeBuilder.getEllTubes();
            else
                isIntApprox = any(approxTypeVec == EApproxType.Internal);
                isExtApprox = any(approxTypeVec == EApproxType.External);
                if isExtApprox
                    extBuilder =...
                        gras.ellapx.lreachplain.ExtEllApxBuilder(...
                        smartLinSys, goodDirSetObj, timeVec,...
                        relTol);
                    extEllTubeBuilder =...
                        gras.ellapx.gen.EllApxCollectionBuilder({extBuilder});
                    extEllTubeRel = extEllTubeBuilder.getEllTubes();
                    if ~isIntApprox
                        ellTubeRel = extEllTubeRel;
                    end
                end
                if isIntApprox
                    intBuilder =...
                        gras.ellapx.lreachplain.IntEllApxBuilder(...
                        smartLinSys, goodDirSetObj, timeVec,...
                        relTol,...
                        self.DEFAULT_INTAPX_S_SELECTION_MODE);
                    intEllTubeBuilder =...
                        gras.ellapx.gen.EllApxCollectionBuilder({intBuilder});
                    intEllTubeRel = intEllTubeBuilder.getEllTubes();
                    if isExtApprox
                        intEllTubeRel.unionWith(extEllTubeRel);
                    end
                    ellTubeRel = intEllTubeRel;
                end
                
            end
        end
    end
    methods (Access = private, Static)
        function colCodeVec = getColorVec(colChar)
            if ~(ischar(colChar))
                colCodeVec = [0 0 0];
                return;
            end
            switch colChar
                case 'r',
                    colCodeVec = [1 0 0];
                case 'g',
                    colCodeVec = [0 1 0];
                case 'b',
                    colCodeVec = [0 0 1];
                case 'y',
                    colCodeVec = [1 1 0];
                case 'c',
                    colCodeVec = [0 1 1];
                case 'm',
                    colCodeVec = [1 0 1];
                case 'w',
                    colCodeVec = [1 1 1];
                otherwise,
                    colCodeVec = [0 0 0];
            end
        end
        function backwardStrCMat = getBackwardCMat(strCMat, tSum, isMinus)
            t = sym('t');
            t = tSum-t;
            %
            evCMat = cellfun(@eval, strCMat, 'UniformOutput', false);
            symIndMat = cellfun(@(x) isa(x, 'sym'), evCMat);
            backwardStrCMat = cell(size(strCMat));
            backwardStrCMat(symIndMat) = cellfun(@char,...
                evCMat(symIndMat), 'UniformOutput', false);
            backwardStrCMat(~symIndMat) = cellfun(@num2str,...
                evCMat(~symIndMat), 'UniformOutput', false);
            if isMinus
                backwardStrCMat = strcat('-(', backwardStrCMat, ')');
            end
        end
        function outStrCMat = getStrCMat(inpMat)
            outStrCMat =...
                arrayfun(@num2str, inpMat, 'UniformOutput', false);
        end
        function [centerVec shapeMat] = getEllParams(inpEll, relMat)
            if ~isempty(inpEll)
                if isa(inpEll, 'ellipsoid')
                    [centerVec shapeMat] = double(inpEll);
                else
                    if isfield(inpEll, 'center')
                        centerVec = inpEll.center;
                    else
                        centerVec = zeros(size(relMat, 2), 1);
                    end
                    if isfield(inpEll, 'shape')
                        shapeMat = inpEll.shape;
                    else
                        shapeMat = zeros(size(relMat, 2));
                    end
                end
            else
                shapeMat = zeros(size(relMat, 2));
                centerVec = zeros(size(relMat, 2), 1);
            end
        end
        function rotatedEllTubeRel = rotateEllTubeRel(oldEllTubeRel)
            import gras.ellapx.smartdb.F;
            FIELD_NAME_LIST_TO = {F.LS_GOOD_DIR_VEC;F.LS_GOOD_DIR_NORM;...
                F.XS_TOUCH_VEC;F.XS_TOUCH_OP_VEC};
            FIELD_NAME_LIST_FROM = {F.LT_GOOD_DIR_MAT;...
                F.LT_GOOD_DIR_NORM_VEC;F.X_TOUCH_CURVE_MAT;...
                F.X_TOUCH_OP_CURVE_MAT};
            SData = oldEllTubeRel.getData();
            SData.timeVec = cellfun(@fliplr, SData.timeVec,...
                'UniformOutput', false);
            indSTime = numel(SData.timeVec(1));
            SData.indSTime(:) = indSTime;
            cellfun(@cutStructSTimeField,...
                FIELD_NAME_LIST_TO, FIELD_NAME_LIST_FROM);
            SData.lsGoodDirNorm =...
                cell2mat(SData.lsGoodDirNorm);
            rotatedEllTubeRel = oldEllTubeRel.createInstance(SData);
            %
            function cutStructSTimeField(fieldNameTo, fieldNameFrom)
                SData.(fieldNameTo) =...
                    cellfun(@(field) field(:, 1),...
                    SData.(fieldNameFrom), 'UniformOutput', false);
            end
        end
        function isDisturb = isDisturbance(gtStrCMat, qtStrCMat)
            import gras.mat.symb.iscellofstringconst;
            import gras.gen.MatVector;
            isDisturb = true;
            if iscellofstringconst(gtStrCMat)
                gtMat = MatVector.fromFormulaMat(gtStrCMat, 0);
                if all(gtMat(:) == 0)
                    isDisturb = false;
                end
            end
            if isDisturb && iscellofstringconst(qtStrCMat)
                qtMat = MatVector.fromFormulaMat(qtStrCMat, 0);
                if all(qtMat(:) == 0)
                    isDisturb = false;
                end
            end
        end
        function linSys = getSmartLinSys(atStrCMat, btStrCMat,...
                ptStrCMat, ptStrCVec, gtStrCMat, qtStrCMat, qtStrCVec,...
                x0Mat, x0Vec, timeVec, calcPrecision, isDisturb)
            if isDisturb
                linSys = getSysWithDisturb(atStrCMat, btStrCMat,...
                    ptStrCMat, ptStrCVec, gtStrCMat, qtStrCMat,...
                    qtStrCVec, x0Mat, x0Vec, timeVec, calcPrecision);
            else
                linSys = getSysWithoutDisturb(atStrCMat, btStrCMat,...
                    ptStrCMat, ptStrCVec, x0Mat, x0Vec,...
                    timeVec, calcPrecision);
            end
            %
            function linSys = getSysWithDisturb(atStrCMat, btStrCMat,...
                    ptStrCMat, ptStrCVec, gtStrCMat, qtStrCMat, qtStrCVec,...
                    x0Mat, x0Vec, timeVec, calcPrecision)
                import gras.ellapx.lreachuncert.probdyn.*;
                linSys =...
                    LReachProblemDynamicsFactory.createByParams(...
                    atStrCMat, btStrCMat,...
                    ptStrCMat, ptStrCVec, gtStrCMat,...
                    qtStrCMat, qtStrCVec, x0Mat, x0Vec,...
                    timeVec, calcPrecision);
            end
            %
            function linSys = getSysWithoutDisturb(atStrCMat, btStrCMat,...
                    ptStrCMat, ptStrCVec, x0Mat, x0Vec, timeVec, calcPrecision)
                import gras.ellapx.lreachplain.probdyn.*;
                linSys =...
                    LReachProblemDynamicsFactory.createByParams(...
                    atStrCMat, btStrCMat,...
                    ptStrCMat, ptStrCVec, x0Mat, x0Vec,...
                    timeVec, calcPrecision);
            end
        end
        function outMat = getNormMat(inpMat, dim)
            matSqNormVec = sum(inpMat .* inpMat);
            isNormGrZeroVec = matSqNormVec > 0;
            matSqNormVec(isNormGrZeroVec) =...
                sqrt(matSqNormVec(isNormGrZeroVec));
            outMat(:, isNormGrZeroVec) =...
                inpMat(:, isNormGrZeroVec) ./...
                matSqNormVec(ones(1, dim), isNormGrZeroVec);
        end
        function [atStrCMat btStrCMat gtStrCMat...
                ptStrCMat ptStrCVec...
                qtStrCMat qtStrCVec] = prepareSysParam(linSys, timeVec)
            atMat = linSys.getAtMat();
            btMat = linSys.getBtMat();
            gtMat = linSys.getGtMat();
            if ~iscell(atMat) && ~isempty(atMat)
                atStrCMat = elltool.reach.ReachContinuous.getStrCMat(atMat);
            else
                atStrCMat = atMat;
            end
            if ~iscell(btMat) && ~isempty(btMat)
                btStrCMat = elltool.reach.ReachContinuous.getStrCMat(btMat);
            else
                btStrCMat = btMat;
            end
            if isempty(gtMat)
                gtMat = zeros(size(btMat));
            end
            if ~iscell(gtMat)
                gtStrCMat = elltool.reach.ReachContinuous.getStrCMat(gtMat);
            else
                gtStrCMat = gtMat;
            end
            uEll = linSys.getUBoundsEll();
            [ptVec ptMat] =...
                elltool.reach.ReachContinuous.getEllParams(uEll, btMat);
            if ~iscell(ptMat)
                ptStrCMat = elltool.reach.ReachContinuous.getStrCMat(ptMat);
            else
                ptStrCMat = ptMat;
            end
            if ~iscell(ptVec)
                ptStrCVec = elltool.reach.ReachContinuous.getStrCMat(ptVec);
            else
                ptStrCVec = ptVec;
            end
            vEll = linSys.getDistBoundsEll();
            [qtVec qtMat] =...
                elltool.reach.ReachContinuous.getEllParams(vEll, gtMat);
            if ~iscell(qtMat)
                qtStrCMat = elltool.reach.ReachContinuous.getStrCMat(qtMat);
            else
                qtStrCMat = qtMat;
            end
            if ~iscell(qtVec)
                qtStrCVec = elltool.reach.ReachContinuous.getStrCMat(qtVec);
            else
                qtStrCVec = qtVec;
            end
            if timeVec(1) > timeVec(2)
                tSum = sum(timeVec);
                %
                atStrCMat =...
                    elltool.reach.ReachContinuous.getBackwardCMat(...
                    atStrCMat, tSum, true);
                btStrCMat =...
                    elltool.reach.ReachContinuous.getBackwardCMat(...
                    btStrCMat, tSum, true);
                gtStrCMat =...
                    elltool.reach.ReachContinuous.getBackwardCMat(...
                    gtStrCMat, tSum, true);
                ptStrCMat =...
                    elltool.reach.ReachContinuous.getBackwardCMat(...
                    ptStrCMat, tSum, false);
                ptStrCVec =...
                    elltool.reach.ReachContinuous.getBackwardCMat(...
                    ptStrCVec, tSum, false);
                qtStrCMat =...
                    elltool.reach.ReachContinuous.getBackwardCMat(...
                    qtStrCMat, tSum, false);
                qtStrCVec =...
                    elltool.reach.ReachContinuous.getBackwardCMat(...
                    qtStrCVec, tSum, false);
            end
        end
    end
    methods
        function self =...
                ReachContinuous(linSys, x0Ell, l0Mat, timeVec, OptStruct)
            % ReachContinuous - computes reach set approximation of the continuous
            %     linear system for the given time interval.
            % Input:
            %     linSys: elltool.linsys.LinSys object - given linear system
            %     x0Ell: ellipsoid[1, 1] - ellipsoidal set of initial conditions
            %     l0Mat: matrix of double - l0Mat
            %     timeVec: double[1, 2] - time interval
            %         timeVec(1) must be less then timeVec(2)
            %     OptStruct: structure
            %         In this class OptStruct doesn't matter anything
            %
            % Output:
            %     self - reach set object.
            %
            % $Author: Kirill Mayantsev  <kirill.mayantsev@gmail.com> $  $Date: Jan-2012 $
            % $Copyright: Moscow State University,
            %            Faculty of Computational Mathematics and Computer Science,
            %            System Analysis Department 2012 $
            %
            import modgen.common.type.simple.checkgenext;
            import modgen.common.throwerror;
            import gras.ellapx.uncertcalc.EllApxBuilder;
            import gras.ellapx.enums.EApproxType;
            import elltool.logging.Log4jConfigurator;
            %%
            logger=Log4jConfigurator.getLogger(...
                'elltool.ReachCont.constrCallCount');
            logger.debug(sprintf('constructor is called %s',...
                modgen.exception.me.printstack(...
                dbstack,'useHyperlink',false)));
            %
            if (nargin == 0) || isempty(linSys)
                return;
            end
            self.switchSysTimeVec = timeVec;
            self.x0Ellipsoid = x0Ell;
            self.linSysCVec = {linSys};
            self.isCut = false;
            self.isProj = false;
            self.isBackward = timeVec(1) > timeVec(2);
            self.projectionBasisMat = [];
            %% check and analize input
            if nargin < 4
                throwerror('wrongInput', ['insufficient ',...
                    'number of input arguments.']);
            end
            if ~(isa(linSys, 'elltool.linsys.LinSysContinuous'))
                throwerror('wrongInput', ['first input argument ',...
                    'must be linear system object.']);
            end
            if ~(isa(x0Ell, 'ellipsoid'))
                throwerror('wrongInput', ['set of initial ',...
                    'conditions must be ellipsoid.']);
            end
            checkgenext('x1==x2&&x2==x3', 3,...
                dimension(linSys), dimension(x0Ell), size(l0Mat, 1));
            %%
            [timeRows, timeCols] = size(timeVec);
            if ~(isa(timeVec, 'double')) ||...
                    (timeRows ~= 1) || (timeCols ~= 2)
                throwerror('wrongInput', ['time interval must be ',...
                    'specified as ''[t0 t1]'', or, in ',...
                    'discrete-time - as ''[k0 k1]''.']);
            end
            if (nargin < 5) || ~(isstruct(OptStruct))
                OptStruct = [];
                OptStruct.approximation = 2;
                OptStruct.saveAll = 0;
                OptStruct.minmax = 0;
            else
                if ~(isfield(OptStruct, 'approximation')) || ...
                        (OptStruct.approximation < 0) ||...
                        (OptStruct.approximation > 2)
                    OptStruct.approximation = 2;
                end
                if ~(isfield(OptStruct, 'saveAll')) || ...
                        (OptStruct.saveAll < 0) || (OptStruct.saveAll > 2)
                    OptStruct.saveAll = 0;
                end
                if ~(isfield(OptStruct, 'minmax')) || ...
                        (OptStruct.minmax < 0) || (OptStruct.minmax > 1)
                    OptStruct.minmax = 0;
                end
            end
            %% create gras LinSys object
            [x0Vec x0Mat] = double(x0Ell);
            [atStrCMat btStrCMat gtStrCMat ptStrCMat ptStrCVec...
                qtStrCMat qtStrCVec] =...
                self.prepareSysParam(linSys, timeVec);
            isDisturbance = self.isDisturbance(gtStrCMat, qtStrCMat);
            %% Normalize good directions
            sysDim = size(atStrCMat, 1);
            l0Mat = self.getNormMat(l0Mat, sysDim);
            %%
            relTol = elltool.conf.Properties.getRelTol();
            smartLinSys = self.getSmartLinSys(atStrCMat, btStrCMat,...
                ptStrCMat, ptStrCVec, gtStrCMat, qtStrCMat, qtStrCVec,...
                x0Mat, x0Vec, [min(timeVec) max(timeVec)],...
                relTol, isDisturbance);
            approxTypeVec = [EApproxType.External EApproxType.Internal];
            self.ellTubeRel = self.makeEllTubeRel(smartLinSys, l0Mat,...
                [min(timeVec) max(timeVec)], isDisturbance,...
                relTol, approxTypeVec);
            if self.isbackward()
                self.ellTubeRel = self.rotateEllTubeRel(self.ellTubeRel);
            end
        end
        %%
        function display(self)
            self.displayInternal();
        end
        %%
        function newReachObj = evolve(self, newEndTime, linSys)
            import elltool.conf.Properties;
            import gras.ellapx.enums.EApproxType;
            import gras.ellapx.lreachuncert.probdyn.LReachProblemDynamicsFactory;
            import gras.ellapx.uncertcalc.EllApxBuilder;
            import modgen.common.throwerror;
            %% check and analize input
            if nargin < 2
                throwerror('wrongInput', ['insufficient number ',...
                    'of input arguments.']);
            end
            if nargin > 3
                throwerror('wrongInput', 'too much arguments.');
            end
            if self.isprojection()
                throwerror('wrongInput', ['cannot compute ',...
                    'the reach set for projection.']);
            end
            if nargin < 3
                newLinSys = self.get_system();
                oldLinSys = newLinSys;
            else
                if ~(isa(linSys, 'elltool.linsys.LinSysContinuous'))         
                    throwerror('wrongInput', ['first input argument ',...
                        'must be linear system object.']);
                end
                newLinSys = linSys;
                oldLinSys = self.get_system();
            end
            if isempty(newLinSys)
                return;
            end
            if ~isa(newEndTime, 'double')
                throwerror('wrongInput',...
                    'second argument must be double.');
            end
            if (newEndTime < self.switchSysTimeVec(end) &&...
                    ~self.isbackward()) ||...
                    (newEndTime > self.switchSysTimeVec(end) &&...
                    self.isbackward())
                throwerror('wrongInput', ['new end time must be more ',...
                    '(if forward) or less (if backward) than the old one.']);
            end
            if newLinSys.dimension() ~= oldLinSys.dimension()
                throwerror('wrongInput', ['dimensions of the ',...
                    'old and new linear systems do not match.']);
            end
            %%
            newReachObj = elltool.reach.ReachContinuous();
            newReachObj.switchSysTimeVec =...
                [self.switchSysTimeVec newEndTime];
            newReachObj.x0Ellipsoid = self.x0Ellipsoid;
            newReachObj.linSysCVec = [self.linSysCVec {newLinSys}];
            newReachObj.isCut = false;
            newReachObj.isProj = false;
            newReachObj.isBackward = self.isbackward();
            newReachObj.projectionBasisMat = [];
            %
            newTimeVec = newReachObj.switchSysTimeVec(end - 1 : end);
            dataIntCVec = self.evolveApprox(newTimeVec,...
                newLinSys, EApproxType.Internal);
            dataExtCVec = self.evolveApprox(newTimeVec,...
                newLinSys, EApproxType.External);
            dataCVec = [dataIntCVec dataExtCVec];
            %% cat old and new ellTubeRel
            newEllTubeRel =...
                gras.ellapx.smartdb.rels.EllTube.fromStructList(...
                'gras.ellapx.smartdb.rels.EllTube', dataCVec);
            if self.isbackward()
                newEllTubeRel = self.rotateEllTubeRel(newEllTubeRel);
            end
            newReachObj.ellTubeRel =...
                self.ellTubeRel.cat(newEllTubeRel);
        end
    end
end