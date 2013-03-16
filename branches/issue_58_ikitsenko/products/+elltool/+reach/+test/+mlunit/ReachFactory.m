classdef ReachFactory
    properties (Access = private)
        confName
        crm
        crmSys
        linSys
        l0Mat
        x0Ell
        tVec
        isBack
        isEvolve
        dim
    end
    methods
        function self =...
                ReachFactory(confName, crm, crmSys, isBack, isEvolve)
            self.confName = confName;
            self.crm = crm;
            self.crmSys = crmSys;
            self.isBack = isBack;
            self.isEvolve = isEvolve;
            %
            crm.deployConfTemplate(confName);
            crm.selectConf(confName);
            sysDefConfName = crm.getParam('systemDefinitionConfName');
            crmSys.selectConf(sysDefConfName, 'reloadIfSelected', false);
            %
            self.dim = crmSys.getParam('dim');
            atDefCMat = crmSys.getParam('At');
            btDefCMat = crmSys.getParam('Bt');
            ctDefCMat = crmSys.getParam('Ct');
            ptDefCMat = crmSys.getParam('control_restriction.Q');
            ptDefCVec = crmSys.getParam('control_restriction.a');
            qtDefCMat = crmSys.getParam('disturbance_restriction.Q');
            qtDefCVec = crmSys.getParam('disturbance_restriction.a');
            x0DefMat = crmSys.getParam('initial_set.Q');
            x0DefVec = crmSys.getParam('initial_set.a');
            l0CMat = crm.getParam(...
                'goodDirSelection.methodProps.manual.lsGoodDirSets.set1');
            self.l0Mat = cell2mat(l0CMat.').';
            self.x0Ell = ellipsoid(x0DefVec, x0DefMat);
            self.tVec = [crmSys.getParam('time_interval.t0'),...
                crmSys.getParam('time_interval.t1')];
            if self.isBack
                self.tVec = [crmSys.getParam('time_interval.t1'),...
                crmSys.getParam('time_interval.t0')];
            else
                self.tVec = [crmSys.getParam('time_interval.t0'),...
                crmSys.getParam('time_interval.t1')];
            end
            ControlBounds = struct();
            ControlBounds.center = ptDefCVec;
            ControlBounds.shape = ptDefCMat;
            DistBounds = struct();
            DistBounds.center = qtDefCVec;
            DistBounds.shape = qtDefCMat;
            %
            self.linSys = elltool.linsys.LinSys(atDefCMat, btDefCMat,...
                ControlBounds, ctDefCMat, DistBounds);
        end
        function reachObj = createInstence(self)
            if self.isBack
                reachObj = elltool.reach.ReachContinuous(self.linSys,...
                    self.x0Ell, self.l0Mat, self.tVec);
            elseif self.isEvolve
                halfReachObj = elltool.reach.ReachContinuous(self.linSys,...
                    self.x0Ell, self.l0Mat, [self.tVec(1) sum(self.tVec)/2]);
                reachObj = halfReachObj.evolve(self.tVec(2));
            else
                reachObj = elltool.reach.ReachContinuous(self.linSys,...
                    self.x0Ell, self.l0Mat, self.tVec);
            end
        end
        function linSys = getLinSys(self)
            linSys = self.linSys;
        end
        function dim = getDim(self)
            dim = self.dim;
        end
        function tVec = getTVec(self)
            tVec = self.tVec;
        end
        function x0Ell = getX0Ell(self)
            x0Ell = self.x0Ell;
        end
        function l0Mat = getL0Mat(self)
            l0Mat = self.l0Mat;
        end
    end
end