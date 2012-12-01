function [resArr, xMat] = rho(ellArr, L)
%
% RHO - computes the values of the support function for given ellipsoid
%       and given direction.
%
%
% Description:
% ------------
%
%         RES = RHO(E, L)  Computes the support function of the ellipsoid E
%                          in directions specified by the columns of matrix L.
%                          Or, if E is array of ellipsoids, L is expected to be
%                          a single vector.
%
%    [RES, X] = RHO(E, L)  Computes the support function of the ellipsoid E
%                          in directions specified by the columns of matrix L,
%                          and boundary points X of this ellipsoid that correspond
%                          to directions in L.
%                          Or, if E is array of ellipsoids, and L - single vector,
%                          then support functions and corresponding boundary
%                          points are computed for all the given ellipsoids in
%                          the array in the specified direction L.
%
%    The support function is defined as
%       (1)  rho(l | E) = sup { <l, x> : x belongs to E }.
%    For ellipsoid E(q,Q), where q is its center and Q - shape matrix,
%    it is simplified to
%       (2)  rho(l | E) = <q, l> + sqrt(<l, Ql>)
%    Vector x, at which the maximum at (1) is achieved is defined by
%       (3)  q + Ql/sqrt(<l, Ql>)
%
%
% Output:
% -------
%
%    RES - the values of the support function for the specified ellipsoid E
%          and directions L. Or, if E is an array of ellipsoids, and L - single
%          vector, then these are values of the support function for all the
%          ellipsoids in the array in the given direction.
%      X - boundary points of the ellipsoid E that correspond to directions in L.
%          Or, if E is an array of ellipsoids, and L - single vector,
%          then these are boundary points of all the ellipsoids in the array
%          in the given direction.
%
%
% See also:
% ---------
%
%    ELLIPSOID/ELLIPSOID.
%

%
% Author:
% -------
%
%    Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
%    Rustam Guliev <glvrst@gmail.com>

import modgen.common.checkmultvar;

checkIsMe(ellArr,...
    'errorMessage','RHO: first argument must be ellipsoid.');
modgen.common.checkvar(L, @(x)isa(x,'double'),...
    'errorMessage','RHO: second argument must be matrix of direction vectors.');
checkmultvar('isscalar(x1)||(size(x2,2)==1)',2,ellArr, L, 'errorMessage',...
    'RHO: arguments must be single ellipsoid and matrix of direction vectors,\n     or array of ellipsoids and single direction vector.');

[nDim, nDirs] = size(L);
if isscalar(ellArr)
    ea = 0;
else
    ea = 1;
end

nDimsVec = dimension(ellArr);
checkmultvar('all(x2==x1)',2,nDim,nDimsVec, 'errorMessage',...
    'RHO: dimension of ellipsoids array not same or dimensions of the direction vector and the ellipsoid do not match.');

if ea > 0 % multiple ellipsoids, one direction
    [resCArr xCArr] =arrayfun(@(x) fSingleRhoForOneDir(x),ellArr,...
        'UniformOutput',false);
    resArr = cell2mat(resCArr);
    xMat= horzcat(xCArr{:});
else % one ellipsoid, multiple directions
    q = ellArr.center;
    Q = ellArr.shape;
    dirsCVec = mat2cell(L,nDim,ones(1,nDirs));
    
    [resCArr xCArr] =cellfun(@(x) fSingleRhoForOneEll(x),dirsCVec,...
        'UniformOutput',false);
    resArr = cell2mat(resCArr);
    xMat = cell2mat(xCArr);
end

    function [supFun xVec] = fSingleRhoForOneDir(singEll)
        cVec  = singEll.center;
        shpMat  = singEll.shape;
        sq = sqrt(L'*shpMat*L);
        if sq == 0
            sq = eps;
        end
        supFun = cVec'*L + sq;
        xVec =((shpMat*L)/sq) + cVec;
    end
    function [supFun xVec] = fSingleRhoForOneEll(lVec)
        sq  = sqrt(lVec'*Q*lVec);
        if sq == 0
            sq = eps;
        end
        supFun = q'*lVec + sq;
        xVec = ((Q*lVec)/sq) + q;
    end
end
