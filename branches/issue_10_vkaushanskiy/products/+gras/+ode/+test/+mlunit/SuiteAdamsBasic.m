classdef SuiteAdamsBasic < mlunitext.test_case
    methods
        function self = SuiteAdamsBasic(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        
        function self = testAdamsWithoutReg(self)
            import gras.ode.odeAdamsreg;
            fOdeDeriv = @(t, y) t;
            tStart = 0;
            tEnd = 5;
            ntSpan = 100;
            tSpan = linspace(tStart, tEnd, ntSpan);
            yInit = 0;
            aTol = 1e-6;
            rTol = 1e-5;
            odePropList={'RelTol',rTol,'AbsTol',aTol};
            
            [testT, testY, testYReg] = odeAdamsreg(fOdeDeriv, @regFunc, tSpan, yInit, odeset(odePropList{:}), []);
            
            testYans = testT.^2/2;
            
            mlunit.assert(norm(abs(testY - testYans.'), Inf) < aTol);
            
            
            function [isReg, yout, regY] = regFunc(fOdeDeriv, tTime, yTime, regTime)
                import modgen.common.throwerror; 
                yout = yTime(end);
                if (yout < 0)
                    throwerror('wrongRegularization','it can''t be regularization in this case');
                end;
                isReg = false;
                regY = 0;
            end
        end
        
      function self = testAdamsPeriodicalReg(self)
            import gras.ode.odeAdamsreg;
            fOdeDeriv = @(t, y) cos(t);
            tStart = 0;
            tEnd = 6*pi;
            ntSpan = 1000;
            tSpan = linspace(tStart, tEnd, ntSpan);
            yInit = 0;
            aTol = 1e-6;
            rTol = 1e-5;
            odePropList={'RelTol',rTol,'AbsTol',aTol};
            [testT, testY, testYReg] = odeAdamsreg(fOdeDeriv, @regFunc, tSpan, yInit, odeset(odePropList{:}), []);
            
            
            function [isReg, yout, regY] = regFunc(fOdeDeriv, tTime, yTime, regTime)
                EPS = 0.001;
                hStep = tTime(2) - tTime(1);
                isReg = false;
                yout = yTime(end);
                if (yout < EPS)
                    isReg = true;
                    yout = EPS;
                end;
                tempRegY = 12*(EPS - yTime(end-1))./hStep + 16*(fOdeDeriv(tTime(end-2), yTime(end-2)) + regTime(2)) - 5*(fOdeDeriv(tTime(1), yTime(1)) + regTime(1));
                regY = tempRegY./23 - fOdeDeriv(tTime(end-1), yTime(end-1));
            end
       end
       function self = testAdamsZeroMultReg(self)
            import gras.ode.odeAdamsreg;
            fOdeDeriv = @(t, y) -1./t;
            tStart = 1;
            tEnd = 5;
            ntSpan = 1000;
            tSpan = linspace(tStart, tEnd, ntSpan);
            yInit = 1;
            aTol = 1e-6;
            rTol = 1e-5;
            odePropList={'RelTol',rTol,'AbsTol',aTol};
            [testT, testY, testYReg] = odeAdamsreg(fOdeDeriv, @regFunc, tSpan, yInit, odeset(odePropList{:}), []);
            function [isReg, yout, regY] = regFunc(fOdeDeriv, tTime, yTime, regTime)
                EPS = 0.001;
                hStep = tTime(2) - tTime(1);
                isReg = false;
                yout = yTime(end);
                if (yout < EPS)
                    isReg = true;
                    yout = EPS;
                end;
                tempRegY = 12*(EPS - yTime(end-1))./hStep + 16*(fOdeDeriv(tTime(end-2), yTime(end-2)) + regTime(2)) - 5*(fOdeDeriv(tTime(1), yTime(1)) + regTime(1));
                regY = tempRegY./23 - fOdeDeriv(tTime(end-1), yTime(end-1));
            end
            
       end
       function self = testAdamsZeroReg(self)
            import gras.ode.odeAdamsreg;
            fOdeDeriv = @(t, y) -1./(t*y);
            tStart = 1;
            tEnd = 5;
            ntSpan = 1000;
            tSpan = linspace(tStart, tEnd, ntSpan);
            yInit = 1;
            aTol = 1e-6;
            rTol = 1e-5;
            odePropList={'RelTol',rTol,'AbsTol',aTol};
            [testT, testY, testYReg] = odeAdamsreg(fOdeDeriv, @regFunc, tSpan, yInit, odeset(odePropList{:}), []);
            plot(testT, testY);
            function [isReg, yout, regY] = regFunc(fOdeDeriv, tTime, yTime, regTime)
                EPS = 0.001;
                hStep = tTime(2) - tTime(1);
                isReg = false;
                yout = yTime(end);
                if (yout < EPS)
                    isReg = true;
                    yout = EPS;
                end;
                tempRegY = 12*(EPS - yTime(end-1))./hStep + 16*(fOdeDeriv(tTime(end-2), yTime(end-2)) + regTime(2)) - 5*(fOdeDeriv(tTime(1), yTime(1)) + regTime(1));
                regY = tempRegY./23 - fOdeDeriv(tTime(end-1), yTime(end-1));
            end
            
       end
    
       function self = testAdamsVecWithoutReg(self)
            import gras.ode.odeAdamsreg;
            fOdeDeriv = @(t, y) [t.^2, t, 3*t].';
            tStart = 0;
            tEnd = 1;
            ntSpan = 1000;
            tSpan = linspace(tStart, tEnd, ntSpan);
            yInit = [1, 0.5, 0.3].';
            aTol = 1e-6;
            rTol = 1e-5;
            odePropList={'RelTol',rTol,'AbsTol',aTol};
            [testT, testY, testYReg] = odeAdamsreg(fOdeDeriv, @regFunc, tSpan, yInit, odeset(odePropList{:}), []);
            function [isReg, yout, regY] = regFunc(fOdeDeriv, tTime, yTime, regTime)
                EPS = 0.001;
                hStep = tTime(2) - tTime(1);
                isReg = false;
                yout = yTime(:, end);
                if (min(yout) < 0)
                    throwerror('wrongRegularization','it can''t be regularization in this case');
                end;
                tempRegY = 12*(EPS - yTime(end-1))./hStep + 16*(fOdeDeriv(tTime(end-2), yTime(end-2)) + regTime(2)) - 5*(fOdeDeriv(tTime(1), yTime(1)) + regTime(1));
                regY = tempRegY./23 - fOdeDeriv(tTime(end-1), yTime(end-1));
            end
            
       end
        
       function self = testAdamsVecReg(self)
            import gras.ode.odeAdamsreg;
            fOdeDeriv = @(t, y) -1./sqrt(y);
            tStart = 1;
            tEnd = 2;
            ntSpan = 1000;
            tSpan = linspace(tStart, tEnd, ntSpan);
            yInit = [1, 0.3, 0.1];
            aTol = 1e-6;
            rTol = 1e-5;
            odePropList={'RelTol',rTol,'AbsTol',aTol};
            [testT, testY, testYReg] = odeAdamsreg(fOdeDeriv, @regFunc, tSpan, yInit, odeset(odePropList{:}), []);
            plot(testT, testYReg);
            function [isReg, yout, regY] = regFunc(fOdeDeriv, tTime, yTime, regTime)
                EPS = 0.001;
                hStep = tTime(2) - tTime(1);
                isReg = false;
                yout = yTime(:, end);
                nDim = numel(yout);
                for i = 1:nDim
                    if (yout(i) < EPS)
                        isReg = true;
                        yout(i) = EPS;
                    end;
                end;
                tempRegY = 12*(yout - yTime(:, end-1))./hStep + 16*(fOdeDeriv(tTime(end-2), yTime(:, end-2)) + regTime(:, 2)) - 5*(fOdeDeriv(tTime(1), yTime(:, 1)) + regTime(:, 1));
                regY = tempRegY./23 - fOdeDeriv(tTime(end-1), yTime(:, end-1));
            end
            
       end
       
       
       
       
       
       
    end

end

