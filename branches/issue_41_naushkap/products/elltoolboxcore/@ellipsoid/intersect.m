function [resMat, statusMat] = intersect(myEllMat, XMat, mode)
%
% INTERSECT - checks if the union or intersection of ellipsoids intersects
%             given ellipsoid, hyperplane or polytope.
%   RES = INTERSECT(E, X, s)  Checks if the union (s = 'u')
%       or intersection (s = 'i') of ellipsoids in E intersects
%       with objects in X.
%       X can be array of ellipsoids, array of hyperplanes,
%       or array of polytopes.
%       Ellipsoids, hyperplanes or polytopes in X must have
%       the same dimension as ellipsoids in E.
%       s = 'u' (default) - union of ellipsoids in E.
%       s = 'i' - intersection.
%
%   If we need to check the intersection of union of ellipsoids in E
%   (s = 'u'), or if E is a single ellipsoid, it can be done by calling
%   distance function for each of the ellipsoids in E and X, and if it 
%   returns negative value, the intersection is nonempty.
%   Checking if the intersection of ellipsoids in E
%   (with size of E greater than 1) intersects with ellipsoids or
%   hyperplanes in X is more difficult. This problem can be formulated
%   as quadratically constrained quadratic programming (QCQP) problem.
%   Let E(q, Q) be an ellipsoid with center q and shape matrix Q.
%   To check if this ellipsoid intersects (or touches) the intersection
%   of ellipsoids E(q1, Q1), E(q2, Q2), ..., E(qn, Qn), we define the QCQP
%   problem:
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
%   If we check the intersection of ellipsoids with hyperplane H(v, c),
%   it is enough to check the feasibility of the problem
%                       1'x --> min
%   with constraints (1)-(n), plus
%                     <v, x> - c = 0.
%
%   Checking the intersection of ellipsoids with polytope P(A, b) reduces
%   to checking the feasibility of the problem
%                       1'x --> min
%   with constraints (1)-(n), plus
%                        Ax <= b.
%
% Input:
%   regular:
%       myEllMat: ellipsod [mEllRows, nEllCols] - matrix of ellipsoids.
%       XMat: ellipsoid [mRows, nCols] - ellipsoidal matrix
%               of the same size.
%           Or
%           hyperplane [mRows, nCols] - matrix of hyperplanes
%               of the same size.
%           Or
%           polytope [mRows, nCols] - matrix of polytopes of the same size.
%
%   properties:
%       mode: char[1, 1] - 'u' or 'i', go to description.
%
%           note: If mode == 'u', then mRows, nCols should be equal to 1.
%               if mEllRows == nEllCols == 1, then mRows, nCols should
%               be equal 1.
%
% Output:
%   regular:
%       resMat: logical[1, 1]/double[mRows, nCols] - return:
%           resMat(i, j) = -1 (double) in case parameter mode is set
%               to 'i' and the intersection of ellipsoids in myEllMat
%               is empty.
%           resMat(i, j) = 0 if the union or intersection of 
%               ellipsoids in myEllMat does not intersect the object
%               in X(i, j).
%           resMat(i, j) = 1 (logical) if the union or intersection of 
%               ellipsoids in myEllMat and the object in X(i, j)
%               have nonempty intersection.
%
%           note: resMat is logical[1, 1] if mode == 'u'.
%
%   optional:
%          status - status variable returned by CVX.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror

if ~(isa(myEllMat, 'ellipsoid'))
    throwerror('wrongInput', ...
        'INTERSECT: first input argument must be ellipsoid.');
end
if ~(isa(XMat, 'ellipsoid')) && ~(isa(XMat, 'hyperplane')) ...
        && ~(isa(XMat, 'polytope'))
    fstErrMsg = 'INTERSECT: second input argument must be ellipsoid, ';
    secErrMsg = 'hyperplane or polytope.';
    throwerror('wrongInput', [fstErrMsg secErrMsg]);
end

if (nargin < 3) || ~(ischar(mode))
    mode = 'u';
end
absTolMat = getAbsTol(myEllMat);
if mode == 'u'
    [mRows, nCols] = size(myEllMat);
    resMat    = (distance(myEllMat(1, 1), XMat) <= absTolMat(1,1));
    for iRow = 1:mRows
        for jCol = 1:nCols
            if (iRow > 1) || (jCol > 1)
                resMat = resMat || (distance(myEllMat(iRow, jCol), XMat) ...
                    <= absTolMat(iRow,jCol));
            end
        end
    end
    statusMat = [];
elseif min(size(myEllMat) == [1 1]) == 1
    resMat    = (distance(myEllMat, XMat) <= myEllMat.absTol);
    statusMat = [];
