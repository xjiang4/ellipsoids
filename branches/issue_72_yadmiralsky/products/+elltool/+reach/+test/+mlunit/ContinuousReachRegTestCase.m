classdef ContinuousReachRegTestCase < mlunitext.test_case
    properties (Access=private)
        confName
        crm
        crmSys
        linSys
        atDefCMat
        btDefCMat
        ctDefCMat
        ControlBounds
        DistBounds
        x0Ell
        l0Mat
        timeVec
        calcPrecision
        regTol
    end
    %
    methods (Access = private)
        function [atDefCMat, btDefCMat, ctDefCMat, ptDefCMat,...
                ptDefCVec, qtDefCMat, qtDefCVec, x0DefMat,...
                x0DefVec, l0Mat] = getSysParams(self)
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
        end
    end
    %
    methods
        function self = ContinuousReachRegTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
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
            self.crmSys.selectConf(sysDefConfName,...
                'reloadIfSelected', false);
            %
            [self.atDefCMat, self.btDefCMat, self.ctDefCMat, ptDefCMat,...
                ptDefCVec, qtDefCMat, qtDefCVec,...
                x0DefMat, x0DefVec, self.l0Mat] = self.getSysParams();
            %
            self.x0Ell = ellipsoid(x0DefVec, x0DefMat);
            self.timeVec = [self.crmSys.getParam('time_interval.t0'),...
                self.crmSys.getParam('time_interval.t1')];
            self.calcPrecision =...
                self.crm.getParam('genericProps.calcPrecision');
            self.regTol =...
                self.crm.getParam('regularizationProps.regTol');
            self.ControlBounds = struct();
            self.ControlBounds.center = ptDefCVec;
            self.ControlBounds.shape = ptDefCMat;
            self.DistBounds = struct();
            self.DistBounds.center = qtDefCVec;
            self.DistBounds.shape = qtDefCMat;
        end
        %
        function self = testRegularization(self)
            x0Ell = self.x0Ell.getCopy();
            l0Mat = self.l0Mat;
            timeVec = self.timeVec;
            regTol = self.regTol;
            atDefCMat = self.atDefCMat;
            btDefCMat = self.btDefCMat;
            %ctDefCMat = self.ctDefCMat;
            ctDefCMat = [1;0];
            DistBounds = struct();
            DistBounds.shape = {'0.09*(sin(t))^2'};
            DistBounds.center = {'2*cos(t)'};
            ControlBounds = self.ControlBounds;
            %DistBounds = self.DistBounds;
            %
            assymEllMat = [1e-3, 0; 0, 1e+3];
            ControlBoundsTest = 100 * ellipsoid(assymEllMat);
            linSys = elltool.linsys.LinSysFactory.create(...
                atDefCMat, btDefCMat, ControlBoundsTest);
            self.runAndCheckError(...
                ['elltool.reach.ReachContinuous(linSys, x0Ell,',...
                'l0Mat, timeVec, ''isRegEnabled'', true, ',...
                '''isJustCheck'', false, ''regTol'', 0.01)'],...
                ['ELLTOOL:REACH:AREACH:',...
                'MAKEELLTUBEREL:wrongInput:BadCalcPrec']);
            %
            linSys = elltool.linsys.LinSysFactory.create(atDefCMat,...
                btDefCMat, ControlBounds, ctDefCMat, DistBounds);
            self.runAndCheckError(...
                ['elltool.reach.ReachContinuous(linSys, x0Ell,',...
                'l0Mat, timeVec, ''isRegEnabled'', false, ',...
                '''isJustCheck'', false, ''regTol'', regTol)'],...
                ['ELLTOOL:REACH:REACHCONTINUOUS:',...
                'AUXMAKEELLTUBEREL:wrongInput:regProblem:RegIsDisabled']);
            %
            self.runAndCheckError(...
                ['elltool.reach.ReachContinuous(linSys, x0Ell,',...
                'l0Mat, timeVec, ''isRegEnabled'', true, ',...
                '''isJustCheck'', true, ''regTol'', regTol)'],...
                ['ELLTOOL:REACH:AREACH:MAKEELLTUBEREL:',...
                'wrongInput:regProblem:onlyCheckIsEnabled']);
            %
            x0Ell = 1e-2 * ell_unitball(2);
            badRegTol = 1e-4;
            self.runAndCheckError(...
                ['elltool.reach.ReachContinuous(linSys, x0Ell,',...
                'l0Mat, timeVec, ''isRegEnabled'', true, ',...
                '''isJustCheck'', false, ''regTol'', badRegTol)'],...
                ['ELLTOOL:REACH:AREACH:',...
                'MAKEELLTUBEREL:wrongInput:regProblem:regTolIsTooLow']);
            %
            badODE45RegTol = 1e-3;
            self.runAndCheckError(...
                ['elltool.reach.ReachContinuous(linSys, x0Ell,',...
                'l0Mat, timeVec, ''isRegEnabled'', true, ',...
                '''isJustCheck'', false, ''regTol'', badODE45RegTol)'],...
                ['ELLTOOL:REACH:REACHCONTINUOUS:AUXMAKEELLTUBEREL:',...
                'wrongInput:regProblem:regTolIsTooLow:Ode45Failed']);
            %
            x0Ell = 1e-5 * ell_unitball(2);
            self.runAndCheckError(...
                ['elltool.reach.ReachContinuous(linSys, x0Ell,',...
                'l0Mat, timeVec, ''isRegEnabled'', false, ',...
                '''isJustCheck'', false, ''regTol'', regTol)'],...
                ['ELLTOOL:REACH:REACHCONTINUOUS:',...
                'AUXMAKEELLTUBEREL:wrongInput:BadInitSet']);
            %
            x0Ell = self.x0Ell.getCopy();
            elltool.reach.ReachContinuous(linSys, x0Ell, l0Mat, timeVec,...
                'isRegEnabled', true, 'isJustCheck', false,...
                'regTol', regTol);
        end
    end
    
end