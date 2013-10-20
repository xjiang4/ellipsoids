classdef AEllipsoid < elltool.core.ABasicEllipsoid
    properties(Access = protected, Abstract)
       shapeMat
    end
    properties(Access = protected)
        centerVec    
        absTol
        relTol
        nPlot2dPoints
        nPlot3dPoints
    end
   
    methods(Access = protected)
        checkDoesContainArgs(ell,poly)
        doesContain = doesContainPoly(ellArr,polytope,varagin)
        function checkIfScalar(self,errMsg)
            if nargin<2
                errMsg='input argument must be single ellipsoid.';
            end
            modgen.common.checkvar(self,'isscalar(x)',...
                'errorMessage',errMsg);
        end
        function isArrEq = isMatEqualInternal(self,aArr,bArr)
            % ISMATEQUALINTERNAL - returns isArrEq - logical 1(true) if
            %           multidimensional arrays aArr and bArr are equal,
            %           and logical 0(false) otherwise, comparing them
            %           using absTol and relTol fields of the object self
            %
            % Input:
            %   regular:
            %      self: ellipsoid[1,1]
            %      aArr: double[nDim1,nDim2,...,nDimk]
            %      bArr: double[nDim1,nDim2,...,nDimk]
            %
            % Output:
            %   isArrEq: logical[1,1]
            %
            %
            %
            % $Author: Victor Gribov <illuminati1606@gmail.com> $   $Date: 28-05-2013$
            % $Copyright: Moscow State University,
            %             Faculty of Computational Mathematics and Cybernetics,
            %             Science, System Analysis Department 2012-2013 $
            self.checkIfScalar();
            absTol = self.absTol;
            if any(abs(aArr(:))>absTol) || any(abs(bArr(:))>absTol)
                isArrEq = abs(2*(aArr-bArr)./(aArr+bArr));
                isArrEq = all(isArrEq(:)<=self.relTol);
            else
                isArrEq = true;
            end
        end
        [propMat, propVal] = getProperty(hplaneMat,propName, fPropFun)
        [bpMat, fVec] = getGridByFactor(ellObj,factorVec)
    end
    methods(Access = protected, Static)
        regQMat = regularize(qMat,absTol)
        clrDirsMat = rm_bad_directions(q1Mat, q2Mat, dirsMat,absTol)
        [isBadDirVec,pUniversalVec] = isbaddirectionmat(q1Mat, q2Mat,...
            dirsMat,absTol)
        [diffBoundMat, isPlotCenter3d] = calcdiffonedir(fstEll,secEll,...
            lMat,pUniversalVec,isGoodDirVec)
    end
end