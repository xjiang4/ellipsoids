function [resArr, statusArr] = intersect(myEllArr, objArr, mode)
%
% INTERSECT - checks if the union or intersection of ellipsoids intersects
%             given ellipsoid, hyperplane or polytope.
%
%   resMat = INTERSECT(myEllMat, objMat, mode) - Checks if the union
%       (mode = 'u') or intersection (mode = 'i') of ellipsoids
%       in myEllMat intersects with objects in objMat.
%       objMat can be array of ellipsoids, array of hyperplanes,
%       or array of polytopes.
%       Ellipsoids, hyperplanes or polytopes in objMat must have
%       the same dimension as ellipsoids in myEllMat.
%       mode = 'u' (default) - union of ellipsoids in myEllMat.
%       mode = 'i' - intersection.
%
%   If we need to check the intersection of union of ellipsoids in
%   myEllMat (mode = 'u'), or if myEllMat is a single ellipsoid,
%   it can be done by calling distance function for each of the
%   ellipsoids in myEllMat and objMat, and if it returns negative value,
%   the intersection is nonempty. Checking if the intersection of
%   ellipsoids in myEllMat (with size of myEllMat greater than 1)
%   intersects with ellipsoids or hyperplanes in objMat is more
%   difficult. This problem can be formulated as quadratically
%   constrained quadratic programming (QCQP) problem.
%
%   Let objMat(iObj) = E(q, Q) be an ellipsoid with center q and shape matrix Q.
%   To check if this ellipsoid intersects (or touches) the intersection
%   of ellipsoids in meEllMat: E(q1, Q1), E(q2, Q2), ..., E(qn, Qn),
%   we define the QCQP problem:
%                     J(x) = <(x - q), Q^(-1)(x - q)> --> min
%   with constraints:
%                      <(x - q1), Q1^(-1)(x - q1)> <= 1   (1)
%                      <(x - q2), Q2^(-1)(x - q2)> <= 1   (2)
%                      ................................
%                      <(x - qn), Qn^(-1)(x - qn)> <= 1   (n)
%
%   If this problem is feasible, i.e. inequalities (1)-(n) do not
%   contradict, or, in other words, intersection of ellipsoids
%   E(q1, Q1), E(q2, Q2), ..., E(qn, Qn) is nonempty, then we can find
%   vector y such that it satisfies inequalities (1)-(n) and minimizes
%   function J. If J(y) <= 1, then ellipsoid E(q, Q) intersects or touches
%   the given intersection, otherwise, it does not. To check if E(q, Q)
%   intersects the union of E(q1, Q1), E(q2, Q2), ..., E(qn, Qn),
%   we compute the distances from this ellipsoids to those in the union.
%   If at least one such distance is negative,
%   then E(q, Q) does intersect the union.
%
%   If we check the intersection of ellipsoids with hyperplane
%   objMat = H(v, c), it is enough to check the feasibility
%   of the problem
%                       1'x --> min
%   with constraints (1)-(n), plus
%                     <v, x> - c = 0.
%
%   Checking the intersection of ellipsoids with polytope
%   objMat = P(A, b) reduces to checking the feasibility
%   of the problem
%                       1'x --> min
%   with constraints (1)-(n), plus
%                        Ax <= b.
%
% Input:
%   regular:
%       myEllMat: ellipsoid [mEllRows, nEllCols] - matrix of ellipsoids.
%       objMat: ellipsoid [mRows, nCols] / hyperplane [mRows, nCols] /
%           / polytope [mRows, nCols]  - matrix of ellipsoids or
%           hyperplanes or polytopes of the same sizes.
%
%   optional:
%       mode: char[1, 1] - 'u' or 'i', go to description.
%
%           note: If mode == 'u', then mRows, nCols should be equal to 1.
%
% Output:
%   resMat: double[mRows, nCols] - return:
%       resMat(i, j) = -1 in case parameter mode is set
%           to 'i' and the intersection of ellipsoids in myEllMat
%           is empty.
%       resMat(i, j) = 0 if the union or intersection of
%           ellipsoids in myEllMat does not intersect the object
%           in objMat(i, j).
%       resMat(i, j) = 1 if the union or intersection of
%           ellipsoids in myEllMat and the object in objMat(i, j)
%           have nonempty intersection.
%   statusMat: double[0, 0]/double[mRows, nCols] - status variable.
%       statusMat is empty if mode = 'u'.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror;
import modgen.common.checkmultvar;