elseif isa(XMat, 'ellipsoid')
    nDimsMat = dimension(myEllMat);
    mRows    = min(min(nDimsMat));
    nCols    = max(max(nDimsMat));
    nDimsMat = dimension(XMat);
    minEllDim    = min(min(nDimsMat));
    maxEllDim    = max(max(nDimsMat));
    if (mRows ~= nCols) || (minEllDim ~= maxEllDim) || (minEllDim ~= mRows)
        throwerror('wrongSizes', ...
            'INTERSECT: ellipsoids must be of the same dimension.');
    end
    if Properties.getIsVerbose()
        fprintf('Invoking CVX...\n');
    end
    [mRows, nCols] = size(XMat);
    resMat    = [];
    statusMat = [];
    for iRow = 1:mRows
        resPart = [];
        statusPartMat = [];
        for jCol = 1:nCols
            [subRes, subStatus] = qcqp(myEllMat, XMat(iRow, jCol));
            resPart = [resPart subRes];
            statusPartMat = [statusPartMat subStatus];
        end
        resMat = [resMat; resPart];
        statusMat = [statusMat; statusPartMat];
    end
elseif isa(XMat, 'hyperplane')
    nDimsMat = dimension(myEllMat);
    mRows    = min(min(nDimsMat));
    nCols    = max(max(nDimsMat));
    nDimsMat = dimension(XMat);
    minEllDim    = min(min(nDimsMat));
    maxEllDim    = max(max(nDimsMat));
    if (mRows ~= nCols) || (minEllDim ~= maxEllDim) || (minEllDim ~= mRows)
        fstErrMsg = 'INTERSECT: ellipsoids and hyperplanes ';
        secErrMsg = 'must be of the same dimension.';
        throwerror('wrongSizes', [fstErrMsg secErrMsg]);
    end
    if Properties.getIsVerbose()
        fprintf('Invoking CVX...\n');
    end
    [mRows, nCols] = size(XMat);
    resMat    = [];
    statusMat = [];
    for iRow = 1:mRows
        resPart = [];
        statusPartMat = [];
        for jCol = 1:nCols
            [subRes, subStatus] = lqcqp(myEllMat, XMat(iRow, jCol));
            resPart = [resPart subRes];
            statusPartMat = [statusPartMat subStatus];
        end
        resMat    = [resMat; resPart];
        statusMat = [statusMat; statusPartMat];
    end
else
    [mRows, nCols] = size(XMat);
    nDimsMat   = dimension(myEllMat);
    minDims = min(min(nDimsMat));
    maxDims = max(max(nDimsMat));
    nDimsMat   = [];
    for iRow = 1:mRows
        nDimsPart = [];
        for jCol = 1:nCols
            nDimsPart = [nDimsPart dimension(XMat(jCol))];
        end
        nDimsMat = [nDimsMat; nDimsPart];
    end
    minEllDim = min(min(nDimsMat));
    maxEllDim = max(max(nDimsMat));
    if (minDims ~= maxDims) || (minEllDim ~= maxEllDim) || ...
            (minEllDim ~= minDims)
        fstErrMsg = 'INTERSECT: ellipsoids and hyperplanes ';
        secErrMsg = 'must be of the same dimension.';
        throwerror('wrongSizes', [fstErrMsg secErrMsg]);
    end
    if Properties.getIsVerbose()
        fprintf('Invoking CVX...\n');
    end
    resMat    = [];
    statusMat = [];
    for iRow = 1:mRows
        resPart = [];
        statusPartMat = [];
        for jCol = 1:nCols
            [subRes, subStatus] = lqcqp2(myEllMat, XMat(jCol));
            resPart = [resPart subRes];
            statusPartMat = [statusPartMat subStatus];
        end
        resMat = [resMat; resPart];
        statusMat = [statusMat; statusPartMat];
    end
end

if nargout < 2
    clear status;
end

end





%%%%%%%%

function [res, status] = qcqp(fstEllMat, secEll)
%
% QCQP - formulate quadratically constrained quadratic programming problem
%        and invoke external solver.
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
[secEllCentVec, secEllShMat] = parameters(secEll(1, 1));

if size(secEllShMat, 2) > rank(secEllShMat)
    if Properties.getIsVerbose()
        fprintf('QCQP: Warning! Degenerate ellipsoid.\n');
        fprintf('      Regularizing...\n');
    end
    secEllShMat = ellipsoid.regularize(secEllShMat,getAbsTol(secEll(1,1)));
