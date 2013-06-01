classdef ReachDiscrete < elltool.reach.AReach
% Discrete reach set library of the Ellipsoidal Toolbox.
%
% $Authors: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
%           Kirill Mayantsev  <kirill.mayantsev@gmail.com>$
% $Date: March-2013 $ 
% $Copyright: Moscow State University,
%             Faculty of Computational Mathematics
%             and Computer Science, 
%             System Analysis Department 2013 $
%
    properties (Access = private)
        system
        t0
        initial_directions
        time_values
        center_values
        l_values
        ea_values
        ia_values
        mu_values
        minmax
        projection_basis
        calc_data
    end
    %
    methods (Static, Access = private)
        function colCodeVec = my_color_table(colChar)
        % MY_COLOR_TABLE - returns the code of the color defined by single letter.
        %   
        % Input:
        %   regular:
        %       colChar: char[1,1] - single letter, that define code of color.
        %
        % Output:
        %   regular:
        %       colCodeVec: double[1,3] - three-element row vector whose elements 
        %           specify the intensities in the range [0 1] of the red, green 
        %           and blue components of the color.
        %           
        %
        % $Authors: Kirill Mayantsev
        % <kirill.mayantsev@gmail.com> $
        % $Date: March-2013 $ 
        % $Copyright: Moscow State University,
        %             Faculty of Computational Mathematics
        %             and Computer Science, 
        %             System Analysis Department 2013 $
        %
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
        %
        function [QQ, LL] = eedist_de(ntv, X0, l0, mydata, N, back,...
                            mnmx, absTol)
        %
        % EEDIST_DE - recurrence relation for the shape matrix of external 
        %             ellipsoid for discrete-time system with disturbance.
        % 
        %
            import elltool.conf.Properties;
            import gras.la.regposdefmat;
            LL = l0;
            l = l0;
            QQ = X0;
            Q = reshape(X0, N, N);
            vrb = Properties.getIsVerbose();
            Properties.setIsVerbose(false);
            if back > 0
                for i = 2:ntv
                    A = ell_value_extract(mydata.A, i, [N N]);
                    Ai = ell_inv(A);
                    BPB = Ai * ell_value_extract(mydata.BPB, i, [N N]) * Ai';
                    GQG = Ai * ell_value_extract(mydata.GQG, i, [N N]) * Ai';
                    BPB = 0.5 * (BPB + BPB');
                    GQG = 0.5 * (GQG + GQG');
                    Q   = Ai * Q * Ai';
                    if rank(Q) < N
                        Q = regposdefmat(Q, absTol);
                    end
                    if rank(BPB) < N
                        BPB = regposdefmat(BPB, absTol);
                    end
                    if rank(GQG) < N
                        GQG = regposdefmat(GQG, absTol);
                    end
                    l = A' * l;
                    if mnmx > 0 % minmax case
                        E = minkmp_ea(ellipsoid(0.5*(Q+Q')),...
                            ellipsoid(0.5*(GQG+GQG')),...
                            ellipsoid(0.5*(BPB+BPB')), l);
                    else
                        E = minkpm_ea([ellipsoid(0.5*(Q+Q'))...
                            ellipsoid(0.5*(BPB+BPB'))],...
                            ellipsoid(0.5*(GQG+GQG')), l);
                    end
                    if ~isempty(E)
                        Q = parameters(E);
                    else
                        Q = zeros(N, N);
                    end
                    QQ = [QQ reshape(Q, N*N, 1)];
                    LL = [LL l];
                end
            else
                for i = 1:(ntv - 1)
                    A = ell_value_extract(mydata.A, i, [N N]);
                    Ai = ell_inv(A);
                    BPB = ell_value_extract(mydata.BPB, i, [N N]);
                    GQG = ell_value_extract(mydata.GQG, i, [N N]);
                    BPB = 0.5 * (BPB + BPB');
                    GQG = 0.5 * (GQG + GQG');
                    Q = A * Q * A';
                    if size(mydata.delta, 2) > 1
                        dd = mydata.delta(i);
                    elseif isempty(mydata.delta)
                        dd = 0;
                    else
                        dd = mydata.delta(1);
                    end
                    if dd > 0
                        e2 = realsqrt(absTol*absTol + 2*max(eig(BPB))*absTol);
                        BPB = regposdefmat(BPB, e2);
                    elseif rank(BPB) < N
                        BPB = regposdefmat(BPB, absTol);
                    end
                    if rank(GQG) < N
                        GQG = regposdefmat(GQG, absTol);
                    end
                    l = Ai' * l;
                    if mnmx > 0 % minmax case
                        E = minkmp_ea(ellipsoid(0.5*(Q+Q')),...
                            ellipsoid(0.5*(GQG+GQG')),...
                            ellipsoid(0.5*(BPB+BPB')), l);
                    else
                        E = minkpm_ea([ellipsoid(0.5*(Q+Q'))...
                            ellipsoid(0.5*(BPB+BPB'))],...
                            ellipsoid(0.5*(GQG+GQG')), l);
                    end
                    if ~isempty(E)
                        Q = parameters(E);
                    else
                        Q = zeros(N, N);
                    end
                    QQ  = [QQ reshape(Q, N*N, 1)];
                    LL = [LL l];
                end
            end
            Properties.setIsVerbose(vrb);
        end
        %
        function [QQ, LL] = eesm_de(ntv, X0, l0, mydata, N, back,absTol)
            %
            % EESM_DE - recurrence relation for the shape matrix of external 
            %           ellipsoid for discrete-time system without disturbance.
            % 

            import elltool.conf.Properties;
            import gras.la.regposdefmat;
            LL = l0;
            l = l0;
            QQ = X0;
            Q = reshape(X0, N, N);
            vrb = Properties.getIsVerbose();
            Properties.setIsVerbose(false);
            if back > 0
                for i = 2:ntv
                    A = ell_value_extract(mydata.A, i, [N N]);
                    Ai = ell_inv(A);
                    BPB = Ai * ell_value_extract(mydata.BPB, i, [N N]) * Ai';
                    BPB = 0.5 * (BPB + BPB');
                    Q = Ai * Q * Ai';
                    if rank(Q) < N
                        Q = regposdefmat(Q, absTol);
                    end
                    if rank(BPB) < N
                        BPB = regposdefmat(BPB, absTol);
                    end
                    l = A' * l;
                    E = minksum_ea([ellipsoid(0.5*(Q+Q')) ellipsoid(0.5*(BPB+BPB'))], l);
                    Q = parameters(E);
                    QQ = [QQ reshape(Q, N*N, 1)];
                    LL = [LL l];
                end
            else
                for i = 1:(ntv - 1)
                    A = ell_value_extract(mydata.A, i, [N N]);
                    Ai = ell_inv(A);
                    BPB = ell_value_extract(mydata.BPB, i, [N N]);
                    BPB = 0.5 * (BPB + BPB');
                    Q = A * Q * A';
                    if size(mydata.delta, 2) > 1
                        dd = mydata.delta(i);
                    elseif isempty(mydata.delta)
                        dd = 0;
                    else
                        dd = mydata.delta(1);
                    end
                    if dd > 0
                        e2 = realsqrt(absTol*absTol + 2*max(eig(BPB))*absTol);
                        BPB = regposdefmat(BPB, e2);
                    elseif rank(BPB) < N
                        BPB = regposdefmat(BPB, absTol);
                    end
                    l = Ai' * l;
                    E = minksum_ea([ellipsoid(0.5*(Q+Q'))...
                        ellipsoid(0.5*(BPB+BPB'))], l);
                    Q = parameters(E);
                    QQ = [QQ reshape(Q, N*N, 1)];
                    LL = [LL l];
                end
            end
            Properties.setIsVerbose(vrb);
        end
        %
        function QSquareMat = fix_iesm(QMat, dim)
            %
            % FIX_IESM - returns values for (QMat' * QMat).
            %
            n  = size(QMat, 2);
            QSquareMat = zeros(dim*dim, n);
            for i = 1:n
                M = reshape(QMat(:, i), dim, dim);
                QSquareMat(:, i) = reshape(M'*M, dim*dim, 1);
            end
        end
        %
        function [QQ, LL] = iedist_de(ntv, X0, l0, mydata, N, back, mnmx,absTol)
            %
            % IEDIST_DE - recurrence relation for the shape matrix of internal 
            %             ellipsoid for discrete-time system with disturbance.
            % 

            import elltool.conf.Properties;
            import gras.la.regposdefmat;
            LL = l0;
            l = l0;
            QQ = X0;
            Q = reshape(X0, N, N);
            vrb = Properties.getIsVerbose();
            Properties.setIsVerbose(false);
            if back > 0
                for i = 2:ntv
                    A = ell_value_extract(mydata.A, i, [N N]);
                    Ai = ell_inv(A);
                    BPB = Ai * ell_value_extract(mydata.BPB, i, [N N]) * Ai';
                    GQG = Ai * ell_value_extract(mydata.GQG, i, [N N]) * Ai';
                    BPB = 0.5 * (BPB + BPB');
                    GQG = 0.5 * (GQG + GQG');
                    Q = Ai * Q * Ai';
                    if rank(Q) < N
                        Q = regposdefmat(Q, absTol);
                    end
                    if rank(BPB) < N
                        BPB = regposdefmat(BPB, absTol);
                    end
                    if rank(GQG) < N
                        GQG = regposdefmat(GQG, absTol);
                    end
                    l = A' * l;
                    if mnmx > 0 % minmax case
                        E = minkmp_ia(ellipsoid(0.5*(Q+Q')),...
                            ellipsoid(0.5*(GQG+GQG')),...
                            ellipsoid(0.5*(BPB+BPB')), l);
                    else
                        E = minkpm_ia([ellipsoid(0.5*(Q+Q'))...
                            ellipsoid(0.5*(BPB+BPB'))],...
                            ellipsoid(0.5*(GQG+GQG')), l);
                    end
                    if ~isempty(E)
                        Q = parameters(E);
                    else
                        Q = zeros(N, N);
                    end
                    QQ = [QQ reshape(Q, N*N, 1)];
                    LL = [LL l];
                end
            else
                for i = 1:(ntv - 1)
                    A = ell_value_extract(mydata.A, i, [N N]);
                    Ai = ell_inv(A);
                    BPB = ell_value_extract(mydata.BPB, i, [N N]);
                    GQG = ell_value_extract(mydata.GQG, i, [N N]);
                    BPB = 0.5 * (BPB + BPB');
                    GQG = 0.5 * (GQG + GQG');
                    Q = A * Q * A';
                    if size(mydata.delta, 2) > 1
                        dd = mydata.delta(i);
                    elseif isempty(mydata.delta)
                        dd = 0;
                    else
                        dd = mydata.delta(1);
                    end
                    if dd > 0
                        e2  = realsqrt(absTol*absTol + 2*max(eig(BPB))*absTol);
                        BPB = regposdefmat(BPB, e2);
                    elseif rank(BPB) < N
                        BPB = regposdefmat(BPB, absTol);
                    end
                    if rank(GQG) < N
                        GQG = regposdefmat(GQG, absTol);
                    end
                    l = Ai' * l;
                    if mnmx > 0 % minmax case
                        E = minkmp_ia(ellipsoid(0.5*(Q+Q')),...
                            ellipsoid(0.5*(GQG+GQG')),...
                            ellipsoid(0.5*(BPB+BPB')), l);
                    else
                        E = minkpm_ia([ellipsoid(0.5*(Q+Q'))...
                            ellipsoid(0.5*(BPB+BPB'))],...
                            ellipsoid(0.5*(GQG+GQG')), l);
                    end
                    if ~isempty(E)
                        Q = parameters(E);
                    else
                        Q = zeros(N, N);
                    end
                    QQ = [QQ reshape(Q, N*N, 1)];
                    LL = [LL l];
                end
            end
            Properties.setIsVerbose(vrb);
        end
        %
        function [QQ, LL] = iesm_de(ntv, X0, l0, mydata, N, back,absTol)
            %
            % IESM_DE - recurrence relation for the shape matrix of internal 
            %           ellipsoid for discrete-time system without disturbance.
            % 

            import elltool.conf.Properties;
            import gras.la.regposdefmat;
            LL = l0;
            l = l0;
            QQ = X0;
            Q = reshape(X0, N, N);
            vrb = Properties.getIsVerbose();
            Properties.setIsVerbose(false);
            if back > 0
                for i = 2:ntv
                    A = ell_value_extract(mydata.A, i, [N N]);
                    Ai = ell_inv(A);
                    BPB = Ai * ell_value_extract(mydata.BPB, i, [N N]) * Ai';
                    BPB = 0.5 * (BPB + BPB');
                    Q = Ai * Q * Ai';
                    if rank(Q) < N
                        Q = regposdefmat(Q, absTol);
                    end
                    if rank(BPB) < N
                        BPB = regposdefmat(BPB, absTol);
                    end
                    l = A' * l;
                    E = minksum_ia([ellipsoid(0.5*(Q+Q'))...
                        ellipsoid(0.5*(BPB+BPB'))], l);
                    Q = parameters(E);
                    QQ = [QQ reshape(Q, N*N, 1)];
                    LL = [LL l];
                end
            else
                for i = 1:(ntv - 1)
                    A = ell_value_extract(mydata.A, i, [N N]);
                    Ai = ell_inv(A);
                    BPB = ell_value_extract(mydata.BPB, i, [N N]);
                    BPB = 0.5 * (BPB + BPB');
                    
                    Q = A * Q * A';
                    if size(mydata.delta, 2) > 1
                        dd = mydata.delta(i);
                    elseif isempty(mydata.delta)
                        dd = 0;
                    else
                        dd = mydata.delta(1);
                    end
                    if dd > 0
                        e2 = realsqrt(absTol*absTol + 2*max(eig(BPB))*absTol);
                        BPB = regposdefmat(BPB, e2);
                    elseif rank(BPB) < N
                        BPB = regposdefmat(BPB, absTol);
                    end
                    l = Ai' * l;
                    E = minksum_ia([ellipsoid(0.5*(Q+Q'))...
                        ellipsoid(0.5*(BPB+BPB'))], l);
                    Q = parameters(E);
                    QQ = [QQ reshape(Q, N*N, 1)];
                    LL = [LL l];
                end
            end
            Properties.setIsVerbose(vrb);
        end
        %
        function evalMat = matrix_eval(XCMat, time)
            %
            % MATRIX_EVAL - evaluates symbolic matrix at given time instant.
            %
            if ~(iscell(XCMat))
                evalMat = XCMat;
                return;
            end
            k = time;
            [m, n] = size(XCMat);
            evalMat = zeros(m, n);
            for i = 1:m
                for j = 1:n
                    evalMat(i, j) = eval(XCMat{i, j});
                end
            end
        end
        %
        function x = ellbndr_2d(ell, num)
        %
        % ELLBNDR_2D - compute the boundary of 2D ellipsoid.
        %
            import elltool.conf.Properties;
            if nargin < 2
                num = elltool.reach.ReachDiscrete.getNPlot2dPoints(ell);
            end
            phi = linspace(0, 2*pi, num);
            l = [cos(phi); sin(phi)];
            [r, x] = rho(ell, l);
        end
        %
        function x = ellbndr_3d(ell)
        %
        % ELLBNDR_3D - compute the boundary of 3D ellipsoid.
        %
            import elltool.conf.Properties;
            M = elltool.reach.ReachDiscrete.getNPlot3dPoints(ell)/2;
            N = M/2;
            psy = linspace(0, pi, N);
            phi = linspace(0, 2*pi, M);
            l = [];
            for i = 2:(N - 1)
                arr = cos(psy(i))*ones(1, M);
                l = [l [cos(phi)*sin(psy(i)); sin(phi)*sin(psy(i)); arr]];
            end
            [r, x] = rho(ell, l);
        end
    end
    %
    methods
        function self = ReachDiscrete(linSys, x0Ell, l0Mat,...
                timeVec, OptStruct, varargin)
        %
        % ReachDiscrete - computes reach set approximation of the discrete linear 
        %                 system for the given time interval.
        % 
        % 
        % Input:
        %     linSys: elltool.linsys.LinSys object - given linear system 
        %     x0Ell: ellipsoid[1, 1] - ellipsoidal set of initial conditions 
        %     l0Mat: matrix of double - l0Mat 
        %     timeVec: double[1, 2] - time interval 
        %     OptStruct: struct[1, 1] - structure with
        %     fields:
        %         approximation: int[1, 1] - field, which mean the following values 
        %          for type approximation:
        %           = 0 for external,
        %           = 1 for internal, 
        %           = 2 for both (default).
        %         save_all: logical [1, 1] - field, which
        %           = 1 if save intermediate calculation data,
        %           = 0 (default) if delete intermediate calculation data.
        %         minmax: logical[1, 1] - field, which:
        %           = 1 compute minmax reach set,
        %           = 0 (default) compute maxmin reach set.
        %         This option makes sense only for discrete-time systems with 
        %         disturbance.
        %
        % self = ReachDiscrete(linSys, x0Ell, l0Mat,timeVec, Options, prop) is the 
        % same as self = ReachDiscrete(linSys, x0Ell, l0Mat, timeVec, Options), but 
        % with "Properties"  specified in  prop. 
        % In other cases "Properties" are taken from current values stored in 
        % elltool.conf.Properties
        %
        % As "Properties" we understand here such list of ellipsoid properties:
        %         absTol
        %         relTol 
        %         nPlot2dPoints
        %         Plot3dPoints 
        %         nTimeGridPoints
        %
        % Output:
        %   regular:
        %       self - reach set object.
        %
        % Example:
        %   adMat = [0 1; -1 -0.5]; 
        %   bdMat = [0; 1];  
        %   udBoundsEllObj  = ellipsoid(1);  
        %   dtsys = elltool.linsys.LinSysDiscrete(adMat, bdMat, udBoundsEllObj); 
        %   x0EllObj = ell_unitball(2);  
        %   timeVec = [0 10];  
        %   dirsMat = [1 0; 0 1]';
        %   dRsObj = elltool.reach.ReachDiscrete(dtsys, x0EllObj, dirsMat, timeVec);
        %
        %
        % $Author: Kirill Mayantsev
        % <kirill.mayantsev@gmail.com> $  
        % $Date: Jan-2013 $ 
        % $Copyright: Moscow State University,
        %             Faculty of Computational
        %             Mathematics and Computer Science,
        %             System Analysis Department 2013 $
        %
            import gras.la.sqrtmpos;
            import elltool.conf.Properties;
            import modgen.common.throwerror;
            import elltool.logging.Log4jConfigurator;
            import gras.la.regposdefmat;
            %
            persistent logger;
            neededPropNameList =...
                {'absTol', 'relTol', 'nPlot2dPoints',...
                'nPlot3dPoints','nTimeGridPoints'};
            [absTolVal, relTolVal, nPlot2dPointsVal,...
                nPlot3dPointsVal, nTimeGridPointsVal] =...
                Properties.parseProp(varargin, neededPropNameList);
            %
            self.absTol = absTolVal;
            self.relTol = relTolVal;
            self.nPlot2dPoints = nPlot2dPointsVal;
            self.nPlot3dPoints = nPlot3dPointsVal;
            self.nTimeGridPoints = nTimeGridPointsVal;
            if (nargin == 0) || isempty(linSys)
                return;
            end
            if isstruct(linSys) && (nargin == 1)
                return;
            end
            self.system             = [];
            self.t0                 = [];
            self.x0Ellipsoid        = [];
            self.initial_directions = [];
            self.time_values        = [];
            self.center_values      = [];
            self.l_values           = [];
            self.ea_values          = [];
            self.ia_values          = [];
            self.mu_values          = [];
            self.minmax             = [];
            self.projection_basis   = [];
            self.calc_data          = [];
            %
            self.switchSysTimeVec = [];
            self.linSysCVec = [];
            self.isCut = false;
            self.isProj = false;
            self.projectionBasisMat = [];
            %% check and analize input
            if nargin < 4
                throwerror('wrongInput',...
                    'insufficient number of input arguments.');
            end
            if ~(isa(linSys, 'elltool.linsys.LinSysDiscrete'))
                throwerror('wrongInput',['first input argument ',...
                    'must be linear system object.']);
            end
            linSys = linSys(1, 1);
            [d1, du, dy, dd] = linSys.dimension();
            if ~isa(x0Ell, 'ellipsoid')
                throwerror('wrongInput',...
                    'set of initial conditions must be ellipsoid.');
            end
            x0Ell = x0Ell(1, 1);
            d2 = dimension(x0Ell);
            if d1 ~= d2
                throwerror('wrongInput',...
                    ['dimensions of linear system and ',...
                    'set of initial conditions do not match.']);
            end
            [k, l] = size(timeVec);
            if ~(isa(timeVec, 'double')) || (k ~= 1) || ((l ~= 2) && (l ~= 1))
                throwerror(['time interval must be specified ',...
                    'as ''[t0 t1]'', or, in ',...
                    'discrete-time - as ''[k0 k1]''.']);
            end
            [m, N] = size(l0Mat);
            if m ~= d2
                throwerror('wrongInput',...
                    ['dimensions of state space ',...
                    'and direction vector do not match.']);
            end
            if (nargin < 5) || ~(isstruct(OptStruct))
                OptStruct               = [];
                OptStruct.approximation = 2;
                OptStruct.save_all      = 0;
                OptStruct.minmax        = 0;
            else
                if ~(isfield(OptStruct, 'approximation')) ||...
                        (OptStruct.approximation < 0) ||...
                        (OptStruct.approximation > 2)
                    OptStruct.approximation = 2;
                end
                if ~(isfield(OptStruct, 'save_all')) ||...
                        (OptStruct.save_all < 0) || (OptStruct.save_all > 2)
                    OptStruct.save_all = 0;
                end
                if ~(isfield(OptStruct, 'minmax')) ||...
                        (OptStruct.minmax < 0) || (OptStruct.minmax > 1)
                    OptStruct.minmax = 0;
                end
            end
            %
            self.system             = linSys;
            self.x0Ellipsoid        = x0Ell;
            self.initial_directions = l0Mat;
            self.minmax             = OptStruct.minmax;
            % Create time grid
            if size(timeVec, 2) == 1
                self.t0 = 0;
                h     = round(timeVec);
            else
                self.t0 = round(timeVec(1));
                h     = round(timeVec(2));
            end
            if h < self.t0
                self.time_values = fliplr(h:(self.t0));
            else
                self.time_values = (self.t0):h;
            end
            if self.time_values(1) > self.time_values(end)
                back  = 1;
                tvals = - self.time_values;
            else
                back  = 0;
                tvals = self.time_values;
            end
            %
            www = warning;
            warning off;
            %%% Perform matrix, control, disturbance and
            %%% noise evaluations. Create splines if needed.
            if Properties.getIsVerbose()
                if isempty(logger)
                    logger=Log4jConfigurator.getLogger();
                end
                logger.info('Performing preliminary function evaluations...');
            end
            %
            mydata.A     = [];
            mydata.Bp    = [];
            mydata.BPB   = [];
            mydata.BPBsr = [];
            mydata.Gq    = [];
            mydata.GQG   = [];
            mydata.GQGsr = [];
            mydata.C     = [];
            mydata.w     = [];
            mydata.W     = [];
            mydata.Phi   = [];
            mydata.Phinv = [];
            mydata.delta = [];
            mydata.mu    = [];
            % matrix A
            aMat = linSys.getAtMat();
            if iscell(aMat)
                AA = zeros(d1*d1, size(self.time_values, 2));
                DD = zeros(1, size(self.time_values, 2));
                AC = zeros(d1*d1, size(self.time_values, 2));
                for i = 1:size(self.time_values, 2)
                    if (back > 0) && ~(isa(linSys, ...
                            'elltool.linsys.LinSysDiscrete')) && 0
                        A  = self.matrix_eval(aMat, -self.time_values(i));
                    else
                        A  = self.matrix_eval(aMat, self.time_values(i));
                    end
                    AC(:, i) = reshape(A, d1*d1, 1);
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete') ...
                            && (rank(A) < d1)
                        A        = regposdefmat(A, self.absTol);
                        DD(1, i) = 1;
                    elseif isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        DD(1, i) = 0;
                    end
                    AA(:, i) = reshape(A, d1*d1, 1);
                end
                if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                    mydata.A     = AA;
                    mydata.delta = DD;
                else
                    mydata.A = spline(self.time_values, AA);
                end
            else
                AC = aMat;
                if isa(linSys, 'elltool.linsys.LinSysDiscrete') ...
                        && (rank(aMat) < d1)
                    mydata.A     = regposdefmat(aMat, self.absTol);
                    mydata.delta = 1;
                elseif isa(linSys, 'elltool.linsys.LinSysDiscrete')
                    mydata.A     = aMat;
                    mydata.delta = 0;
                else
                    mydata.A     = aMat;
                end
            end
            % matrix B
            bMat = linSys.getBtMat();
            if iscell(bMat)
                BB = zeros(d1*du, size(self.time_values, 2));
                for i = 1:size(self.time_values, 2)
                    B        = self.matrix_eval(bMat, self.time_values(i));
                    BB(:, i) = reshape(B, d1*du, 1);
                end
            else
                BB = reshape(bMat, d1*du, 1);
            end
            % matrix G
            gMat = linSys.getGtMat();
            GG = zeros(d1*dd, size(self.time_values, 2));
            if iscell(gMat)
                for i = 1:size(self.time_values, 2)
                    B        = self.matrix_eval(gMat, self.time_values(i));
                    GG(:, i) = reshape(B, d1*dd, 1);
                end
            elseif ~(isempty(gMat))
                GG = reshape(gMat, d1*dd, 1);
            end
            % matrix C
            cMat = linSys.getCtMat();
            if iscell(cMat)
                CC = zeros(d1*dy, size(self.time_values, 2));
                for i = 1:size(self.time_values, 2)
                    C        = self.matrix_eval(cMat, self.time_values(i));
                    CC(:, i) = reshape(C, d1*dy, 1);
                end
                if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                    mydata.C = CC;
                else
                    mydata.C = spline(self.time_values, CC);
                end
            else
                mydata.C = cMat;
            end
            % expressions Bp and BPB'
            uEll = linSys.getUBoundsEll();
            if isa(uEll, 'ellipsoid')
                [p, P] = parameters(uEll);
                if size(BB, 2) == 1
                    B            = reshape(BB, d1, du);
                    mydata.Bp    = B * p;
                    mydata.BPB   = B * P * B';
                    mydata.BPBsr = sqrtmpos(full(mydata.BPB), self.absTol);
                    mydata.BPBsr = 0.5*(mydata.BPBsr + (mydata.BPBsr)');
                else
                    Bp    = zeros(d1, size(self.time_values, 2));
                    BPB   = zeros(d1*d1, size(self.time_values, 2));
                    BPBsr = zeros(d1*d1, size(self.time_values, 2));
                    for i = 1:size(self.time_values, 2)
                        B           = reshape(BB(:, i), d1, du);
                        Bp(:, i)    = B*p;
                        B           = B * P * B';
                        BPB(:, i)   = reshape(B, d1*d1, 1);
                        B           = sqrtmpos(B, self.absTol);
                        B           = 0.5*(B + B');
                        BPBsr(:, i) = reshape(B, d1*d1, 1);
                    end
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        mydata.Bp    = Bp;
                        mydata.BPB   = BPB;
                        mydata.BPBsr = BPBsr;
                    else
                        mydata.Bp    = spline(self.time_values, Bp);
                        mydata.BPB   = spline(self.time_values, BPB);
                        mydata.BPBsr = spline(self.time_values, BPBsr);
                    end
                end
            elseif isa(uEll, 'double')
                p  = uEll;
                if size(BB, 2) == 1
                    mydata.Bp = reshape(BB, d1, du) * p;
                else
                    Bp = zeros(d1, size(self.time_values, 2));
                    for i = 1:size(self.time_values, 2)
                        B        = reshape(BB(:, i), d1, du);
                        Bp(:, i) = B*p;
                    end
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        mydata.Bp = Bp;
                    else
                        mydata.Bp = spline(self.time_values, Bp);
                    end
                end
            elseif iscell(uEll)
                p  = uEll;
                Bp = zeros(d1, size(self.time_values, 2));
                for i = 1:size(self.time_values, 2)
                    if size(BB, 2) == 1
                        B = reshape(BB, d1, du);
                    else
                        B = reshape(BB(:, i), d1, du);
                    end
                    Bp(:, i) = B*self.matrix_eval(p, self.time_values(i));
                end
                if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                    mydata.Bp = Bp;
                else
                    mydata.Bp = spline(self.time_values, Bp);
                end
            elseif isstruct(uEll)
                if size(BB, 2) == 1
                    B = reshape(BB, d1, du);
                    if iscell(uEll.center) && iscell(uEll.shape)
                        Bp    = zeros(d1, size(self.time_values, 2));
                        BPB   = zeros(d1*d1, size(self.time_values, 2));
                        BPBsr = zeros(d1*d1, size(self.time_values, 2));
                        for i = 1:size(self.time_values, 2)
                            p = self.matrix_eval(uEll.center, self.time_values(i));
                            P = self.matrix_eval(uEll.shape, self.time_values(i));
                            if ~gras.la.ismatposdef(P,self.absTol,false)
                                throwerror('wrongInput:wrongMat',....
                                    ['shape matrix of ',...
                                    'ellipsoidal control bounds ',...
                                    'must be positive definite.']);
                            end
                            Bp(:, i)    = B*p;
                            P           = B * P * B';
                            BPB(:, i)   = reshape(P, d1*d1, 1);
                            P           = sqrtmpos(P, self.absTol);
                            P           = 0.5*(P + P');
                            BPBsr(:, i) = reshape(P, d1*d1, 1);
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.Bp    = Bp;
                            mydata.BPB   = BPB;
                            mydata.BPBsr = BPBsr;
                        else
                            mydata.Bp    = spline(self.time_values, Bp);
                            mydata.BPB   = spline(self.time_values, BPB);
                            mydata.BPBsr = spline(self.time_values, BPBsr);
                        end
                    elseif iscell(uEll.center)
                        Bp  = zeros(d1, size(self.time_values, 2));
                        for i = 1:size(self.time_values, 2)
                            p  = self.matrix_eval(uEll.center, self.time_values(i));
                            Bp(:, i) = B*p;
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.Bp  = Bp;
                        else
                            mydata.Bp  = spline(self.time_values, Bp);
                        end
                        mydata.BPB   = B * uEll.shape * B';
                        mydata.BPBsr = sqrtmpos(mydata.BPB, self.absTol);
                        mydata.BPBsr = 0.5*(mydata.BPBsr + (mydata.BPBsr)');
                    else
                        BPB   = zeros(d1*d1, size(self.time_values, 2));
                        BPBsr = zeros(d1*d1, size(self.time_values, 2));
                        for i = 1:size(self.time_values, 2)
                            P = self.matrix_eval(uEll.shape, self.time_values(i));
                            if ~gras.la.ismatposdef(P,self.absTol,false)
                                throwerror('wrongInput:wrongMat',...
                                    ['shape matrix of ',...
                                    'ellipsoidal control bounds ',...
                                    'must be positive definite.']);
                            end
                            P           = B * P * B';
                            BPB(:, i)   = reshape(P, d1*d1, 1);
                            P           = sqrtmpos(P, self.absTol);
                            P           = 0.5*(P + P');
                            BPBsr(:, i) = reshape(P, d1*d1, 1);
                        end
                        mydata.Bp = B * uEll.center;
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.BPB   = BPB;
                            mydata.BPBsr = BPBsr;
                        else
                            mydata.BPB   = spline(self.time_values, BPB);
                            mydata.BPBsr = spline(self.time_values, BPBsr);
                        end
                    end
                else
                    Bp    = zeros(d1, size(self.time_values, 2));
                    BPB   = zeros(d1*d1, size(self.time_values, 2));
                    BPBsr = zeros(d1*d1, size(self.time_values, 2));
                    for i = 1:size(self.time_values, 2)
                        B = reshape(BB(:, i), d1, du);
                        if iscell(uEll.center)
                            p = self.matrix_eval(uEll.center, self.time_values(i));
                        else
                            p = uEll.center;
                        end
                        if iscell(uEll.shape)
                            P = self.matrix_eval(uEll.shape, self.time_values(i));
                            if ~gras.la.ismatposdef(P,self.absTol,false)
                                throwerror('wrongInput:wrongMat',...
                                    ['shape matrix of ',...
                                    'ellipsoidal control bounds ',...
                                    'must be positive definite.']);
                            end
                        else
                            P = uEll.shape;
                        end
                        Bp(:, i)    = B*p;
                        P           = B * P * B';
                        BPB(:, i)   = reshape(P, d1*d1, 1);
                        P           = sqrtmpos(P, self.absTol);
                        P           = 0.5*(P + P');
                        BPBsr(:, i) = reshape(P, d1*d1, 1);
                    end
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        mydata.Bp    = Bp;
                        mydata.BPB   = BPB;
                        mydata.BPBsr = BPBsr;
                    else
                        mydata.Bp    = spline(self.time_values, Bp);
                        mydata.BPB   = spline(self.time_values, BPB);
                        mydata.BPBsr = spline(self.time_values, BPBsr);
                    end
                end
            end
            % expressions Gq and GQG'
            vEll = linSys.getDistBoundsEll();
            if ~(isempty(GG))
                if isa(vEll, 'ellipsoid')
                    [q, Q] = parameters(vEll);
                    if size(GG, 2) == 1
                        G            = reshape(GG, d1, dd);
                        mydata.Gq    = G * q;
                        mydata.GQG   = G * Q * G';
                        mydata.GQGsr = sqrtmpos(mydata.GQG, self.absTol);
                        mydata.GQGsr = 0.5*(mydata.GQGsr + (mydata.GQGsr)');
                    else
                        Gq    = zeros(d1, size(self.time_values, 2));
                        GQG   = zeros(d1*d1, size(self.time_values, 2));
                        GQGsr = zeros(d1*d1, size(self.time_values, 2));
                        for i = 1:size(self.time_values, 2)
                            G           = reshape(GG(:, i), d1, dd);
                            Gq(:, i)    = G*q;
                            G           = G * Q * G';
                            GQG(:, i)   = reshape(G, d1*d1, 1);
                            G           = sqrtmpos(G, self.absTol);
                            G           = 0.5*(G + G');
                            GQGsr(:, i) = reshape(G, d1*d1, 1);
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.Gq    = Gq;
                            mydata.GQG   = GQG;
                            mydata.GQGsr = GQGsr;
                        else
                            mydata.Gq    = spline(self.time_values, Gq);
                            mydata.GQG   = spline(self.time_values, GQG);
                            mydata.GQGsr = spline(self.time_values, GQGsr);
                        end
                    end
                elseif isa(vEll, 'double')
                    q  = vEll;
                    if size(GG, 2) == 1
                        mydata.Gq = reshape(GG, d1, dd) * q;
                    else
                        Gq = zeros(d1, size(self.time_values, 2));
                        for i = 1:size(self.time_values, 2)
                            G  = reshape(GG(:, i), d1, dd);
                            Gq(:, i) = G*q;
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.Gq = Gq;
                        else
                            mydata.Gq = spline(self.time_values, Gq);
                        end
                    end
                elseif iscell(vEll)
                    q  = vEll;
                    Gq = zeros(d1, size(self.time_values, 2));
                    for i = 1:size(self.time_values, 2)
                        if size(GG, 2) == 1
                            G = reshape(GG, d1, dd);
                        else
                            G = reshape(GG(:, i), d1, dd);
                        end
                        Gq(:, i) = G*self.matrix_eval(q, self.time_values(i));
                    end
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        mydata.Gq = Gq;
                    else
                        mydata.Gq = spline(self.time_values, Gq);
                    end
                elseif isstruct(vEll)
                    if size(GG, 2) == 1
                        G = reshape(GG, d1, dd);
                        if iscell(vEll.center) &&...
                                iscell(vEll.shape)
                            Gq    = zeros(d1, size(self.time_values, 2));
                            GQG   = zeros(d1*d1, size(self.time_values, 2));
                            GQGsr = zeros(d1*d1, size(self.time_values, 2));
                            for i = 1:size(self.time_values, 2)
                                q = self.matrix_eval(vEll.center, self.time_values(i));
                                Q = self.matrix_eval(vEll.shape, self.time_values(i));
                                if ~gras.la.ismatposdef(Q,self.absTol,false)
                                    throwerror('wrongInput:wrongMat',...
                                        ['shape matrix of ',...
                                        'ellipsoidal disturbance bounds ',...
                                        'must be positive definite.']);
                                end
                                Gq(:, i)    = G*q;
                                Q           = G * Q * G';
                                GQG(:, i)   = reshape(Q, d1*d1, 1);
                                Q           = sqrtmpos(Q, self.absTol);
                                Q           = 0.5*(Q + Q');
                                GQGsr(:, i) = reshape(Q, d1*d1, 1);
                            end
                            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                                mydata.Gq    = Gq;
                                mydata.GQG   = GQG;
                                mydata.GQGsr = GQGsr;
                            else
                                mydata.Gq    = spline(self.time_values, Gq);
                                mydata.GQG   = spline(self.time_values, GQG);
                                mydata.GQGsr = spline(self.time_values, GQGsr);
                            end
                        elseif iscell(vEll.center)
                            Gq  = zeros(d1, size(self.time_values, 2));
                            for i = 1:size(self.time_values, 2)
                                q  = self.matrix_eval(vEll.center, self.time_values(i));
                                Gq(:, i) = G*q;
                            end
                            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                                mydata.Gq  = Gq;
                            else
                                mydata.Gq  = spline(self.time_values, Gq);
                            end
                            mydata.GQG   = G * vEll.shape * G';
                            mydata.GQGsr = sqrtmpos(mydata.GQG, self.absTol);
                            mydata.GQGsr = 0.5*(mydata.GQGsr + (mydata.GQGsr)');
                        else
                            GQG   = zeros(d1*d1, size(self.time_values, 2));
                            GQGsr = zeros(d1*d1, size(self.time_values, 2));
                            for i = 1:size(self.time_values, 2)
                                Q = self.matrix_eval(vEll.shape, self.time_values(i));
                                if ~gras.la.ismatposdef(Q,self.absTol,false)
                                    throwerror('wrongInput:wrongMat',...
                                        ['shape matrix of ',...
                                        'ellipsoidal disturbance bounds ',...
                                        'must be positive definite.']);
                                end
                                Q           = G * Q * G';
                                GQG(:, i)   = reshape(Q, d1*d1, 1);
                                Q           = sqrtmpos(Q, self.absTol);
                                Q           = 0.5*(Q + Q');
                                GQGsr(:, i) = reshape(Q, d1*d1, 1);
                            end
                            mydata.Gq  = G * vEll.center;
                            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                                mydata.GQG   = GQG;
                                mydata.GQGsr = GQGsr;
                            else
                                mydata.GQG   = spline(self.time_values, GQG);
                                mydata.GQGsr = spline(self.time_values, GQGsr);
                            end
                        end
                    else
                        Gq    = zeros(d1, size(self.time_values, 2));
                        GQG   = zeros(d1*d1, size(self.time_values, 2));
                        GQGsr = zeros(d1*d1, size(self.time_values, 2));
                        for i = 1:size(self.time_values, 2)
                            G = reshape(GG(:, i), d1, dd);
                            if iscell(vEll.center)
                                q = self.matrix_eval(vEll.center, self.time_values(i));
                            else
                                q = vEll.center;
                            end
                            if iscell(vEll.shape)
                                Q = self.matrix_eval(vEll.shape, self.time_values(i));
                                if ~gras.la.ismatposdef(Q,self.absTol,false)
                                    throwerror('wrongInput:wrongMat',...
                                        ['shape matrix of ',...
                                        'ellipsoidal disturbance bounds ',...
                                        'must be positive definite.']);
                                end
                            else
                                Q = vEll.shape;
                            end
                            Gq(:, i)    = G*q;
                            Q           = G * Q * G';
                            GQG(:, i)   = reshape(Q, d1*d1, 1);
                            Q           = sqrtmpos(Q, self.absTol);
                            Q           = 0.5*(Q + Q');
                            GQGsr(:, i) = reshape(Q, d1*d1, 1);
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.Gq    = Gq;
                            mydata.GQG   = GQG;
                            mydata.GQGsr = GQGsr;
                        else
                            mydata.Gq    = spline(self.time_values, Gq);
                            mydata.GQG   = spline(self.time_values, GQG);
                            mydata.GQGsr = spline(self.time_values, GQGsr);
                        end
                    end
                end
            end
            % expressions w and W
            noiseEll = linSys.getNoiseBoundsEll();
            if ~(isempty(noiseEll))
                if isa(noiseEll, 'ellipsoid')
                    [w, W]   = parameters(noiseEll);
                    mydata.w = w;
                    mydata.W = W;
                elseif isa(noiseEll, 'double')
                    mydata.w = noiseEll;
                elseif iscell(noiseEll)
                    w = [];
                    for i = 1:size(self.time_values, 2)
                        w = [w self.matrix_eval(noiseEll.center, self.time_values(i))];
                    end
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        mydata.w = w;
                    else
                        mydata.w = spline(self.time_values, w);
                    end
                elseif isstruct(noiseEll)
                    if iscell(noiseEll.center) && iscell(noiseEll.shape)
                        w = [];
                        W = [];
                        for i = 1:size(self.time_values, 2)
                            w  = [w self.matrix_eval(noiseEll.center, self.time_values(i))];
                            ww = self.matrix_eval(noiseEll.shape, self.time_values(i));
                            if ~gras.la.ismatposdef(ww,self.absTol,false)
                                throwerror('wrongInput:wrongMat',...
                                    ['shape matrix of ',...
                                    'ellipsoidal noise bounds must be positive definite.']);
                            end
                            W  = [W reshape(ww, dy*dy, 1)];
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.w = w;
                            mydata.W = W;
                        else
                            mydata.w = spline(self.time_values, w);
                            mydata.W = spline(self.time_values, W);
                        end
                    elseif iscell(noiseEll.center)
                        w = [];
                        for i = 1:size(self.time_values, 2)
                            w = [w self.matrix_eval(noiseEll.center, self.time_values(i))];
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.w = w;
                        else
                            mydata.w = spline(self.time_values, w);
                        end
                        mydata.W = noiseEll.shape;
                    else
                        W = [];
                        for i = 1:size(self.time_values, 2)
                            ww = self.matrix_eval(noiseEll.shape, self.time_values(i));
                            if ~gras.la.ismatposdef(ww,self.absTol,false)
                                throwerror('wrongInput:wrongMat',...
                                    ['shape matrix of ',...
                                    'ellipsoidal noise bounds must be positive definite.']);
                            end
                            W  = [W reshape(ww, dy*dy, 1)];
                        end
                        mydata.w = noiseEll.center;
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.W = W;
                        else
                            mydata.W = spline(self.time_values, W);
                        end
                    end
                end
            end
            clear('A', 'B', 'C', 'AA', 'BB', 'CC', 'DD', 'Bp',...
                'BPB', 'Gq', 'GQG', 'p', 'P', 'q', 'Q', 'w', 'W', 'ww');
            %%% Compute state transition matrix.
            if Properties.getIsVerbose()
                if isempty(logger)
                    logger=Log4jConfigurator.getLogger();
                end
                logger.info('Computing state transition matrix...');
            end
            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                mydata.Phi   = [];
                mydata.Phinv = [];
            else
                if isa(mydata.A, 'double')
                    % continuous system with constant A
                    t0    = self.time_values(1);
                    Phi   = zeros(d1*d1, size(self.time_values, 2));
                    Phinv = zeros(d1*d1, size(self.time_values, 2));
                    for i = 1:size(self.time_values, 2)
                        P = expm(mydata.A * abs(self.time_values(i) - t0));
                        PP          = ell_inv(P);
                        Phi(:, i)   = reshape(P, d1*d1, 1);
                        Phinv(:, i) = reshape(PP, d1*d1, 1);
                    end
                    mydata.Phi   = spline(self.time_values, Phi);
                    mydata.Phinv = spline(self.time_values, Phinv);
                else
                    % continuous system with A(t)
                    I0        = reshape(eye(d1), d1*d1, 1);
                    [tt, Phi] = ell_ode_solver(@ell_stm_ode, tvals, I0,...
                        mydata, d1, back, self.absTol);
                    Phi       = Phi';
                    Phinv     = zeros(d1*d1, size(self.time_values, 2));
                    for i = 1:size(self.time_values, 2)
                        Phinv(:, i) = reshape(ell_inv(reshape(Phi(:, i), d1, d1)), d1*d1, 1);
                    end
                    mydata.Phi   = spline(self.time_values, Phi);
                    mydata.Phinv = spline(self.time_values, Phinv);
                end
            end
            clear('Phi', 'Phinv', 'P', 'PP', 't0', 'I0');
            %%% Compute the center of the reach set.
            if Properties.getIsVerbose()
                if isempty(logger)
                    logger=Log4jConfigurator.getLogger();
                end
                logger.info('Computing the trajectory of the reach set center...');
            end
            [x0, X0] = parameters(x0Ell);
            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                xx = x0;
                x  = x0;
                for i = 1:(size(self.time_values, 2) - 1)
                    Bp = ell_value_extract(mydata.Bp, i+back, [d1 1]);
                    if ~(isempty(mydata.Gq))
                        Gq = ell_value_extract(mydata.Gq, i+back, [d1 1]);
                    else
                        Gq = zeros(d1, 1);
                    end
                    if back > 0
                        A = ell_value_extract(mydata.A, i+back, [d1 d1]);
                        x = ell_inv(A)*(x - Bp - Gq);
                    else
                        A = ell_value_extract(AC, i, [d1 d1]);
                        x = A*x + Bp + Gq;
                    end
                    xx = [xx x];
                end
            else
                [tt, xx] = ell_ode_solver(@ell_center_ode, tvals, x0,...
                    mydata, d1, back, self.absTol);
                xx       = xx';
            end
            self.center_values = xx;
            clear('A', 'AC', 'xx');
            %%% Compute external shape matrices.
            if (OptStruct.approximation ~= 1)
                if Properties.getIsVerbose()
                    if isempty(logger)
                        logger=Log4jConfigurator.getLogger();
                    end
                    logger.info('Computing external shape matrices...');
                end
                LL = [];
                QQ = [];
                Q0 = reshape(X0, d1*d1, 1);
                for ii = 1:N
                    l0 = l0Mat(:, ii);
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        if linSys.hasdisturbance()
                            [Q, L] = self.eedist_de(size(tvals, 2),...
                                Q0, l0, mydata, d1, back, self.absTol);
                        elseif ~(isempty(mydata.BPB))
                            [Q, L] = self.eesm_de(size(tvals, 2),...
                                Q0, l0, mydata, d1, back, self.absTol);
                        else
                            Q = [];
                            L = [];
                        end
                        LL = [LL {L}];
                    else
                        if linSys.hasdisturbance()
                            [tt, Q] = ell_ode_solver(@ell_eedist_ode,...
                                tvals, Q0, l0, mydata, d1, back,...
                                self.absTol);
                            Q = Q';
                        elseif ~(isempty(mydata.BPB))
                            [tt, Q] = ell_ode_solver(@ell_eesm_ode,...
                                tvals, Q0, l0, mydata, d1, back,...
                                self.absTol);
                            Q = Q';
                        else
                            Q = [];
                        end
                    end
                    QQ = [QQ {Q}];
                end
                self.ea_values = QQ;
            end
            %%% Compute internal shape matrices.
            if (OptStruct.approximation ~= 0)
                if Properties.getIsVerbose()
                    if isempty(logger)
                        logger=Log4jConfigurator.getLogger();
                    end
                    logger.info('Computing internal shape matrices...');
                end
                LL = [];
                QQ = [];
                Q0 = reshape(X0, d1*d1, 1);
                M  = sqrtmpos(X0, self.absTol);
                M  = 0.5*(M + M');
                for ii = 1:N
                    l0 = l0Mat(:, ii);
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        if linSys.hasdisturbance()
                            [Q, L] = self.iedist_de(size(tvals, 2),...
                                Q0, l0, mydata, d1, back, OptStruct.minmax, self.absTol);
                        elseif ~(isempty(mydata.BPB))
                            [Q, L] = self.iesm_de(size(tvals, 2),...
                                Q0, l0, mydata, d1, back,self.absTol);
                        else
                            Q = [];
                            L = [];
                        end
                        LL = [LL {L}];
                    else
                        if linSys.hasdisturbance()
                            [tt, Q] = ell_ode_solver(@ell_iedist_ode,...
                                tvals, reshape(X0, d1*d1, 1), l0,...
                                mydata, d1, back, self.absTol);
                            Q = Q';
                        elseif ~(isempty(mydata.BPB))
                            [tt, Q] = ell_ode_solver(@ell_iesm_ode,...
                                tvals, reshape(M, d1*d1, 1), M*l0, l0,...
                                mydata, d1, back, self.absTol);
                            Q = self.fix_iesm(Q', d1);
                        else
                            Q = [];
                        end
                    end
                    QQ = [QQ {Q}];
                end
                self.ia_values = QQ;
            end
            self.calc_data = mydata;
            if ~isa(linSys, 'elltool.linsys.LinSysDiscrete')
                LL = [];
                for ii = 1:N
                    l0 = l0Mat(:, ii);
                    L  = zeros(d1, size(self.time_values, 2));
                    for i = 1:size(self.time_values, 2)
                        t = self.time_values(i);
                        if back > 0
                            F = ell_value_extract(mydata.Phi, t, [d1 d1]);
                        else
                            F = ell_value_extract(mydata.Phinv, t, [d1 d1]);
                        end
                        L(:, i) = F'*l0;
                    end
                    LL = [LL {L}];
                end
            end
            self.l_values = LL;
            if www(1).state
                warning on;
            end
        end
        %
        function RRS = refine(self, L0, Options)
            %
            % REFINE - adds new approximations computed for the specified directions
            %          to the given reach set.
            %
            %
            % Description:
            % ------------
            %
            % RRS = REFINE(RS, L0, OPTIONS)
            %        Given nonempty reach set RS and direction
            %        vectors specified by matrix L0,
            %        adds new approximations computed for those
            %        directions to this reach set.
            %        This refinement is possible only if the reach
            %        set was obtained by the REACH call with option
            %        'save_all' set to 1 (intermediate calculation
            %        information is saved in the reach set object).
            %        Optional OPTIONS parameter is a structure:
            %          Options.approximation = 0 for external,
            %                                = 1 for internal,
            %                                = 2 for both (default).
            %          Options.save_all = 1 (default) to save intermediate
            %                               calculation data,
            %                           = 0 to delete intermediate
            %                               calculation data.
            %          Options.minmax = 1 compute minmax reach set,
            %          Options.minmax = 0 (default) compute maxmin reach set.
            %                         This option makes sense only for
            %                        discrete-time systems with disturbance.
            %
            %    WARNING! This function does not work with reach set objects resulting
            %             form CUT and/or PROJECTION operation.
            %
            %
            %
            % Output:
            % -------
            %
            %    RRS - refined reach set.
            %
            %
            % See also:
            % ---------
            %
            %    REACH/REACH.
            %
            
            %
            % Author:
            % -------
            %
            %    Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
            %
            import elltool.conf.Properties;
            RRS = self(1, 1);
            if isempty(RRS)
                return;
            end
            
            if nargin < 2
                error('REFINE: insufficient number of input arguments.');
            end
            
            if iscut(RRS)
                error('REFINE: cannot perform a refinement on a cut of the reach set.');
            end
            
            if isprojection(RRS)
                error('REFINE: cannot perform a refinement on a projection of the reach set.');
            end
            
            d1 = dimension(RRS);
            k  = size(RRS.initial_directions, 1);
            if isempty(L0)
                m = k;
            else
                [m, n] = size(L0);
            end
            if (k ~= m) | (d1 ~= m)
                error('REFINE: dimensions of the reach set and direction vectors do not matcch.');
            end
            
            mydata = RRS.calc_data;
            if isempty(mydata) | ~(isstruct(mydata))
                error('REFINE: cannot perform a refinement without intermediate calculation info.');
            end
            
            if (nargin < 3) | ~(isstruct(Options))
                Options               = [];
                Options.approximation = 2;
                Options.save_all      = 1;
                Options.minmax        = 0;
            else
                if ~(isfield(Options, 'approximation')) | ...
                        (Options.approximation < 0) | (Options.approximation > 2)
                    Options.approximation = 2;
                end
                if ~(isfield(Options, 'save_all')) | ...
                        (Options.save_all < 0) | (Options.save_all > 2)
                    Options.save_all = 1;
                end
                if ~(isfield(Options, 'minmax')) | ...
                        (Options.minmax < 0) | (Options.minmax > 1)
                    Options.minmax = 0;
                end
            end
            
            www = warning;
            warning off;
            
            tvals = RRS.time_values;
            if tvals(1) > tvals(end)
                tvals = -tvals;
                back  = 1;
            else
                back  = 0;
            end
            
            RRS.initial_directions = [RRS.initial_directions L0];
            N                      = size(RRS.initial_directions, 2);
            EN                     = size(RRS.ea_values, 2);
            IN                     = size(RRS.ia_values, 2);
            x0Ellipsoid                     = parameters(RRS.x0Ellipsoid);
            
            
            %%% Compute external shape matrices. %%%
            
            if (Options.approximation ~= 1)
                if Properties.getIsVerbose()
                    if (N - EN) > 0
                        fprintf('Computing external shape matrices...\n');
                    end
                end
                
                LL = [];
                QQ = [];
                Q0 = reshape(x0Ellipsoid, d1*d1, 1);
                for ii = (EN + 1):N
                    l0 = RRS.initial_directions(:, ii);
                    if hasdisturbance(RRS.system)
                        [Q, L] = reach.eedist_de(size(tvals, 2), ...
                            Q0, ...
                            l0, ...
                            mydata, ...
                            d1, ...
                            back, ...
                            Options.minmax,self.absTol);
                    elseif ~(isempty(mydata.BPB))
                        [Q, L] = self.eesm_de(size(tvals, 2), Q0, l0, mydata, d1, back,self.absTol);
                    else
                        Q = [];
                        L = [];
                    end
                    LL = [LL {L}];
                    QQ = [QQ {Q}];
                end
                RRS.ea_values = [RRS.ea_values QQ];
            end
            
            %%% Compute internal shape matrices. %%%
            
            if (Options.approximation ~= 0)
                if Properties.getIsVerbose()
                    if (N - IN) > 0
                        fprintf('Computing internal shape matrices...\n');
                    end
                end
                
                LL = [];
                QQ = [];
                Q0 = reshape(x0Ellipsoid, d1*d1, 1);
                M  = sqrtm(x0Ellipsoid);
                M  = 0.5*(M + M');
                for ii = (IN + 1):N
                    l0 = RRS.initial_directions(:, ii);
                    if hasdisturbance(RRS.system)
                        [Q, L] = reach.iedist_de(size(tvals, 2), ...
                            Q0, ...
                            l0, ...
                            mydata, ...
                            d1, ...
                            back, ...
                            Options.minmax,self.absTol);
                    elseif ~(isempty(mydata.BPB))
                        [Q, L] = self.iesm_de(size(tvals, 2), Q0, l0, mydata, d1, back,self.absTol);
                    else
                        Q = [];
                        L = [];
                    end
                    LL = [LL {L}];
                    QQ = [QQ {Q}];
                end
                RRS.ia_values = [RRS.ia_values QQ];
            end
            % Save direction values if necessary.
            if Options.save_all == 0
                RRS.calc_data = [];
            end
            
            LL = [];
            for ii = 1:N
                l0 = RRS.initial_directions(:, ii);
                L = l0;
                l = l0;
                if back > 0
                    for i = 2:size(RRS.time_values, 2)
                        A = ell_value_extract(mydata.A, i, [d1 d1]);
                        l = A' * l;
                        L = [L l];
                    end
                else
                    for i = 1:(size(RRS.time_values, 2) - 1)
                        A = ell_inv(ell_value_extract(mydata.A, i, [d1 d1]));
                        l = A' * l;
                        L = [L l];
                    end
                end
                LL = [LL {L}];
            end
            RRS.l_values  = LL;
            if www(1).state
                warning on;
            end
        end
        %
        function newReachObjArr = getCopy(self)
        % GETCOPY - create a new copy of Self reach object. 
        %
        % Input:
        %   self: reach[1, 1] - reach set object, copy of which should be create.
        %
        % Output:
        %     newReachObj - reach set object.
        %
        % Example:
        %   adMat = [0 1; -1 -0.5]; 
        %   bdMat = [0; 1];  
        %   udBoundsEllObj  = ellipsoid(1);  
        %   dtsys = elltool.linsys.LinSysDiscrete(adMat, bdMat, udBoundsEllObj); 
        %   x0EllObj = ell_unitball(2);  
        %   timeVec = [0 10];  
        %   dirsMat = [1 0; 0 1]';
        %   dRsObj = elltool.reach.ReachDiscrete(dtsys, x0EllObj, dirsMat, timeVec);
        %   newDRsObj = dRsObj.getCopy();
        %
        % $Author: Kirill Mayantsev
        % <kirill.mayantsev@gmail.com> $  
        % $Date: Jan-2013 $ 
        % $Copyright: Moscow State University,
        %             Faculty of Computational
        %             Mathematics and Computer Science,
        %             System Analysis Department 2013 $
        %
            if ~isempty(self)    
                sizeCVec = num2cell(size(self));
                newReachObjArr(sizeCVec{:}) = elltool.reach.ReachDiscrete();
                arrayfun(@fSingleCopy,newReachObjArr,self);
            else
                newReachObjArr = elltool.reach.ReachDiscrete.empty(size(self));
            end    
            function fSingleCopy(newReachObj, reachObj)   
                newReachObj.absTol = reachObj.absTol;
                newReachObj.relTol = reachObj.relTol;
                newReachObj.nPlot2dPoints = reachObj.nPlot2dPoints;
                newReachObj.nPlot3dPoints = reachObj.nPlot3dPoints;
                newReachObj.nTimeGridPoints = reachObj.nTimeGridPoints;
                newReachObj.system = reachObj.system;
                newReachObj.t0 = reachObj.t0;
                newReachObj.initial_directions = reachObj.initial_directions;
                newReachObj.time_values = reachObj.time_values;
                newReachObj.center_values = reachObj.center_values;
                newReachObj.l_values = reachObj.l_values;
                newReachObj.ea_values = reachObj.ea_values;
                newReachObj.ia_values = reachObj.ia_values;
                newReachObj.mu_values = reachObj.mu_values;
                newReachObj.minmax = reachObj.minmax;
                newReachObj.projection_basis = reachObj.projection_basis;
                newReachObj.calc_data = reachObj.calc_data;
                newReachObj.switchSysTimeVec = reachObj.switchSysTimeVec;
                newReachObj.x0Ellipsoid = reachObj.x0Ellipsoid;
                newReachObj.linSysCVec = reachObj.linSysCVec;
                newReachObj.isCut = reachObj.isCut;
                newReachObj.isProj = reachObj.isProj;
                newReachObj.projectionBasisMat = reachObj.projectionBasisMat;
            end
        end
        %
        function cutObj = cut(self, cutTimeVec)
            import modgen.common.throwerror;
            cutObj = self.getCopy();
            if self.isempty()
                return;
            end
            if self.time_values(1) > self.time_values(end)
                back = 1;
                Tmn  = self.time_values(end);
                Tmx  = self.time_values(1);
            else
                back = 0;
                Tmn  = self.time_values(1);
                Tmx  = self.time_values(end);
            end
            [m, n] = size(cutTimeVec);
            linSys = self.get_system();
            if ~(isa(cutTimeVec, 'double')) || (m ~= 1) || ((n ~= 1) && (n ~= 2))
                if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                    if back > 0
                        throwerror(['CUT: second input argument must ',...
                            'specify time interval in the form ''[k1 k0]'', or ''k''.']);
                    else
                        throwerror(['CUT: second input argument must ',...
                            'specify time interval in the form ''[k0 k1]'', or ''k''.']);
                    end
                else
                    if back > 0
                        throwerror(['CUT: second input argument must ',...
                            'specify time interval in the form ''[t1 t0]'', or ''t''.']);
                    else
                        throwerror(['CUT: second input argument must ',...
                            'specify time interval in the form ''[t0 t1]'', or ''t''.']);
                    end
                end
            end
            tmn = min(cutTimeVec);
            tmx = max(cutTimeVec);
            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                tmn = round(tmn);
                tmx = round(tmx);
            end
            smx = min([tmx Tmx]);
            smn = max([tmn Tmn]);
            if smn > smx
                throwerror('CUT: specified time interval is out of range.');
            end
            TT = self.time_values;
            NV = size(TT, 2);
            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                indarr = find((TT == smn) | ((TT > smn) & (TT < smx)) | (TT == smx));
            else
                indarr = find((TT > smn) & (TT < smx));
            end
            N1 = size(self.ea_values, 2);
            N2 = size(self.ia_values, 2);
            d  = self.dimension();
            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                if size(indarr, 2) == 1
                    k = find(TT == smn);
                    cutObj.time_values = self.time_values(k);
                    cutObj.center_values = self.center_values(:, k);
                    QQ = [];
                    for i = 1:N1
                        Q  = self.ea_values{i};
                        QQ = [QQ {Q(:, k)}];
                    end
                    cutObj.ea_values = QQ;
                    QQ = [];
                    for i = 1:N2
                        Q  = self.ia_values{i};
                        QQ = [QQ {Q(:, k)}];
                    end
                    cutObj.ia_values = QQ;
                    if ~(isempty(self.calc_data))
                        md = self.calc_data;
                        if ~(isempty(md.A)) && (size(md.A, 2) == NV)
                            md.A = md.A(:, k);
                        end
                        if ~(isempty(md.Bp)) && (size(md.Bp, 2) == NV)
                            md.Bp = md.Bp(:, k);
                        end
                        if ~(isempty(md.BPB)) && (size(md.BPB, 2) == NV)
                            md.BPB = md.BPB(:, k);
                        end
                        if ~(isempty(md.BPBsr)) && (size(md.BPBsr, 2) == NV)
                            md.BPBsr = md.BPBsr(:, k);
                        end
                        if ~(isempty(md.Gq)) && (size(md.Gq, 2) == NV)
                            md.Gq = md.Gq(:, k);
                        end
                        if ~(isempty(md.GQG)) && (size(md.GQG, 2) == NV)
                            md.GQG = md.GQG(:, k);
                        end
                        if ~(isempty(md.GQGsr)) && (size(md.GQGsr, 2) == NV)
                            md.GQGsr = md.GQGsr(:, k);
                        end
                        if ~(isempty(md.C)) && (size(md.C, 2) == NV)
                            md.C = md.C(:, k);
                        end
                        if ~(isempty(md.w)) && (size(md.w, 2) == NV)
                            md.w = md.w(:, k);
                        end
                        if ~(isempty(md.W)) && (size(md.W, 2) == NV)
                            md.W = md.W(:, k);
                        end
                        if ~(isempty(md.Phi)) && (size(md.Phi, 2) == NV)
                            md.Phi = md.Phi(:, k);
                        end
                        if ~(isempty(md.Phinv)) && (size(md.Phinv, 2) == NV)
                            md.Phinv = md.Phinv(:, k);
                        end
                        if ~(isempty(md.delta)) && (size(md.delta, 2) == NV)
                            md.delta = md.delta(:, k);
                        end
                        cutObj.calc_data = md;
                    elseif ~(isempty(self.l_values))
                        N3 = size(self.l_values, 2);
                        LL = [];
                        for i = 1:N3
                            L  = self.l_values{i};
                            LL = [LL, {L(:, k)}];
                        end
                        cutObj.l_values = LL;
                    end
                else
                    is = indarr(1);
                    ie = indarr(end);
                    cutObj.time_values = self.time_values(is:ie);
                    cutObj.center_values = self.center_values(:, is:ie);
                    QQ = [];
                    for i = 1:N1
                        Q = self.ea_values{i};
                        QQ = [QQ {Q(:, is:ie)}];
                    end
                    cutObj.ea_values = QQ;
                    QQ = [];
                    for i = 1:N2
                        Q = self.ia_values{i};
                        QQ = [QQ {Q(:, is:ie)}];
                    end
                    cutObj.ia_values = QQ;
                    if ~(isempty(self.calc_data))
                        md = self.calc_data;
                        if ~(isempty(md.A)) && (size(md.A, 2) == NV)
                            md.A = md.A(:, is:ie);
                        end
                        if ~(isempty(md.Bp)) && (size(md.Bp, 2) == NV)
                            md.Bp = md.Bp(:, is:ie);
                        end
                        if ~(isempty(md.BPB)) && (size(md.BPB, 2) == NV)
                            md.BPB = md.BPB(:, is:ie);
                        end
                        if ~(isempty(md.BPBsr)) && (size(md.BPBsr, 2) == NV)
                            md.BPBsr = md.BPBsr(:, is:ie);
                        end
                        if ~(isempty(md.Gq)) && (size(md.Gq, 2) == NV)
                            md.Gq = md.Gq(:, is:ie);
                        end
                        if ~(isempty(md.GQG)) && (size(md.GQG, 2) == NV)
                            md.GQG = md.GQG(:, is:ie);
                        end
                        if ~(isempty(md.GQGsr)) && (size(md.GQGsr, 2) == NV)
                            md.GQGsr = md.GQGsr(:, is:ie);
                        end
                        if ~(isempty(md.C)) && (size(md.C, 2) == NV)
                            md.C = md.C(:, is:ie);
                        end
                        if ~(isempty(md.w)) && (size(md.w, 2) == NV)
                            md.w = md.w(:, is:ie);
                        end
                        if ~(isempty(md.W)) && (size(md.W, 2) == NV)
                            md.W = md.W(:, is:ie);
                        end
                        if ~(isempty(md.Phi)) && (size(md.Phi, 2) == NV)
                            md.Phi = md.Phi(:, is:ie);
                        end
                        if ~(isempty(md.Phinv)) && (size(md.Phinv, 2) == NV)
                            md.Phinv = md.Phinv(:, is:ie);
                        end
                        if ~(isempty(md.delta)) && (size(md.delta, 2) == NV)
                            md.delta = md.delta(:, is:ie);
                        end
                        cutObj.calc_data = md;
                    elseif ~(isempty(self.l_values))
                        N3 = size(self.l_values, 2);
                        LL = [];
                        for i = 1:N3
                            L  = self.l_values{i};
                            LL = [LL, {L(:, is:ie)}];
                        end
                        cutObj.l_values = LL;
                    end
                end
            else
                if isempty(indarr)
                    cutObj.time_values   = smn;
                    cs = spline(self.time_values, self.center_values);
                    cutObj.center_values = ell_value_extract(cs, smn, [d 1]);
                    QQ = [];
                    for i = 1:N1
                        Q = self.ea_values{i};
                        ss = spline(self.time_values, Q);
                        QQ = [QQ {ell_value_extract(ss, smn, [d*d 1])}];
                    end
                    cutObj.ea_values = QQ;
                    QQ = [];
                    for i = 1:N2
                        Q  = self.ia_values{i};
                        ss = spline(self.time_values, Q);
                        QQ = [QQ {ell_value_extract(ss, smn, [d*d 1])}];
                    end
                    cutObj.ia_values = QQ;
                    if ~(isempty(self.l_values))
                        N3 = size(self.l_values, 2);
                        LL = [];
                        for i = 1:N3
                            L  = self.l_values{i};
                            d1 = size(L, 1);
                            ss = spline(self.time_values, L);
                            LL = [LL {ell_value_extract(ss, smn, [d1 1])}];
                        end
                        cutObj.l_values = LL;
                    end
                else
                    is = indarr(1);
                    ie = indarr(end);
                    cs = spline(self.time_values, self.center_values);
                    qn = ell_value_extract(cs, smn, [d 1]);
                    qx = ell_value_extract(cs, smx, [d 1]);
                    if back > 0
                        cutObj.time_values = [smx self.time_values(is:ie) smn];
                        cutObj.center_values = [qx self.center_values(:, is:ie) qn];
                    else
                        cutObj.time_values = [smn self.time_values(is:ie) smx];
                        cutObj.center_values = [qn self.center_values(:, is:ie) qx];
                    end
                    QQ = [];
                    for i = 1:N1
                        Q = self.ea_values{i};
                        ss = spline(self.time_values, Q);
                        Qn = ell_value_extract(ss, smn, [d*d 1]);
                        Qx = ell_value_extract(ss, smx, [d*d 1]);
                        if back > 0
                            E = [Qx Q(:, is:ie) Qn];
                        else
                            E = [Qn Q(:, is:ie) Qx];
                        end
                        QQ = [QQ {E}];
                    end
                    cutObj.ea_values = QQ;
                    QQ = [];
                    for i = 1:N2
                        Q = self.ia_values{i};
                        ss = spline(self.time_values, Q);
                        Qn = ell_value_extract(ss, smn, [d*d 1]);
                        Qx = ell_value_extract(ss, smx, [d*d 1]);
                        if back > 0
                            E = [Qx Q(:, is:ie) Qn];
                        else
                            E = [Qn Q(:, is:ie) Qx];
                        end
                        QQ = [QQ {E}];
                    end
                    cutObj.ia_values = QQ;
                    if ~(isempty(self.l_values))
                        N3 = size(self.l_values, 2);
                        LL = [];
                        for i = 1:N3
                            L = self.l_values{i};
                            d1 = size(L, 1);
                            ss = spline(self.time_values, L);
                            Ln = ell_value_extract(ss, smn, [d1 1]);
                            Lx = ell_value_extract(ss, smx, [d1 1]);
                            if back > 0
                                E = [Lx L(:, is:ie) Ln];
                            else
                                E = [Ln L(:, is:ie) Lx];
                            end
                            LL = [LL {E}];
                        end
                        cutObj.l_values = LL;
                    end
                end
            end
            cutObj.isCut = true;
        end
        %
        function [rSdim sSdim] = dimension(self)
            [m, n] = size(self);
            rSdim = [];
            sSdim = [];
            for i = 1:m
                dd = [];
                nn = [];
                for j = 1:n
                    s = dimension(self(i, j).system);
                    if isempty(self(i, j).projection_basis)
                        d = s;
                    else
                        d = size(self(i, j).projection_basis, 2);
                    end
                    dd = [dd d];
                    nn = [nn s];
                end
                rSdim = [rSdim; dd];
                sSdim = [sSdim; nn];
            end
            if nargout < 2
                clear('sSdim');
            end
        end
        %
        function display(self)
            if self.isempty()
                return;
            end
            fprintf('\n');
            disp([inputname(1) ' =']);
            [m, n] = size(self);
            if (m > 1) || (n > 1)
                fprintf('%dx%d array of reach set objects\n\n', m, n);
                return;
            end
            if isempty(self)
                fprintf('Empty reach set object.\n\n');
                return;
            end
            linSys = self.get_system();
            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                ttyp = 'discrete-time';
                ttst = 'k = ';
                tts0 = 'k0 = ';
                tts1 = 'k1 = ';
            else
                ttyp = 'continuous-time';
                ttst = 't = ';
                tts0 = 't0 = ';
                tts1 = 't1 = ';
            end
            d = linSys.dimension();
            if size(self.time_values, 2) == 1
                if self.time_values < self.t0
                    back = 1;
                    fprintf(['Backward reach set of the %s linear ',...
                        'system in R^%d at time %s%d.\n'], ttyp,...
                        d, ttst, self.time_values);
                else
                    back = 0;
                    fprintf(['Reach set of the %s linear system ',...
                        'in R^%d at time %s%d.\n'], ttyp,...
                        d, ttst, self.time_values);
                end
            else
                if self.time_values(1) > self.time_values(end)
                    back = 1;
                    fprintf(['Backward reach set of the %s linear ',...
                        'system in R^%d in the time interval [%d, %d].\n'],...
                        ttyp, d, self.time_values(1), self.time_values(end));
                else
                    back = 0;
                    fprintf(['Reach set of the %s linear system ',...
                        'in R^%d in the time interval [%d, %d].\n'],...
                        ttyp, d, self.time_values(1), self.time_values(end));
                end
            end
            if ~(isempty(self.projection_basis))
                fprintf('Projected onto the basis:\n');
                disp(self.projection_basis);
            end
            fprintf('\n');
            if back > 0
                fprintf('Target set at time %s%d:\n', tts1, self.t0);
            else
                fprintf('Initial set at time %s%d:\n', tts0, self.t0);
            end
            disp(self.x0Ellipsoid);
            fprintf('Number of external approximations: %d\n',...
                size(self.ea_values, 2));
            fprintf('Number of internal approximations: %d\n',...
                size(self.ia_values, 2));
            if ~(isempty(self.calc_data))
                fprintf('\nCalculation data preserved.\n');
            end
            fprintf('\n');
        end
        %
        function [trCenterMat timeVec] = get_center(self)
            import elltool.conf.Properties;
            trCenterMat  = self.center_values;
            if nargout > 1
                timeVec = self.time_values;
            end
        end
        %
        function [directionsCVec timeVec] = get_directions(self)
            import elltool.conf.Properties;
            directionsCVec  = [];
            if isempty(self)
                if nargout > 1
                    timeVec = [];
                end
                return;
            end
            directionsCVec = self.l_values;
            if nargout > 1
                timeVec = self.time_values;
            end
        end
        % 
        function [eaEllMat timeVec] = get_ea(self)
            if isempty(self)
                return;
            end
            eaEllMat = [];
            if nargout > 1
                timeVec = self.time_values;
            end
            m = size(self.ea_values, 2);
            n = size(self.time_values, 2);
            d = dimension(self);
            for i = 1:m
                QQ = self.ea_values{i};
                ee = [];
                for j = 1:n
                    q  = self.center_values(:, j);
                    Q  = (1 + self.relTol()) * reshape(QQ(:, j), d, d);
                    if min(eig(Q)) < (- self.absTol())
                        Q = self.absTol() * eye(d);
                    end
                    ee = [ee ellipsoid(q, Q)];
                end
                eaEllMat = [eaEllMat; ee];
            end
        end
        %
        function [iaEllMat timeVec] = get_ia(self)
            if isempty(self)
                return;
            end
            iaEllMat = [];
            if nargout > 1
                timeVec = self.time_values;
            end
            m = size(self.ia_values, 2);
            n = size(self.time_values, 2);
            d = dimension(self);
            for i = 1:m
                QQ = self.ia_values{i};
                ee = [];
                for j = 1:n
                    q  = self.center_values(:, j);
                    Q  = (1 - self.relTol()) * reshape(QQ(:, j), d, d);
                    Q  = real(Q);
                    if min(eig(Q)) < (- self.absTol())
                        Q = self.absTol() * eye(d);
                    end
                    ee = [ee ellipsoid(q, Q)];
                end
                iaEllMat = [iaEllMat; ee];
            end
        end
        %   
        function [goodCurvesCVec timeVec] = get_goodcurves(self)
            import elltool.conf.Properties;
            import modgen.common.throwerror;
            if isempty(self)
                if nargout > 1
                    timeVec = [];
                end
                return;
            end
            goodCurvesCVec  = [];
            if size(self.ea_values, 2) < size(self.ia_values, 2)
                QQ = self.ia_values;
            else
                QQ = self.ea_values;
            end
            if ~(isempty(self.projection_basis))
                if size(self.projection_basis, 2) < dimension(self.system)
                    throwerror(['GET_GOODCURVES: this function cannot ',...
                        'be used with projected reach sets.']);
                end
            end
            N  = size(QQ, 2);
            M  = size(self.time_values, 2);
            LL = get_directions(self);
            d  = dimension(self);
            if size(LL, 2) ~= N
                throwerror('GET_GOODCURVES: reach set object is malformed.');
            end
            for i = 1:N
                L  = LL{i};
                Q  = QQ{i};
                xx = [];
                for j = 1:M
                    E  = reshape(Q(:, j), d, d);
                    l  = L(:, j);
                    x  = (E * l)/realsqrt(l' * E * l) + self.center_values(:, j);
                    xx = [xx x];
                end
                goodCurvesCVec = [goodCurvesCVec {xx}];
            end
            if nargout > 1
                timeVec  = self.time_values;
            end
        end
        %
        function linSys = get_system(self)
            import elltool.conf.Properties;
            linSys = self.system;
        end
        %   
        function plot_ea(self, varargin)
            import elltool.conf.Properties;
            import elltool.logging.Log4jConfigurator;
            
            persistent logger;
            
            d  = dimension(self);
            N  = size(self.ea_values, 2);
            if (d < 2) || (d > 3)
                msg = sprintf('PLOT_EA: cannot plot reach set of dimension %d.', d);
                if d > 3
                    msg = sprintf('%s\nUse projection.', msg);
                end
                throwerror(msg);
            end
            if nargin > 1
                if isstruct(varargin{nargin - 1})
                    Options = varargin{nargin - 1};
                else
                    Options = [];
                end
            else
                Options = [];
            end
            if ~(isfield(Options, 'color'))
                Options.color = [0 0 1];
            end
            if ~(isfield(Options, 'shade'))
                Options.shade = 0.3;
            else
                Options.shade = Options.shade(1, 1);
                if Options.shade > 1
                    Options.shade = 1;
                end
                if Options.shade < 0
                    Options.shade = 0;
                end
            end
            if ~isfield(Options, 'width')
                Options.width = 2;
            else
                Options.width = Options.width(1, 1);
                if Options.width < 1
                    Options.width = 2;
                end
            end
            if ~isfield(Options, 'fill')
                Options.fill = 0;
            else
                Options.fill = Options.fill(1, 1);
                if Options.fill ~= 1
                    Options.fill = 0;
                end
            end
            if (nargin > 1) && ischar(varargin{1})
                Options.color = self.my_color_table(varargin{1});
            end
            E   = get_ea(self);
            clr = Options.color;
            if self.t0 > self.time_values(end)
                back = 'Backward reach set';
            else
                back = 'Reach set';
            end
            if Properties.getIsVerbose()
                if isempty(logger)
                    logger=Log4jConfigurator.getLogger();
                end
                logger.info('Plotting reach set external approximation...');
            end
            if d == 3
                EE  = getMove2Origin(E(:, end));
                EE  = EE';
                M   = self.nPlot3dPoints()/2;
                N   = M/2;
                psy = linspace(0, pi, N);
                phi = linspace(0, 2*pi, M);
                X   = [];
                L   = [];
                for i = 2:(N - 1)
                    arr = cos(psy(i))*ones(1, M);
                    L   = [L [cos(phi)*sin(psy(i)); sin(phi)*sin(psy(i)); arr]];
                end
                n = size(L, 2);
                m = size(EE, 2);
                for i = 1:n
                    l    = L(:, i);
                    mval = self.absTol();
                    for j = 1:m
                        if trace(EE(1, j)) > self.absTol()
                            Q = parameters(getInv(EE(1, j)));
                            v = l' * Q * l;
                            if v > mval
                                mval = v;
                            end
                        end
                    end
                    x = (l/realsqrt(mval)) + self.center_values(:, end);
                    X = [X x];
                end
                chll = convhulln(X');
                patch('Vertices', X', 'Faces', chll, ...
                    'FaceVertexCData', clr(ones(1, n), :), 'FaceColor', 'flat', ...
                    'FaceAlpha', Options.shade);
                shading interp;
                lighting phong;
                material('metal');
                view(3);
                if isDiscreteArr(self.system)
                    title(sprintf('%s at time step K = %d', back, self.time_values(end)));
                else
                    title(sprintf('%s at time T = %d', back, self.time_values(end)));
                end
                xlabel('x_1'); ylabel('x_2'); zlabel('x_3');
                return;
            end
            ih = ishold;
            if size(self.time_values, 2) == 1
                E   = getMove2Origin(E');
                M   = size(E, 2);
                N   = self.nPlot2dPoints;
                phi = linspace(0, 2*pi, N);
                L   = [cos(phi); sin(phi)];
                X   = [];
                for i = 1:N
                    l      = L(:, i);
                    [v, x] = rho(E, l);
                    idx    = find(isinternal((1+self.absTol())*E, x, 'i') > 0);
                    if ~isempty(idx)
                        x = x(:, idx(1, 1)) + self.center_values;
                        X = [X x];
                    end
                end
                if ~isempty(X)
                    X = [X X(:, 1)];
                    if Options.fill ~= 0
                        fill(X(1, :), X(2, :), Options.color);
                        hold on;
                    end
                    h = ell_plot(X);
                    hold on;
                    set(h, 'Color', Options.color, 'LineWidth', Options.width);
                    h = ell_plot(self.center_values, '.');
                    set(h, 'Color', Options.color);
                    if isa(self.system, 'elltool.linsys.LinSysDiscrete')
                        title(sprintf('%s at time step K = %d', back, self.time_values));
                    else
                        title(sprintf('%s at time T = %d', back, self.time_values));
                    end
                    xlabel('x_1'); ylabel('x_2');
                    if ih == 0
                        hold off;
                    end
                else
                    warning(['2D grid too sparse! Please, increase ',...
                        'parameter nPlot2dPoints(self.nPlot2dPoints(value))...']);
                end
                return;
            end
            [m, n] = size(E);
            s      = (1/2) * self.nPlot2dPoints();
            phi    = linspace(0, 2*pi, s);
            L      = [cos(phi); sin(phi)];
            if isa(self.system, 'elltool.linsys.LinSysDiscrete')
                for ii = 1:n
                    EE = getMove2Origin(E(:, ii));
                    EE = EE';
                    X  = [];
                    cnt = 0;
                    for i = 1:s
                        l = L(:, i);
                        [v, x] = rho(EE, l);
                        idx    = find(isinternal((1+self.absTol())*EE, x, 'i') > 0);
                        if ~isempty(idx)
                            x = x(:, idx(1, 1)) + self.center_values(:, ii);
                            X = [X x];
                        end
                    end
                    tt = self.time_values(ii);
                    if ~isempty(X)
                        X  = [X X(:, 1)];
                        tt = self.time_values(:, ii) * ones(1, size(X, 2));
                        X  = [tt; X];
                        if Options.fill ~= 0
                            fill3(X(1, :), X(2, :), X(3, :), Options.color);
                            hold on;
                        end
                        h = ell_plot(X);
                        set(h, 'Color', Options.color, 'LineWidth', Options.width);
                        hold on;
                    else
                        warning(['2D grid too sparse! Please, increase ',...
                            'parameter nPlot2dPoints(self.nPlot2dPoints(value))...']);
                    end
                    h = ell_plot([tt(1, 1);
                        self.center_values(:, ii)], '.');
                    hold on;
                    set(h, 'Color', clr);
                end
                xlabel('k');
                if self.time_values(1) > self.time_values(end)
                    title('Discrete-time backward reach tube');
                else
                    title('Discrete-time reach tube');
                end
            else
                F = ell_triag_facets(s, size(self.time_values, 2));
                V = [];
                for ii = 1:n
                    EE = getMove2Origin(getInv(E(:, ii)));
                    EE = EE';
                    X  = [];
                    for i = 1:s
                        l    = L(:, i);
                        mval = self.absTol();
                        for j = 1:m
                            if 1
                                Q  = parameters(EE(1, j));
                                v  = l' * Q * l;
                                if v > mval
                                    mval = v;
                                end
                            end
                        end
                        x = (l/realsqrt(mval)) + self.center_values(:, ii);
                        X = [X x];
                    end
                    tt = self.time_values(ii) * ones(1, s);
                    X  = [tt; X];
                    V  = [V X];
                end
                vs = size(V, 2);
                patch('Vertices', V', 'Faces', F, ...
                    'FaceVertexCData', clr(ones(1, vs), :), 'FaceColor', 'flat', ...
                    'FaceAlpha', Options.shade);
                hold on;
                shading interp;
                lighting phong;
                material('metal');
                view(3);
                xlabel('t');
                if self.time_values(1) > self.time_values(end)
                    title('Backward reach tube');
                else
                    title('Reach tube');
                end
            end
            ylabel('x_1');
            zlabel('x_2');
            %
            if ih == 0
                hold off;
            end
        end
        %
        function plot_ia(self, varargin)
            import elltool.conf.Properties;
            import elltool.logging.Log4jConfigurator;
            
            persistent logger;
            
            d  = dimension(self);
            N  = size(self.ia_values, 2);
            if (d < 2) || (d > 3)
                msg = sprintf('PLOT_IA: cannot plot reach set of dimension %d.', d);
                if d > 3
                    msg = sprintf('%s\nUse projection.', msg);
                end
                throwerror(msg);
            end
            if nargin > 1
                if isstruct(varargin{nargin - 1})
                    Options = varargin{nargin - 1};
                else
                    Options = [];
                end
            else
                Options = [];
            end
            if ~(isfield(Options, 'color'))
                Options.color = [0 1 0];
            end
            if ~(isfield(Options, 'shade'))
                Options.shade = 0.3;
            else
                Options.shade = Options.shade(1, 1);
                if Options.shade > 1
                    Options.shade = 1;
                end
                if Options.shade < 0
                    Options.shade = 0;
                end
            end
            if ~isfield(Options, 'width')
                Options.width = 2;
            else
                Options.width = Options.width(1, 1);
                if Options.width < 1
                    Options.width = 2;
                end
            end
            if ~isfield(Options, 'fill')
                Options.fill = 0;
            else
                Options.fill = Options.fill(1, 1);
                if Options.fill ~= 1
                    Options.fill = 0;
                end
            end
            if (nargin > 1) && ischar(varargin{1})
                Options.color = self.my_color_table(varargin{1});
            end
            E   = get_ia(self);
            clr = Options.color;
            if self.t0 > self.time_values(end)
                back = 'Backward reach set';
            else
                back = 'Reach set';
            end
            if Properties.getIsVerbose()
                if isempty(logger)
                    logger=Log4jConfigurator.getLogger();
                end
                logger.info('Plotting reach set internal approximation...');
            end
            if d == 3
                EE         = getMove2Origin(getInv(E(:, end)));
                EE         = EE';
                m          = size(EE, 2);
                M          = self.nPlot3dPoints/2;
                N          = M/2;
                psy        = linspace(-pi/2, pi/2, N);
                phi        = linspace(0, 2*pi, M);
                [phi, psy] = meshgrid(phi, psy);
                x          = ones(3, N, M);
                X          = ones(N, M);
                Y          = ones(N, M);
                Z          = ones(N, M);
                x(1, :, :) = cos(psy).*cos(phi);
                x(2, :, :) = cos(psy).*sin(phi);
                x(3, :, :) = sin(psy);
                for i = 1:N
                    for j = 1:M
                        mval = inf;
                        l    = [x(1, i, j); x(2, i, j); x(3, i, j)];
                        for ii = 1:m
                            Q = parameters(EE(1, ii));
                            v = l' * Q * l;
                            if v < mval
                                mval = v;
                            end
                        end
                        xx      = (l/realsqrt(mval)) + self.center_values(:, end);
                        X(i, j) = xx(1, 1);
                        Y(i, j) = xx(2, 1);
                        Z(i, j) = xx(3, 1);
                    end
                end
                patch(surf2patch(X, Y, Z), ...
                    'FaceVertexCData', clr(ones(1, M*N), :), 'FaceColor', 'flat', ...
                    'FaceAlpha', Options.shade);
                shading interp;
                lighting phong;
                material('metal');
                view(3);
                if isa(self.system, 'elltool.linsys.LinSysDiscrete')
                    title(sprintf('%s at time step K = %d', back, self.time_values(end)));
                else
                    title(sprintf('%s at time T = %d', back, self.time_values(end)));
                end
                xlabel('x_1'); ylabel('x_2'); zlabel('x_3');
                return;
            end
            ih = ishold;
            if size(self.time_values, 2) == 1
                E   = getMove2Origin(E');
                M   = size(E, 2);
                N   = self.nPlot2dPoints;
                phi = linspace(0, 2*pi, N);
                L   = [cos(phi); sin(phi)];
                X   = [];
                for i = 1:N
                    l    = L(:, i);
                    mval =self.absTol;
                    mQ   = [];
                    for j = 1:M
                        Q = parameters(E(1, j));
                        if isempty(mQ)
                            mQ = Q;
                        end
                        v = l' * Q * l;
                        if v > mval
                            mval = v;
                            mQ   = Q;
                        end
                    end
                    x = (mQ*l/realsqrt(mval)) + self.center_values;
                    X = [X x];
                end
                if Options.fill ~= 0
                    fill(X(1, :), X(2, :), Options.color);
                    hold on;
                end
                h = ell_plot(X);
                hold on;
                set(h, 'Color', Options.color, 'LineWidth', Options.width);
                h = ell_plot(self.center_values, '.');
                set(h, 'Color', Options.color);
                if isa(self.system, 'elltool.linsys.LinSysDiscrete')
                    title(sprintf('%s at time step K = %d', back, self.time_values));
                else
                    title(sprintf('%s at time T = %d', back, self.time_values));
                end
                xlabel('x_1'); ylabel('x_2');
                if ih == 0
                    hold off;
                end
                return;
            end
            [m, n] = size(E);
            s      = (1/2) * self.nPlot2dPoints;
            phi    = linspace(0, 2*pi, s);
            L      = [cos(phi); sin(phi)];
            if isa(self.system, 'elltool.linsys.LinSysDiscrete')
                for ii = 1:n
                    EE = getMove2Origin(E(:, ii));
                    EE = EE';
                    X  = [];
                    for i = 1:s
                        l    = L(:, i);
                        mval = self.absTol;
                        mQ   = [];
                        for j = 1:m
                            Q  = parameters(EE(1, j));
                            if isempty(mQ)
                                mQ = Q;
                            end
                            v  = l' * Q * l;
                            if v > mval
                                mval = v;
                                mQ   = Q;
                            end
                        end
                        x = (mQ*l/realsqrt(mval)) + self.center_values(:, ii);
                        X = [X x];
                    end
                    tt = self.time_values(ii) * ones(1, s);
                    X  = [tt; X];
                    if Options.fill ~= 0
                        fill3(X(1, :), X(2, :), X(3, :), Options.color);
                        hold on;
                    end
                    h = ell_plot(X);
                    set(h, 'Color', Options.color, 'LineWidth', Options.width);
                    hold on;
                    h = ell_plot([tt(1, 1); self.center_values(:, ii)], '.');
                    set(h, 'Color', clr);
                end
                xlabel('k');
                if self.time_values(1) > self.time_values(end)
                    title('Discrete-time backward reach tube');
                else
                    title('Discrete-time reach tube');
                end
            else
                F = ell_triag_facets(s, size(self.time_values, 2));
                V = [];
                for ii = 1:n
                    EE = getMove2Origin(E(:, ii));
                    EE = EE';
                    X  = [];
                    for i = 1:s
                        l    = L(:, i);
                        mval = self.absTol;
                        mQ   = [];
                        for j = 1:m
                            Q  = parameters(EE(1, j));
                            if isempty(mQ)
                                mQ = Q;
                            end
                            v  = l' * Q * l;
                            if v > mval
                                mval = v;
                                mQ   = Q;
                            end
                        end
                        x = (mQ*l/realsqrt(mval)) + self.center_values(:, ii);
                        X = [X x];
                    end
                    tt = self.time_values(ii) * ones(1, s);
                    X  = [tt; X];
                    V  = [V X];
                end
                vs = size(V, 2);
                patch('Vertices', V', 'Faces', F, ...
                    'FaceVertexCData', clr(ones(1, vs), :), 'FaceColor', 'flat', ...
                    'FaceAlpha', Options.shade);
                hold on;
                shading interp;
                lighting phong;
                material('metal');
                view(3);
                xlabel('t');
                if self.time_values(1) > self.time_values(end)
                    title('Backward reach tube');
                else
                    title('Reach tube');
                end
            end
            ylabel('x_1');
            zlabel('x_2');
            if ih == 0
                hold off;
            end
        end
        %
        function projObj = projection(self, projMat)
            import elltool.conf.Properties;
            import modgen.common.throwerror;
            if ~(isa(projMat, 'double'))
                throwerror(['PROJECTION: second input argument ',...
                    'must be matrix of basis vectors.']);
            end
            projObj  = self.getCopy();
            if isempty(self)
                return;
            end
            d      = dimension(self);
            [m, n] = size(projMat);
            if m ~= d
                throwerror(['PROJECTION: dimensions of the reach set ',...
                    'and the basis vectors do not match.']);
            end
            EA = [];
            if ~(isempty(self.ea_values))
                EA = projection(get_ea(self), projMat);
            end
            IA = [];
            if ~(isempty(self.ia_values))
                IA = projection(get_ia(self), projMat);
            end
            % normalize the basis vectors
            for i = 1:n
                BB(:, i) = projMat(:, i)/norm(projMat(:, i));
            end
            projObj.center_values    = BB' * self.center_values;
            projObj.projection_basis = BB;
            [m, k] = size(EA);
            QQ     = [];
            for i = 1:m
                Q = [];
                for j = 1:k
                    E = parameters(EA(i, j));
                    Q = [Q reshape(E, n*n, 1)];
                end
                QQ = [QQ {Q}];
            end
            projObj.ea_values = QQ;
            [m, k] = size(IA);
            QQ     = [];
            for i = 1:m
                Q = [];
                for j = 1:k
                    E = parameters(IA(i, j));
                    Q = [Q reshape(E, n*n, 1)];
                end
                QQ = [QQ {Q}];
            end
            projObj.ia_values = QQ;
            projObj.isProj = true;
        end
        % 
        function newReachObj = evolve(self, newEndTime, linSys)
            import elltool.conf.Properties;
            import modgen.common.throwerror;
            import elltool.logging.Log4jConfigurator;
            import gras.la.sqrtmpos;
            import gras.la.regposdefmat;
            %
            persistent logger;
            if nargin < 2
                throwerror('insufficient number of input arguments.');
            end
            if isprojection(self)
                throwerror('cannot compute the reach set for projection.');
            end
            newReachObj = self.getCopy();
            if nargin < 3
                linSys = newReachObj.system;
            end
            if isempty(linSys)
                return;
            end
            [d1, du, dy, dd] = dimension(linSys);
            if d1 ~= dimension(self.system)
                throwerror(['dimensions of the old and ',...
                    'new linear systems do not match.']);
            end
            newReachObj.system = linSys;
            newEndTime = [newReachObj.time_values(end) newEndTime(1, 1)];
            if (newReachObj.t0 > newEndTime(1)) &&...
                    (newEndTime(1) < newEndTime(2))
                throwerror('reach set must evolve backward in time.');
            end
            if (newReachObj.t0 < newEndTime(1)) &&...
                    (newEndTime(1) > newEndTime(2))
                throwerror('reach set must evolve forward in time.');
            end
            Options = [];
            Options.approximation = 2;
            if isempty(get_ea(self))
                Options.approximation = 1;
            elseif isempty(get_ia(self))
                Options.approximation = 0;
            end
            Options.minmax = newReachObj.minmax;
            if isempty(self.calc_data)
                Options.save_all = 0;
            else
                Options.save_all = 1;
            end
            % Create time grid
            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                newEndTime(1) = round(newEndTime(1));
                newEndTime(2) = round(newEndTime(2));
                if newEndTime(1) > newEndTime(2)
                    newReachObj.time_values = fliplr(newEndTime(2):newEndTime(1));
                else
                    newReachObj.time_values = newEndTime(1):newEndTime(2);
                end
            else
                newReachObj.time_values =...
                    linspace(newEndTime(1), newEndTime(2), self.nTimeGridPoints());
            end
            if newReachObj.time_values(1) > newReachObj.time_values(end)
                back = 1;
                tvals = - newReachObj.time_values;
            else
                back = 0;
                tvals = newReachObj.time_values;
            end
            www = warning;
            warning off;
            newReachObj.ea_values          = [];
            newReachObj.ia_values          = [];
            newReachObj.l_values           = [];
            newReachObj.initial_directions = [];
            newReachObj.center_values      = [];
            newReachObj.calc_data          = [];
            %%% Get new initial directions.
            LL = get_directions(self);
            nn = size(LL, 2);
            for i = 1:nn
                L = LL{i};
                newReachObj.initial_directions =...
                    [newReachObj.initial_directions L(:, end)];
            end
            %%% Perform matrix, control, disturbance and
            %%% noise evaluations. Create splines if needed.
            if Properties.getIsVerbose()
                if isempty(logger)
                    logger=Log4jConfigurator.getLogger();
                end
                logger.info('Performing preliminary function evaluations...');
            end
            mydata.A     = [];
            mydata.Bp    = [];
            mydata.BPB   = [];
            mydata.BPBsr = [];
            mydata.Gq    = [];
            mydata.GQG   = [];
            mydata.GQGsr = [];
            mydata.C     = [];
            mydata.w     = [];
            mydata.W     = [];
            mydata.Phi   = [];
            mydata.Phinv = [];
            mydata.delta = [];
            mydata.mu    = [];
            % matrix A
            aMat = linSys.getAtMat();
            if iscell(aMat)
                AA = [];
                DD = [];
                AC = [];
                for i = 1:size(newReachObj.time_values, 2)
                    A = self.matrix_eval(aMat, newReachObj.time_values(i));
                    AC = [AC reshape(A, d1*d1, 1)];
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete') && (rank(A) < d1)
                        A = regposdefmat(A, self.absTol);
                        DD = [DD 1];
                    elseif isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        DD = [DD 0];
                    end
                    AA = [AA reshape(A, d1*d1, 1)];
                end
                if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                    mydata.A     = AA;
                    mydata.delta = DD;
                else
                    mydata.A = spline(newReachObj.time_values, AA);
                end
            else
                AC = aMat;
                if isa(linSys, 'elltool.linsys.LinSysDiscrete') ...
                        && (rank(aMat) < d1)
                    mydata.A     = regposdefmat(aMat, self.absTol);
                    mydata.delta = 1;
                elseif isa(linSys, 'elltool.linsys.LinSysDiscrete')
                    mydata.A     = aMat;
                    mydata.delta = 0;
                else
                    mydata.A     = aMat;
                end
            end
            % matrix B
            bMat = linSys.getBtMat();
            if iscell(bMat)
                BB = [];
                for i = 1:size(newReachObj.time_values, 2)
                    B  = self.matrix_eval(bMat, newReachObj.time_values(i));
                    BB = [BB reshape(B, d1*du, 1)];
                end
            else
                BB = reshape(bMat, d1*du, 1);
            end
            % matrix G
            gMat = linSys.getGtMat();
            GG = [];
            if iscell(gMat)
                for i = 1:size(newReachObj.time_values, 2)
                    B  = self.matrix_eval(gMat, newReachObj.time_values(i));
                    GG = [GG reshape(B, d1*dd, 1)];
                end
            elseif ~(isempty(gMat))
                GG = reshape(gMat, d1*dd, 1);
            end
            % matrix C
            cMat = linSys.getCtMat();
            if iscell(cMat)
                CC = [];
                for i = 1:size(newReachObj.time_values, 2)
                    C  = self.matrix_eval(cMat, newReachObj.time_values(i));
                    CC = [CC reshape(C, d1*dy, 1)];
                end
                if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                    mydata.C = CC;
                else
                    mydata.C = spline(newReachObj.time_values, CC);
                end
            else
                mydata.C = cMat;
            end
            % expressions Bp and BPB'
            uEll = linSys.getUBoundsEll();
            if isa(uEll, 'ellipsoid')
                [p, P] = parameters(uEll);
                if size(BB, 2) == 1
                    B            = reshape(BB, d1, du);
                    mydata.Bp    = B * p;
                    mydata.BPB   = B * P * B';
                    mydata.BPBsr = sqrtmpos(mydata.BPB, self.absTol);
                    mydata.BPBsr = 0.5*(mydata.BPBsr + (mydata.BPBsr)');
                else
                    Bp    = [];
                    BPB   = [];
                    BPBsr = [];
                    for i = 1:size(newReachObj.time_values, 2)
                        B     = reshape(BB(:, i), d1, du);
                        Bp    = [Bp B*p];
                        B     = B * P * B';
                        BPB   = [BPB reshape(B, d1*d1, 1)];
                        B     = sqrtmpos(B, self.absTol);
                        B     = 0.5*(B + B');
                        BPBsr = [BPBsr reshape(B, d1*d1, 1)];
                    end
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        mydata.Bp    = Bp;
                        mydata.BPB   = BPB;
                        mydata.BPBsr = BPBsr;
                    else
                        mydata.Bp    = spline(newReachObj.time_values, Bp);
                        mydata.BPB   = spline(newReachObj.time_values, BPB);
                        mydata.BPBsr = spline(newReachObj.time_values, BPBsr);
                    end
                end
            elseif isa(uEll, 'double')
                p  = uEll;
                if size(BB, 2) == 1
                    mydata.Bp = reshape(BB, d1, du) * p;
                else
                    Bp = [];
                    for i = 1:size(newReachObj.time_values, 2)
                        B  = reshape(BB(:, i), d1, du);
                        Bp = [Bp B*p];
                    end
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        mydata.Bp = Bp;
                    else
                        mydata.Bp = spline(newReachObj.time_values, Bp);
                    end
                end
            elseif iscell(uEll)
                p  = uEll;
                Bp = [];
                for i = 1:size(newReachObj.time_values, 2)
                    if size(BB, 2) == 1
                        B = reshape(BB, d1, du);
                    else
                        B = reshape(BB(:, i), d1, du);
                    end
                    Bp = [Bp B*self.matrix_eval(p, newReachObj.time_values(i))];
                end
                if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                    mydata.Bp = Bp;
                else
                    mydata.Bp = spline(newReachObj.time_values, Bp);
                end
            elseif isstruct(uEll)
                if size(BB, 2) == 1
                    B = reshape(BB, d1, du);
                    if iscell(uEll.center) & iscell(uEll.shape)
                        Bp    = [];
                        BPB   = [];
                        BPBsr = [];
                        for i = 1:size(newReachObj.time_values, 2)
                            p = self.matrix_eval(uEll.center,...
                                newReachObj.time_values(i));
                            P = self.matrix_eval(uEll.shape,...
                                newReachObj.time_values(i));
                            if ~gras.la.ismatposdef(P,self.absTol,false)
                                throwerror('wrongMat',['shape matrix of ',...
                                    'ellipsoidal control bounds ',...
                                    'must be positive definite.']);
                            end
                            Bp    = [Bp B*p];
                            P     = B * P * B';
                            BPB   = [BPB reshape(P, d1*d1, 1)];
                            P     = sqrtmpos(P, self.absTol);
                            P     = 0.5*(P + P');
                            BPBsr = [BPBsr reshape(P, d1*d1, 1)];
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.Bp    = Bp;
                            mydata.BPB   = BPB;
                            mydata.BPBsr = BPBsr;
                        else
                            mydata.Bp    = spline(newReachObj.time_values, Bp);
                            mydata.BPB   = spline(newReachObj.time_values, BPB);
                            mydata.BPBsr = spline(newReachObj.time_values, BPBsr);
                        end
                    elseif iscell(uEll.center)
                        Bp  = [];
                        for i = 1:size(newReachObj.time_values, 2)
                            p  = self.matrix_eval(uEll.center,...
                                newReachObj.time_values(i));
                            Bp = [Bp B*p];
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.Bp  = Bp;
                        else
                            mydata.Bp  = spline(newReachObj.time_values, Bp);
                        end
                        mydata.BPB   = B * uEll.shape * B';
                        mydata.BPBsr = sqrtmpos(mydata.BPB, self.absTol);
                        mydata.BPBsr = 0.5*(mydata.BPBsr + (mydata.BPBsr)');
                    else
                        BPB   = [];
                        BPBsr = [];
                        for i = 1:size(newReachObj.time_values, 2)
                            P = self.matrix_eval(uEll.shape,...
                                newReachObj.time_values(i));
                            if ~gras.la.ismatposdef(P,self.absTol,false)
                                throwerror('wrongMat',['shape matrix of ',...
                                    'ellipsoidal control bounds must ',...
                                    'be positive definite.']);
                            end
                            P     = B * P * B';
                            BPB   = [BPB reshape(P, d1*d1, 1)];
                            P     = sqrtmpos(P, self.absTol);
                            P     = 0.5*(P + P');
                            BPBsr = [BPBsr reshape(P, d1*d1, 1)];
                        end
                        mydata.Bp = B * uEll.center;
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.BPB   = BPB;
                            mydata.BPBsr = BPBsr;
                        else
                            mydata.BPB   = spline(newReachObj.time_values, BPB);
                            mydata.BPBsr = spline(newReachObj.time_values, BPBsr);
                        end
                    end
                else
                    Bp    = [];
                    BPB   = [];
                    BPBsr = [];
                    for i = 1:size(newReachObj.time_values, 2)
                        B = reshape(BB(:, i), d1, du);
                        if iscell(uEll.center)
                            p = self.matrix_eval(uEll.center,...
                                newReachObj.time_values(i));
                        else
                            p = uEll.center;
                        end
                        if iscell(uEll.shape)
                            P = self.matrix_eval(uEll.shape,...
                                newReachObj.time_values(i));
                            if ~gras.la.ismatposdef(P,self.absTol,false)
                                throwerror('wrongMat',['shape matrix of ',...
                                    'ellipsoidal control bounds ',...
                                    'must be positive definite.']);
                            end
                        else
                            P = uEll.shape;
                        end
                        Bp    = [Bp B*p];
                        P     = B * P * B';
                        BPB   = [BPB reshape(P, d1*d1, 1)];
                        P     = sqrtmpos(P, self.absTol);
                        P     = 0.5*(P + P');
                        BPBsr = [BPBsr reshape(P, d1*d1, 1)];
                    end
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        mydata.Bp    = Bp;
                        mydata.BPB   = BPB;
                        mydata.BPBsr = BPBsr;
                    else
                        mydata.Bp    = spline(newReachObj.time_values, Bp);
                        mydata.BPB   = spline(newReachObj.time_values, BPB);
                        mydata.BPBsr = spline(newReachObj.time_values, BPBsr);
                    end
                end
            end
            % expressions Gq and GQG'
            vEll = linSys.getDistBoundsEll();
            if ~(isempty(GG))
                if isa(vEll, 'ellipsoid')
                    [q, Q] = parameters(vEll);
                    if size(GG, 2) == 1
                        G = reshape(GG, d1, dd);
                        mydata.Gq = G * q;
                        mydata.GQG = G * Q * G';
                        mydata.GQGsr = sqrtmpos(mydata.GQG, self.absTol);
                        mydata.GQGsr = 0.5*(mydata.GQGsr + (mydata.GQGsr)');
                    else
                        Gq = [];
                        GQG = [];
                        GQGsr = [];
                        for i = 1:size(newReachObj.time_values, 2)
                            G     = reshape(GG(:, i), d1, dd);
                            Gq    = [Gq G*q];
                            G     = G * Q * G';
                            GQG   = [GQG reshape(G, d1*d1, 1)];
                            G     = sqrtmpos(G, self.absTol);
                            G     = 0.5*(G + G');
                            GQGsr = [GQGsr reshape(G, d1*d1, 1)];
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.Gq    = Gq;
                            mydata.GQG   = GQG;
                            mydata.GQGsr = GQGsr;
                        else
                            mydata.Gq    = spline(newReachObj.time_values, Gq);
                            mydata.GQG   = spline(newReachObj.time_values, GQG);
                            mydata.GQGsr = spline(newReachObj.time_values, GQGsr);
                        end
                    end
                elseif isa(vEll, 'double')
                    q  = vEll;
                    if size(GG, 2) == 1
                        mydata.Gq = reshape(GG, d1, dd) * q;
                    else
                        Gq = [];
                        for i = 1:size(newReachObj.time_values, 2)
                            G  = reshape(GG(:, i), d1, dd);
                            Gq = [Gq G*q];
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.Gq = Gq;
                        else
                            mydata.Gq = spline(newReachObj.time_values, Gq);
                        end
                    end
                elseif iscell(vEll)
                    q  = vEll;
                    Gq = [];
                    for i = 1:size(newReachObj.time_values, 2)
                        if size(GG, 2) == 1
                            G = reshape(GG, d1, dd);
                        else
                            G = reshape(GG(:, i), d1, dd);
                        end
                        Gq = [Gq G*self.matrix_eval(q, ...
                            newReachObj.time_values(i), ...
                            isa(linSys, 'elltool.linsys.LinSysDiscrete'))];
                    end
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        mydata.Gq = Gq;
                    else
                        mydata.Gq = spline(newReachObj.time_values, Gq);
                    end
                elseif isstruct(vEll)
                    if size(GG, 2) == 1
                        G = reshape(GG, d1, dd);
                        if iscell(vEll.center) &&...
                                iscell(vEll.shape)
                            Gq    = [];
                            GQG   = [];
                            GQGsr = [];
                            for i = 1:size(newReachObj.time_values, 2)
                                q = self.matrix_eval(...
                                    vEll.center,...
                                    newReachObj.time_values(i));
                                Q = self.matrix_eval(...
                                    vEll.shape,...
                                    newReachObj.time_values(i));
                                if ~gras.la.ismatposdef(Q,self.absTol,false)
                                    throwerror('wrongMat',['shape matrix of ',...
                                        'ellipsoidal disturbance ',...
                                        'bounds must be positive definite.']);
                                end
                                Gq    = [Gq G*q];
                                Q     = G * Q * G';
                                GQG   = [GQG reshape(Q, d1*d1, 1)];
                                Q     = sqrtmpos(Q, self.absTol);
                                Q     = 0.5*(Q + Q');
                                GQGsr = [GQGsr reshape(Q, d1*d1, 1)];
                            end
                            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                                mydata.Gq    = Gq;
                                mydata.GQG   = GQG;
                                mydata.GQGsr = GQGsr;
                            else
                                mydata.Gq    = spline(newReachObj.time_values, Gq);
                                mydata.GQG   = spline(newReachObj.time_values, GQG);
                                mydata.GQGsr = spline(newReachObj.time_values, GQGsr);
                            end
                        elseif iscell(vEll.center)
                            Gq  = [];
                            for i = 1:size(newReachObj.time_values, 2)
                                q  = self.matrix_eval(...
                                    vEll.center,...
                                    newReachObj.time_values(i));
                                Gq = [Gq G*q];
                            end
                            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                                mydata.Gq  = Gq;
                            else
                                mydata.Gq  = spline(newReachObj.time_values, Gq);
                            end
                            mydata.GQG   = G * vEll.shape * G';
                            mydata.GQGsr = sqrtmpos(mydata.GQG, self.absTol);
                            mydata.GQGsr = 0.5*(mydata.GQGsr + (mydata.GQGsr)');
                        else
                            GQG   = [];
                            GQGsr = [];
                            for i = 1:size(newReachObj.time_values, 2)
                                Q = self.matrix_eval(...
                                    vEll.shape,...
                                    newReachObj.time_values(i));
                                if ~gras.la.ismatposdef(Q,self.absTol,false)
                                    throwerror('wrongMat',['shape matrix of ',...
                                        'ellipsoidal disturbance bounds ',...
                                        'must be positive definite.']);
                                end
                                Q     = G * Q * G';
                                GQG   = [GQG reshape(Q, d1*d1, 1)];
                                Q     = sqrtmpos(Q, self.absTol);
                                Q     = 0.5*(Q + Q');
                                GQGsr = [GQGsr reshape(Q, d1*d1, 1)];
                            end
                            mydata.Gq  = G * vEll.center;
                            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                                mydata.GQG   = GQG;
                                mydata.GQGsr = GQGsr;
                            else
                                mydata.GQG   = spline(newReachObj.time_values, GQG);
                                mydata.GQGsr = spline(newReachObj.time_values, GQGsr);
                            end
                        end
                    else
                        Gq    = [];
                        GQG   = [];
                        GQGsr = [];
                        for i = 1:size(newReachObj.time_values, 2)
                            G = reshape(GG(:, i), d1, dd);
                            if iscell(vEll.center)
                                q = self.matrix_eval(...
                                    vEll.center,...
                                    newReachObj.time_values(i));
                            else
                                q = vEll.center;
                            end
                            if iscell(vEll.shape)
                                Q = self.matrix_eval(...
                                    vEll.shape,...
                                    newReachObj.time_values(i));
                                if ~gras.la.ismatposdef(Q,self.absTol,false)
                                    throwerror('wrongMat',['shape matrix of ',...
                                        'ellipsoidal disturbance bounds ',...
                                        'must be positive definite.']);
                                end
                            else
                                Q = vEll.shape;
                            end
                            Gq  = [Gq G*q];
                            Q     = G * Q * G';
                            GQG   = [GQG reshape(Q, d1*d1, 1)];
                            Q     = sqrtmpos(Q, self.absTol);
                            Q     = 0.5*(Q + Q');
                            GQGsr = [GQGsr reshape(Q, d1*d1, 1)];
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.Gq    = Gq;
                            mydata.GQG   = GQG;
                            mydata.GQGsr = GQGsr;
                        else
                            mydata.Gq    = spline(newReachObj.time_values, Gq);
                            mydata.GQG   = spline(newReachObj.time_values, GQG);
                            mydata.GQGsr = spline(newReachObj.time_values, GQGsr);
                        end
                    end
                end
            end
            % expressions w and W
            noiseEll = linSys.getNoiseBoundsEll();
            if ~(isempty(noiseEll))
                if isa(noiseEll, 'ellipsoid')
                    [w, W]   = parameters(noiseEll);
                    mydata.w = w;
                    mydata.W = W;
                elseif isa(noiseEll, 'double')
                    mydata.w = noiseEll;
                elseif iscell(noiseEll)
                    w = [];
                    for i = 1:size(newReachObj.time_values, 2)
                        w = [w self.matrix_eval(noiseEll.center,...
                            newReachObj.time_values(i))];
                    end
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        mydata.w = w;
                    else
                        mydata.w = spline(newReachObj.time_values, w);
                    end
                elseif isstruct(noiseEll)
                    if iscell(noiseEll.center) && iscell(noiseEll.shape)
                        w = [];
                        W = [];
                        for i = 1:size(newReachObj.time_values, 2)
                            w  = [w self.matrix_eval(noiseEll.center,...
                                newReachObj.time_values(i))];
                            ww = self.matrix_eval(noiseEll.shape,...
                                newReachObj.time_values(i));
                            if ~gras.la.ismatposdef(ww,self.absTol,false)
                                throwerror('wrongMat',['shape matrix of ',...
                                    'ellipsoidal noise bounds ',...
                                    'must be positive definite.']);
                            end
                            W  = [W reshape(ww, dy*dy, 1)];
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.w = w;
                            mydata.W = W;
                        else
                            mydata.w = spline(newReachObj.time_values, w);
                            mydata.W = spline(newReachObj.time_values, W);
                        end
                    elseif iscell(noiseEll.center)
                        w = [];
                        for i = 1:size(newReachObj.time_values, 2)
                            w = [w self.matrix_eval(noiseEll.center,...
                                newReachObj.time_values(i))];
                        end
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.w = w;
                        else
                            mydata.w = spline(newReachObj.time_values, w);
                        end
                        mydata.W = noiseEll.shape;
                    else
                        W = [];
                        for i = 1:size(newReachObj.time_values, 2)
                            ww = self.matrix_eval(noiseEll.shape,...
                                newReachObj.time_values(i));
                            if ~gras.la.ismatposdef(ww,self.absTol,false)
                                throwerror('wrongMat',['shape matrix of ',...
                                    'ellipsoidal noise bounds ',...
                                    'must be positive definite.']);
                            end
                            W  = [W reshape(ww, dy*dy, 1)];
                        end
                        mydata.w = noiseEll.center;
                        if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                            mydata.W = W;
                        else
                            mydata.W = spline(newReachObj.time_values, W);
                        end
                    end
                end
            end
            clear A B C AA BB CC DD Bp BPB Gq GQG p P q Q w W ww;
            %%% Compute state transition matrix.
            if Properties.getIsVerbose()
                if isempty(logger)
                    logger=Log4jConfigurator.getLogger();
                end
                logger.info('Computing state transition matrix...');
            end
            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                mydata.Phi   = [];
                mydata.Phinv = [];
            else
                if isa(mydata.A, 'double')
                    t0    = newReachObj.time_values(1);
                    Phi   = [];
                    Phinv = [];
                    for i = 1:size(newReachObj.time_values, 2)
                        P = expm(mydata.A * abs(newReachObj.time_values(i) - t0));
                        PP    = ell_inv(P);
                        Phi   = [Phi reshape(P, d1*d1, 1)];
                        Phinv = [Phinv reshape(PP, d1*d1, 1)];
                    end
                    mydata.Phi   = spline(newReachObj.time_values, Phi);
                    mydata.Phinv = spline(newReachObj.time_values, Phinv);
                else
                    I0        = reshape(eye(d1), d1*d1, 1);
                    [tt, Phi] = ell_ode_solver(@ell_stm_ode,...
                        tvals, I0, mydata, d1, back, self.absTol);
                    Phi       = Phi';
                    Phinv     = [];
                    for i = 1:size(newReachObj.time_values, 2)
                        Phinv = [Phinv reshape(ell_inv(reshape(...
                            Phi(:, i), d1, d1)), d1*d1, 1)];
                    end
                    mydata.Phi   = spline(newReachObj.time_values, Phi);
                    mydata.Phinv = spline(newReachObj.time_values, Phinv);
                end
            end
            clear Phi Phinv P PP t0 I0;
            %%% Compute the center of the self set.
            if Properties.getIsVerbose()
                if isempty(logger)
                    logger=Log4jConfigurator.getLogger();
                end
                logger.info('Computing the trajectory of the reach set center...');
            end
            x0 = self.center_values(:, end);
            if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                xx = x0;
                x  = x0;
                for i = 1:(size(newReachObj.time_values, 2) - 1)
                    Bp = ell_value_extract(mydata.Bp, i+back, [d1 1]);
                    if ~(isempty(mydata.Gq))
                        Gq = ell_value_extract(mydata.Gq, i+back, [d1 1]);
                    else
                        Gq = zeros(d1, 1);
                    end
                    if back > 0
                        A = ell_value_extract(mydata.A, i+back, [d1 d1]);
                        x = ell_inv(A)*(x - Bp - Gq);
                    else
                        A = ell_value_extract(AC, i, [d1 d1]);
                        x = A*x + Bp + Gq;
                    end
                    xx = [xx x];
                end
            else
                [tt, xx] = ell_ode_solver(@ell_center_ode,...
                    tvals, x0, mydata, d1, back, self.absTol);
                xx       = xx';
            end
            newReachObj.center_values = xx;
            clear A AC xx;
            %%% Compute external shape matrices.
            if (Options.approximation ~= 1)
                if Properties.getIsVerbose()
                    if isempty(logger)
                        logger=Log4jConfigurator.getLogger();
                    end
                    logger.info('Computing external shape matrices...');
                end
                LL = [];
                QQ = [];
                N  = size(self.ea_values, 2);
                for ii = 1:N
                    EM = self.ea_values{ii};
                    Q0 = EM(:, end);
                    l0 = newReachObj.initial_directions(:, ii);
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        if hasdisturbance(linSys)
                            [Q, L] = self.eedist_de(size(tvals, 2),...
                                Q0, l0, mydata, d1, back,...
                                Options.minmax, newReachObj.absTol);
                        elseif ~(isempty(mydata.BPB))
                            [Q, L] = self.eesm_de(size(tvals, 2),...
                                Q0, l0, mydata, d1, back,newReachObj.absTol);
                        else
                            Q = [];
                            L = [];
                        end
                        LL = [LL {L}];
                    else
                        if hasdisturbance(linSys)
                            [tt, Q] = ell_ode_solver(@ell_eedist_ode,...
                                tvals, Q0, l0, mydata, d1,...
                                back, self.absTol);
                            Q       = Q';
                        elseif ~(isempty(mydata.BPB))
                            [tt, Q] = ell_ode_solver(@ell_eesm_ode,...
                                tvals, Q0, l0, mydata, d1,...
                                back, self.absTol);
                            Q       = Q';
                        else
                            Q = [];
                        end
                    end
                    QQ = [QQ {Q}];
                end
                newReachObj.ea_values = QQ;
            end
            %%% Compute internal shape matrices.
            if (Options.approximation ~= 0)
                if Properties.getIsVerbose()
                    if isempty(logger)
                        logger=Log4jConfigurator.getLogger();
                    end
                    logger.info('Computing internal shape matrices...');
                end
                LL = [];
                QQ = [];
                N  = size(self.ia_values, 2);
                for ii = 1:N
                    EM = self.ia_values{ii};
                    Q0 = EM(:, end);
                    X0 = reshape(Q0, d1, d1);
                    X0 = sqrtmpos(X0, self.absTol);
                    X0 = 0.5*(X0 + X0');
                    l0 = newReachObj.initial_directions(:, ii);
                    if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                        if hasdisturbance(linSys)
                            [Q, L] = self.iedist_de(size(tvals, 2),...
                                Q0, l0, mydata, d1, back,...
                                Options.minmax,newReachObj.absTol);
                        elseif ~(isempty(mydata.BPB))
                            [Q, L] = self.iesm_de(size(tvals, 2),...
                                Q0, l0, mydata, d1, back,newReachObj.absTol);
                        else
                            Q = [];
                            L = [];
                        end
                        LL = [LL {L}];
                    else
                        if hasdisturbance(linSys)
                            [tt, Q] = ell_ode_solver(@ell_iedist_ode,...
                                tvals, reshape(Q0, d1*d1, 1), l0,...
                                mydata, d1, back, self.absTol);
                            Q       = Q';
                        elseif ~(isempty(mydata.BPB))
                            [tt, Q] = ell_ode_solver(@ell_iesm_ode,...
                                tvals, reshape(X0, d1*d1, 1), X0*l0, l0,...
                                mydata, d1, back, self.absTol);
                            Q       = self.fix_iesm(Q', d1);
                        else
                            Q = [];
                        end
                    end
                    QQ = [QQ {Q}];
                end
                newReachObj.ia_values = QQ;
            end
            if Options.save_all > 0
                newReachObj.calc_data = mydata;
            end
            LL = [];
            for ii = 1:N
                l0 = newReachObj.initial_directions(:, ii);
                if isa(linSys, 'elltool.linsys.LinSysDiscrete')
                    L = l0;
                    l = l0;
                    if back > 0
                        for i = 2:size(newReachObj.time_values, 2)
                            A = ell_value_extract(mydata.A, i, [d1 d1]);
                            l = A' * l;
                            L = [L l];
                        end
                    else
                        for i = 1:(size(newReachObj.time_values, 2) - 1)
                            A = ell_inv(ell_value_extract(mydata.A, i, [d1 d1]));
                            l = A' * l;
                            L = [L l];
                        end
                    end
                else
                    L = [];
                    for i = 1:size(newReachObj.time_values, 2)
                        t = newReachObj.time_values(i);
                        if back > 0
                            F = ell_value_extract(mydata.Phi, t, [d1 d1]);
                        else
                            F = ell_value_extract(mydata.Phinv, t, [d1 d1]);
                        end
                        L = [L F'*l0];
                    end
                end
                LL = [LL {L}];
            end
            newReachObj.l_values = LL;
            if www(1).state
                warning on;
            end
        end
    end
end