ellipsoid.checkIsMe(myEllArr,...
    'errorTag','wrongInput',...
    'errorMessage', 'first input argument must be ellipsoid.');
modgen.common.checkvar(objArr,@(x) isa(x, 'ellipsoid') ||...
    isa(x, 'hyperplane') || isa(x, 'polytope'),...
    'errorTag','wrongInput', 'errorMessage',...
    'second input argument must be ellipsoid,hyperplane or polytope.');

if (nargin < 3) || ~(ischar(mode))
    mode = 'u';
end
absTolMat = getAbsTol(myEllArr);
resArr = [];
statusArr = [];
if mode == 'u'
    auxArr = arrayfun(@(x,y) distance(x, objArr)<= y, myEllArr,absTolMat);
    res = double(any(auxArr(:)));
    status = [];
elseif isa(objArr, 'ellipsoid')
    
    fCheckDims(dimension(myEllArr),dimension(objArr));
    
    if Properties.getIsVerbose()
        fprintf('Invoking CVX...\n');
    end
    
    [resArr statusArr] = arrayfun(@(x) qcqp(myEllArr, x), objArr);
elseif isa(objArr, 'hyperplane')
    
    fCheckDims(dimension(myEllArr),dimension(objArr));
    
    if Properties.getIsVerbose()
        fprintf('Invoking CVX...\n');
    end
    
    [resArr statusArr] = arrayfun(@(x) lqcqp(myEllArr, x), objArr);
else
    nDimsArr = arrayfun(@(x) dimension(x), objArr);
    fCheckDims(dimension(myEllArr),nDimsArr);
    
    if Properties.getIsVerbose()
        fprintf('Invoking CVX...\n');
    end
    
    [resArr statusArr] = arrayfun(@(x) lqcqp2(myEllArr, x), objArr);
end

if isempty(resArr)
    resArr = res;
end

if isempty(statusArr)
    statusArr = status;
end

resArr = double(resArr);

    function fCheckDims(nDims1Arr,nDims2Arr)
        modgen.common.checkmultvar...
            ('(x1(1)==x2(1))&&all(x1(:)==x1(1))&&all(x2(:)==x2(1))',...
            2,nDims1Arr,nDims2Arr,...
            'errorTag','wrongSizes',...
            'errorMessage','input arguments must be of the same dimension.');
    end
end





%%%%%%%%

function [res, status] = qcqp(fstEllArr, secEll)
%
% QCQP - formulate quadratically constrained quadratic programming
%        problem and invoke external solver.
%
% Input:
%   regular:
%       fstEllMat: ellipsod [mEllRows, nEllCols] - matrix of ellipsoids.
%       secEll: ellipsoid [1, 1] - ellipsoid.
%
% Output:
%   res: double[1, 1]
%   status: double[1, 1]
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.throwerror;
import elltool.conf.Properties;
status = 1;
[secEllCentVec, secEllShMat] = double(secEll);

if isdegenerate( secEll )
    if Properties.getIsVerbose()
        fprintf('QCQP: Warning! Degenerate ellipsoid.\n');
        fprintf('      Regularizing...\n');
    end
    secEllShMat = ...
        ellipsoid.regularize(secEllShMat,getAbsTol(secEll));
