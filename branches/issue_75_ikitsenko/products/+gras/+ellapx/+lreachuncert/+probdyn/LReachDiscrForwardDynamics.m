classdef LReachDiscrForwardDynamics < ...
        gras.ellapx.lreachplain.probdyn.AReachDiscrForwardDynamics & ...
        gras.ellapx.lreachuncert.probdyn.AReachProblemDynamics
    properties (Access=protected)
        xtDynamics
    end
    methods
        function self = LReachDiscrForwardDynamics(problemDef)
            import gras.ellapx.common.*;
            import gras.mat.CompositeMatrixOperations;
            %
            if ~isa(problemDef,...
                    'gras.ellapx.lreachuncert.probdef.IReachContProblemDef')
                modgen.common.throwerror('wrongInput',...
                    'Incorrect system definition');
            end
            %
            % call superclass constructor
            %
            self = self@gras.ellapx.lreachplain.probdyn.AReachDiscrForwardDynamics(...
                problemDef);
            %
            compOpFact = CompositeMatrixOperations();
            %
            % create C(t)Q(t)C'(t) and C(t)q(t) dynamics
            %
            CtDefCMat = problemDef.getCMatDef();
            self.CQCTransDynamics = compOpFact.rSymbMultiply(...
                CtDefCMat, problemDef.getQCMat(), CtDefCMat.');
            self.CqtDynamics = compOpFact.rSymbMultiplyByVec(...
                CtDefCMat, problemDef.getqCVec());
            %
            % copy necessary data to local variables
            %
            x0DefVec = problemDef.getx0Vec();
            sysDim = size(problemDef.getAMatDef(), 1);
            nTimePoints = length(self.timeVec);
            %
            % compute x(t)
            %
            xtArray = zeros(sysDim, nTimePoints);
            xtArray(:, 1) = x0DefVec;
            for iTime = 1:nTimePoints - 1
                aMat = self.AtDynamics.evaluate(timeVec(iTime));
                bpVec = self.BptDynamics().evaluate(timeVec(iTime));
                cqVec = smartLinSys.getCqtDynamics().evaluate(timeVec(iTime));
                xtArray(:, iTime + 1) = ...
                    aMat * xtArray(:, iTime) + bpVec + cqVec;
            end
            %
            self.xtDynamics = MatrixInterpolantFactory.createInstance(...
                'column', xtArray, self.timeVec.');
        end
    end
end