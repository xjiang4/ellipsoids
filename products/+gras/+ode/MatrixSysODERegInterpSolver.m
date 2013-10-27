classdef MatrixSysODERegInterpSolver < gras.ode.MatrixSysODESolver
    methods
        function self=MatrixSysODERegInterpSolver(varargin)
            % MATRIXSYSODEREGINTERPSOLVER - MatrixSysODERegInterpSolver
            %   class constructor. This class inherits from 
            %   gras.ode.MatrixSysODESolver. Differences of class 
            %   gras.ode.MatrixSysODESolver and 
            %   gras.ode.MatrixSysODERegInterpSolver lie in the fact that
            %   the method gras.ode.MatrixSysODERegInterpSolver.solve()
            %   further returns an object of class
            %   gras.ode.MatrixSysReshapeOde45RegInterp.
            %
            % $Author: Vadim Danilov <vadimdanilov93@gmail.com> $  
            % $Date: 24-oct-2013$
            % $Copyright: Moscow State University,
            %  Faculty of Computational Mathematics and Cybernetics,
            %  Science, System Analysis Department 2013 $
            self = self@gras.ode.MatrixSysODESolver(varargin{:});
        end
        function [timeVec,varargout]=solve(self,fDerivFuncList,timeVec,...
                varargin)
            % SOLVE - solver of the system of matrix equations
            % Input:
            %   regular:
            %       self: gras.ode.MatrixSysODERegInterpSolver[1,1] -
            %           all the data nessecary to solve the system of
            %           matrix equations  is stored in this object;
            %       fDerivFuncList: cell[1,nEquations] of function handle -
            %           list of derivatives functions;
            %       timeVec: double[1,nPoints] - time range, same meaning 
            %           as in ode45;
            %       initValList: cell[1,nEquations] - initial state
            %   optional:
            %       options: odeset[1,1] - options generated by odeset 
            %           function, same meaning as in ode45
            %
            %   properties:
            %       regMaxStepTol: double[1,1] - maximum allowed 
            %           regularization size calculated as max(abs(yReg-y))
            %           allowed per step
            %       regAbsTol: double[1,1] - maximum regularization 
            %           tolerance calculated as max(abs(yReg-y)) that is
            %           allowed to consider the integration step to be
            %           successful. If the tolerance level is not achieved
            %           the regularization continues in the iterative
            %           manner via correcting dyReg or decreasing the step
            %           size
            %       nMaxRegSteps: double[1,1] - maximum number of allowed
            %           regularization steps, if regAbsTol is not achieved
            %           in nMaxRegSteps(or less) the integration process 
            %           fails
            % Output:
            %   regular:
            %       timeVec: double[nPoints,1] - time grid, same meaning
            %           as in ode45
            %   optional:
            %       outArg1: double[sizeEqList{1}]
            %           ...
            %       outArgN: double[sizeEqList{nEquations*nFuncs}] -
            %           these variables contains nEquations*nFuncs arrays
            %           of dobule (nEquations for each function), each of
            %           which is a solution of the corresponding equation 
            %           for the corresponding function. (here N in the
            %           name outArgN equal nEquations*nFuncs)
            %       interpObj: 
            %           gras.ode.MatrixSysReshapeOde45RegInterp[1,1] - 
            %           all the data nessecary for calculation on an
            %           arbitrary time grid is stored in this object,
            %           including the dimensionality of the system and the 
            %           number of functions; in fact it is shell of 
            %           gras.ode.VecOde45RegInterp for system of matrix
            %           equations (here N in the name outArgN equal 
            %           nEquations*nFuncs+1)
            % Example:
            %   % Example corresponds to four equations and two derivatives
            %   % functions
            %   
            %   solveObj=gras.ode.MatrixSysODERegInterpSolver(...
            %       sizeVecList,@(varargin)fSolver(varargin{:},...
            %       odeset(odePropList{:})),varargin{:});
            %   % make interpObj
            %   [resInterpTimeVec,resSolveSimpleFuncArray1,...
            %       resSolveSimpleFuncArray2,resSolveSimpleFuncArray3,...
            %       resSolveSimpleFuncArray4,resSolveRegFuncArray5,...
            %       resSolveRegFuncArray6,resSolveRegFuncArray7,...
            %       resSolveRegFuncArray8,...
            %       objMatrixSysReshapeOde45RegInterp]=solveObj.solve(...
            %       fDerivFuncList,timeVec,initValList{:});
            %
            % $Author: Vadim Danilov <vadimdanilov93@gmail.com> $  
            % $Date: 24-oct-2013$
            % $Copyright: Moscow State University,
            %  Faculty of Computational Mathematics and Cybernetics,
            %  Science, System Analysis Department 2013 $
            
            nFuncs = length(fDerivFuncList);
            nOuts = length(self.sizeEqList)*nFuncs;
            resList = cell(1,nOuts);
            resAdvList = cell(1,nFuncs-1);
            [timeVec,resList{:},resAdvList{:}] = ...
                solve@gras.ode.MatrixSysODESolver(self,fDerivFuncList,...
                timeVec,varargin{:});
            varargout = [resList ...
                {gras.ode.MatrixSysReshapeOde45RegInterp(...
                resAdvList{:},self.sizeEqList,nFuncs)}];               
        end
    end
end