end
secEllShMat = ell_inv(secEllShMat);
secEllShMat = 0.5*(secEllShMat + secEllShMat');
%cvx

absTolArr = getAbsTol(fstEllArr);
cvx_begin sdp
variable cvxExprVec(length(secEllShMat), 1)
minimize(cvxExprVec'*secEllShMat*cvxExprVec + ...
    2*(-secEllShMat*secEllCentVec)'*cvxExprVec + ...
    (secEllCentVec'*secEllShMat*secEllCentVec - 1))
subject to

arrayfun(@(x,y) fRepPart(x,y),fstEllArr, absTolArr);

cvx_end
if strcmp(cvx_status,'Infeasible') ||...
        strcmp(cvx_status,'Inaccurate/Infeasible')
    res = -1;
    return;
end
if cvxExprVec'*secEllShMat*cvxExprVec + ...
        2*(-secEllShMat*secEllCentVec)'*cvxExprVec + ...
        (secEllCentVec'*secEllShMat*secEllCentVec - 1) ...
        <= min(absTolArr(:))
    res = 1;
else
    res = 0;
end
    function fRepPart(singEll,absTol)
        [cVec, shMat] = ...
            double(singEll);
        if isdegenerate(singEll)
            shMat = ellipsoid.regularize(shMat,absTol);
        end
        invShMat = ell_inv(shMat);
        invShMat = 0.5*(invShMat + invShMat');
        cvxExprVec'*invShMat*cvxExprVec +...
            2*(-invShMat*cVec)'*cvxExprVec + ...
            (cVec'*invShMat*cVec - 1) <= 0;
    end
end





%%%%%%%%

function [res, status] = lqcqp(myEllArr, hyp)
%
% LQCQP - formulate quadratic programming problem with linear and
%         quadratic constraints, and invoke external solver.
%
% Input:
%   regular:
%       fstEllMat: ellipsod [mEllRows, nEllCols] - matrix of ellipsoids.
%       hyp: hyperplane [1, 1] - hyperplane.
%
% Output:
%   res: double[1, 1]
%   status: double[1, 1]
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.throwerror;
import elltool.conf.Properties;
status = 1;
[normHypVec, hypScalar] = parameters(hyp);
if hypScalar < 0
    hypScalar = -hypScalar;
    normHypVec = -normHypVec;
end

%cvx

absTolArr = getAbsTol(myEllArr);
cvx_begin sdp
variable cvxExprVec(size(normHypVec, 1), 1)
minimize(abs(normHypVec'*cvxExprVec - hypScalar))
subject to

arrayfun(@(x,y) fRepPart(x,y), myEllArr, absTolArr);

cvx_end
if strcmp(cvx_status,'Infeasible') || ...
        strcmp(cvx_status, 'Inaccurate/Infeasible')
    res = -1;
    return;
end


if abs(normHypVec'*cvxExprVec - hypScalar) <= ...
        min(absTolArr(:))
    res = 1;
else
    res = 0;
end
    function fRepPart(singEll,absTol)
        [cVec, shMat] = double(singEll);
        if isdegenerate(singEll)
            shMat = ...
                ellipsoid.regularize(shMat,absTol);
        end
        invShMat  = ell_inv(shMat);
        cvxExprVec'*invShMat*cvxExprVec - ...
            2*cVec'*invShMat*cvxExprVec + ...
            (cVec'*invShMat*cVec - 1) <= 0;
    end
end





%%%%%%%%

function [res, status] = lqcqp2(myEllArr, polyt)
%
% LQCQP2 - formulate quadratic programming problem with
%          linear and quadratic constraints, and invoke external solver.
%
% Input:
%   regular:
%       fstEllMat: ellipsod [mEllRows, nEllCols] - matrix of ellipsoids.
%       polyt: polytope [1, 1] - polytope.
%
% Output:
%   res: double[1, 1]
%   status: double[1, 1]
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.throwerror;
import elltool.conf.Properties;
status = 1;
[aMat, bVec] = double(polyt);

absTolArr = getAbsTol(myEllArr);
cvx_begin sdp
variable cvxExprVec(size(aMat, 2), 1)
minimize(aMat(1, :)*cvxExprVec)
subject to

arrayfun(@(x,y) fRepPart(x,y), myEllArr, absTolArr)

cvx_end

if strcmp(cvx_status,'Failed')
    throwerror('cvxError','Cvx failed');
end;
if strcmp(cvx_status,'Infeasible') || ...
        strcmp(cvx_status,'Inaccurate/Infeasible')
    res = -1;
    return;
end;
if aMat(1, :)*cvxExprVec <= min(absTolArr(:))
    res = 1;
else
    res = 0;
end

    function fRepPart(singEll,absTol)
        [cVec, shMat] = double(singEll);
        if isdegenerate(singEll)
            shMat = ...
                ellipsoid.regularize(shMat,absTol);
        end
        invShMat  = ell_inv(shMat);
        invShMat  = 0.5*(invShMat + invShMat');
        cvxExprVec'*invShMat*cvxExprVec - ...
            2*cVec'*invShMat*cvxExprVec + ...
            (cVec'*invShMat*cVec - 1) <= 0;
    end
end
