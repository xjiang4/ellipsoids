classdef Suite113regBasic < mlunitext.test_case
    methods
        function self = Suite113regBasic(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        
        function self = test113reg(self)
            import gras.ode.ode113reg;
            tStart=0;
            aTol=0.00001;
            regAbsTol=1e-8;
            regMaxStepTol=0.05;
            relTol=0.0001;
            nMaxRegSteps=10;
            tEnd=8*pi;
            initVec=0;
            odePropList={'NormControl','on','RelTol',relTol,'AbsTol',aTol};
            odeRegPropList={'regAbsTol',regAbsTol,'regMaxStepTol',regMaxStepTol,...
                'nMaxRegSteps',nMaxRegSteps};
            %
            fOdeDeriv=@(t, y) cos(t);
            fReg=@(y)fOdeRegPos(y,1);
            s=warning('off','MATLAB:ode45:IntegrationTolNotMet');
            try
                [tVec,yMat,dyRegMat]=...
                    gras.ode.ode113reg(fOdeDeriv,...
                    fReg,...
                    [tStart,tEnd],initVec,odeset(odePropList{:}),...
                    odeRegPropList{:});
                plot(tVec, yMat);
            catch meObj;
                warning(s);
                rethrow(meObj);
            end
            warning(s);
            
            
            function [isStrictViolVec,yRegMat]=fOdeRegPos(yMat,indNonNegative)
                %isStrictViolVec=false(1,size(yMat,2));
                isStrictViolVec=any(yMat(indNonNegative,:)<-0.01,1);
                yRegMat=yMat;
                yRegMat(indNonNegative,:)=max(yRegMat(indNonNegative,:),0);
            end
        end
        
            
       end
       
       
       
       
       
end