end
secEllShMat = ell_inv(secEllShMat);
secEllShMat = 0.5*(secEllShMat + secEllShMat');
secEllShDublMat = secEllShMat;
secEllCentDublVec = secEllCentVec;
%cvx
[mRows, nCols] = size(fstEllMat);


absTolMat = getAbsTol(fstEllMat);
cvx_begin sdp
variable cvxExprVec(length(secEllShMat), 1)
minimize(cvxExprVec'*secEllShMat*cvxExprVec + ...
    2*(-secEllShMat*secEllCentVec)'*cvxExprVec + ...
    (secEllCentVec'*secEllShMat*secEllCentVec - 1))
subject to
for iRow = 1:mRows
    for jCol = 1:nCols
        [secEllCentVec, secEllShMat] = parameters(fstEllMat(iRow, jCol));
        if size(secEllShMat, 2) > rank(secEllShMat)
            secEllShMat = ellipsoid.regularize(secEllShMat,absTolMat);
        end
        invSecEllShMat = ell_inv(secEllShMat);
        invSecEllShMat = 0.5*(invSecEllShMat + invSecEllShMat');
        cvxExprVec'*invSecEllShMat*cvxExprVec +...
            2*(-invSecEllShMat*secEllCentVec)'*cvxExprVec + ...
            (secEllCentVec'*invSecEllShMat*secEllCentVec - 1) <= 0;
    end
end

cvx_end
if strcmp(cvx_status,'Infeasible') ||...
        strcmp(cvx_status,'Inaccurate/Infeasible')
    res = -1;
    return;
end;
if cvxExprVec'*secEllShDublMat*cvxExprVec + ...
        2*(-secEllShDublMat*secEllCentDublVec)'*cvxExprVec + ...
        (secEllCentDublVec'*secEllShDublMat*secEllCentDublVec - 1) ...
        <= min(getAbsTol(fstEllMat(:)))
    res = 1;
else
    res = 0;
end;


end





%%%%%%%%

function [res, status] = lqcqp(myEllMat, hyp)
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
[normHipVec, HipScalar] = parameters(hyp);
if HipScalar < 0
    HipScalar = -HipScalar;
    normHipVec = -normHipVec;
end

%cvx
[mRows, nCols] = size(myEllMat);


absTolMat = getAbsTol(myEllMat);
cvx_begin sdp
variable cvxExprVec(size(normHipVec, 1), 1)
minimize(abs(normHipVec'*cvxExprVec - HipScalar))
subject to
for iRow = 1:mRows
    for jCol = 1:nCols
        [ellCentVec, ellShMat] = parameters(myEllMat(iRow, jCol));
        if size(ellShMat, 2) > rank(ellShMat)
            ellShMat = ellipsoid.regularize(ellShMat,absTolMat(iRow,jCol));
        end
        invEllShMat  = ell_inv(ellShMat);
        cvxExprVec'*invEllShMat*cvxExprVec - ...
            2*ellCentVec'*invEllShMat*cvxExprVec + ...
            (ellCentVec'*invEllShMat*ellCentVec - 1) <= 0;
    end
end

cvx_end
if strcmp(cvx_status,'Infeasible') || ...
        strcmp(cvx_status, 'Inaccurate/Infeasible')
    res = -1;
    return;
end;


if abs(normHipVec'*cvxExprVec - HipScalar) <= min(getAbsTol(myEllMat(:)))
    res = 1;
else
    res = 0;
end;

end





%%%%%%%%

function [res, status] = lqcqp2(myEllMat, polyt)
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
[AMat, bVec] = double(polyt);
[mRows, nCols] = size(myEllMat);

absTolMat = getAbsTol(myEllMat);
cvx_begin sdp
variable cvxExprVec(size(AMat, 2), 1)
minimize(AMat(1, :)*cvxExprVec)
subject to
for iRow = 1:mRows
    for jCol = 1:nCols
        [ellCentVec, ellShMat] = parameters(myEllMat(iRow, jCol));
        if size(ellShMat, 2) > rank(ellShMat)
            ellShMat = ellipsoid.regularize(ellShMat,absTolMat(iRow,jCol));
        end
        invEllShMat  = ell_inv(ellShMat);
        invEllShMat  = 0.5*(invEllShMat + invEllShMat');
        cvxExprVec'*invEllShMat*cvxExprVec - ...
            2*ellCentVec'*invEllShMat*cvxExprVec + ...
            (ellCentVec'*invEllShMat*ellCentVec - 1) <= 0;
    end
end

cvx_end

if strcmp(cvx_status,'Failed')
    throwerror('cvxError','Cvx failed');
end;
if strcmp(cvx_status,'Infeasible') || ...
        strcmp(cvx_status,'Inaccurate/Infeasible')
    res = -1;
    return;
end;
if AMat(1, :)*cvxExprVec <= min(getAbsTol(myEllMat(:)))
    res = 1;
else
    res = 0;
end;
end
