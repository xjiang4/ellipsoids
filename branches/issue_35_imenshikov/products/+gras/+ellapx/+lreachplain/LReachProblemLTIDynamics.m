classdef LReachProblemLTIDynamics<...
        gras.ellapx.lreachplain.AReachProblemLTIDynamics
    properties (Access=protected)
        xtDynamics
    end
    methods
        function self=LReachProblemLTIDynamics(problemDef,calcPrecision)
            %
            import gras.interp.MatrixInterpolantFactory;
            import gras.ode.MatrixODESolver;
            %
            if ~isa(problemDef,'gras.ellapx.lreachplain.ReachContLTIProblemDef')
                modgen.common.throwerror('wrongInput',...
                    'Incorrect system definition');
            end
            %
            % call superclass constructor
            %
            self=self@gras.ellapx.lreachplain.AReachProblemLTIDynamics(...
                problemDef,calcPrecision);
            %
            % copy necessary data to local variables
            %
            AMat = self.AtDynamics.evaluate(0);
            BpVec = self.BptDynamics.evaluate(0);
            x0Vec = problemDef.getx0Vec();
            sysDim = size(AMat,1);
            %
            % compute x(t)
            %
            odeArgList={'NormControl',self.ODE_NORM_CONTROL,'RelTol',...
                calcPrecision,'AbsTol',calcPrecision};
            solverObj=MatrixODESolver(sysDim,@ode45,odeArgList{:});
            %
            xtDerivFunc = @(t,x) AMat*x+BpVec;
            %
            [timeXtVec,xtArray]=solverObj.solve(xtDerivFunc,...
                self.timeVec,x0Vec);
            %
            self.xtDynamics=MatrixInterpolantFactory.createInstance(...
                'column',xtArray,timeXtVec);
        end
    end
end