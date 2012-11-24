function outEllMat = intersection_ea(myEllMat, objMat)
%
% INTERSECTION_EA - external ellipsoidal approximation of the intersection
%                   of two ellipsoids, or ellipsoid and halfspace,
%                   or ellipsoid and polytope.
%
%   E = INTERSECTION_EA(E1, E2) Given two ellipsoidal arrays of equal
%       sizes, E1 and E2, or, alternatively, E1 or E2 must be
%       a single ellipsoid, computes the ellipsoid
%       that contains the intersection of two
%       corresponding ellipsoids from E1 and from E2.
%   E = INTERSECTION_EA(E1, H) Given array of ellipsoids E1 and array of
%       hyperplanes H whose sizes match, computes
%       the external ellipsoidal
%       approximations of intersections of ellipsoids
%       and halfspaces defined by hyperplanes in H.
%       If v is normal vector of hyperplane and c - shift,
%       then this hyperplane defines halfspace
%               <v, x> <= c.
%   E = INTERSECTION_EA(E1, P) Given array of ellipsoids E1 and array of
%       polytopes P whose sizes match, computes
%       the external ellipsoidal approximations
%       of intersections of ellipsoids E1 and
%       polytopes P.
%
%   The method used to compute the minimal volume overapproximating
%   ellipsoid is described in "Ellipsoidal Calculus Based on
%   Propagation and Fusion" by Lluis Ros, Assumpta Sabater and
%   Federico Thomas; IEEE Transactions on Systems, Man and Cybernetics,
%   Vol.32, No.4, pp.430-442, 2002. For more information, visit
%   http://www-iri.upc.es/people/ros/ellipsoids.html
%
% Input:
%   regular:
%       myEllMat: ellipsod [mRows, nCols] - matrix of ellipsoids.
%       objMat: ellipsoid [mRows, nCols] - ellipsoidal matrix
%               of the same size.
%           Or
%           hyperplane [mRows, nCols] - matrix of hyperplanes
%               of the same size.
%           Or
%           polytope [mRows, nCols] - matrix of polytopes of the same size.
%
% Output:
%    outEllMat: ellipsod [mRows, nCols] - matrix of external approximating
%       ellipsoids; entries can be empty ellipsoids if the corresponding
%       intersection is empty.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.throwerror;

if ~(isa(myEllMat, 'ellipsoid'))
    throwerror('wrongInput', ...
        'INTERSECTION_EA: first input argument must be ellipsoid.');
end
if ~(isa(objMat, 'ellipsoid')) && ~(isa(objMat, 'hyperplane')) ...
        && ~(isa(objMat, 'polytope'))
    fstErrMsg = 'INTERSECTION_EA: second input argument must be ';
    secErrMsg = 'ellipsoid, hyperplane or polytope.';
    throwerror('wrongInput', [fstErrMsg secErrMsg]);
end

[mEllRows, nEllCols] = size(myEllMat);
[mObjRows, nObjCols] = size(objMat);
nDimsMat  = dimension(myEllMat);

if isa(objMat, 'polytope')
    nObjDimsMat = [];
    for iRow = 1:mObjRows
        nObjDimsPartVec = [];
        for jCol = 1:nObjCols
            nObjDimsPartVec = [nObjDimsPartVec dimension(objMat(jCol))];
        end
        nObjDimsMat = [nObjDimsMat; nObjDimsPartVec];
    end
else
    nObjDimsMat = dimension(objMat);
end

minDim   = min(min(nDimsMat));
minObjDim   = min(min(nObjDimsMat));
maxDim   = max(max(nDimsMat));
maxObjDim   = max(max(nObjDimsMat));

if (minDim ~= maxDim) || (minObjDim ~= maxObjDim) || (maxDim ~= maxObjDim)
    if isa(objMat, 'hyperplane')
        fstErrMsg = 'INTERSECTION_EA: ellipsoids and hyperplanes ';
        secErrMsg = 'must be of the same dimension.';
        throwerror('wrongSizes', [fstErrMsg secErrMsg]);
    elseif isa(objMat, 'polytope')
        fstErrMsg = 'INTERSECTION_EA: ellipsoids and polytopes ';
        secErrMsg = 'must be of the same dimension.';
        throwerror('wrongSizes', [fstErrMsg secErrMsg]);
    else
        throwerror('wrongSizes', ...
            'INTERSECTION_EA: ellipsoids must be of the same dimension.');
    end
end

nEllipsoids = mEllRows * nEllCols;
nObjects = mObjRows * nObjCols;
if (nEllipsoids > 1) && (nObjects > 1) && ((mEllRows ~= mObjRows) ...
        || (nEllCols ~= nObjCols))
    if isa(objMat, 'hyperplane')
        fstErrMsg = 'INTERSECTION_EA: sizes of ellipsoidal and';
        secErrMsg = ' hyperplane arrays do not match.';
        throwerror('wrongSizes', [fstErrMsg secErrMsg]);
    elseif isa(objMat, 'polytope')
        fstErrMsg = 'INTERSECTION_EA: sizes of ellipsoidal and';
        secErrMsg = ' polytope arrays do not match.';
        throwerror('wrongSizes', [fstErrMsg secErrMsg]);
    else
        throwerror('wrongSizes', ...
            'INTERSECTION_EA: sizes of ellipsoidal arrays do not match.');
    end
end

outEllMat = [];
if (nEllipsoids > 1) && (nObjects > 1)
    for iRow = 1:mEllRows
        ellPartVec = [];
        for jCol = 1:nEllCols
            if isa(objMat, 'polytope')
                ellPartVec = [ellPartVec ...
                    l_polyintersect(myEllMat, objMat(jCol))];
            else
                ellPartVec = [ellPartVec ...
                    l_intersection_ea(myEllMat(iRow, jCol), ...
                    objMat(iRow, jCol))];
            end
        end
        outEllMat = [outEllMat; ellPartVec];
    end
elseif nEllipsoids > 0
    for iRow = 1:mEllRows
        ellPartVec = [];
        for jCol = 1:nEllCols
            if isa(objMat, 'polytope')
                ellPartVec = [ellPartVec ...
                    l_polyintersect(myEllMat, objMat)];
            else
                ellPartVec = [ellPartVec ...
                    l_intersection_ea(myEllMat(iRow, jCol), objMat)];
            end
        end
        outEllMat = [outEllMat; ellPartVec];
    end
else
    for iRow = 1:mObjRows
        ellPartVec = [];
        for jCol = 1:nObjCols
            if isa(objMat, 'polytope')
                ellPartVec = [ellPartVec ...
                    l_polyintersect(myEllMat, objMat(jCol))];
            else
                ellPartVec = [ellPartVec ...
                    l_intersection_ea(myEllMat, objMat(iRow, jCol))];
            end
        end
        outEllMat = [outEllMat; ellPartVec];
    end
end

end





%%%%%%%%

function outEll = l_intersection_ea(fstEll, secObj)
%
% L_INTERSECTION_EA - computes external ellipsoidal approximation of 
%                     intersection of single ellipsoid with single
%                     ellipsoid or halfspace.
%
% Input:
%   regular:
%       fsrEll: ellipsod [1, 1] - matrix of ellipsoids.
%       secObj: ellipsoid [1, 1] - ellipsoidal matrix
%               of the same size.
%           Or
%           hyperplane [1, 1] - matrix of hyperplanes
%               of the same size.
%
% Output:
%    outEll: ellipsod [1, 1] - external approximating ellipsoid.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

fstEllCentVec = fstEll.center;
fstEllShMat = fstEll.shape;
if rank(fstEllShMat) < size(fstEllShMat, 1)
    fstEllShMat = ell_inv(ellipsoid.regularize(fstEllShMat,fstEll.absTol));
else
    fstEllShMat = ell_inv(fstEllShMat);
end

if isa(secObj, 'hyperplane')
    [normHipVec, HipScalar] = parameters(-secObj);
    HipScalar      = HipScalar/sqrt(normHipVec'*normHipVec);
    normHipVec      = normHipVec/sqrt(normHipVec'*normHipVec);
    if (normHipVec'*fstEllCentVec > HipScalar) ...
            && ~(intersect(fstEll, secObj))
        outEll = fstEll;
        return;
    end
    if (normHipVec'*fstEllCentVec < HipScalar) ...
            && ~(intersect(fstEll, secObj))
        outEll = ellipsoid;
        return;
    end
    hEig  = 2*sqrt(maxeig(fstEll));
    qSecVec = HipScalar*normHipVec + hEig*normHipVec;
    QSecMat = (normHipVec*normHipVec')/(hEig^2);
    
    [qVec, QMat] = parameters(hpintersection(fstEll, secObj));
    qSecVec     = qVec + hEig*normHipVec;
else
    if fstEll == secObj
        outEll = fstEll;
        return;
    end
    if ~intersect(fstEll, secObj)
        outEll = ellipsoid;
        return;
    end
    qSecVec = secObj.center;
    QSecMat = secObj.shape;
    if rank(QSecMat) < size(QSecMat, 1)
        QSecMat = ell_inv(ellipsoid.regularize(QSecMat,secObj.absTol));
    else
        QSecMat = ell_inv(QSecMat);
    end
end

lambda = l_get_lambda(fstEllCentVec, fstEllShMat, qSecVec, ...]
    QSecMat, isa(secObj, 'hyperplane'));
XMat = lambda*fstEllShMat + (1 - lambda)*QSecMat;
XMat = 0.5*(XMat + XMat');
invXMat = ell_inv(XMat);
invXMat = 0.5*(invXMat + invXMat');
const = 1 - lambda*(1 - lambda)*(qSecVec - ...
    fstEllCentVec)'*QSecMat*invXMat*fstEllShMat*(qSecVec - fstEllCentVec);
qVec = invXMat*(lambda*fstEllShMat*fstEllCentVec + ...
    (1 - lambda)*QSecMat*qSecVec);
QMat = (1+fstEll.absTol)*const*invXMat;
outEll = ellipsoid(qVec, QMat);

end





%%%%%%%%

function lambda = l_get_lambda(fstEllCentVec, fstEllShMat, qSecVec, ...
    secQMat, flag)
%
% L_GET_LAMBDA - find parameter value for minimal volume ellipsoid.
%
% Input:
%   regular:
%       fstEllCentVec, qSecVec: double[nDims, 1]
%       fstEllShMat, secQMat: double[nDims, nDims]
%       flag: logical[1, 1]
%
% Output:
%    lambda: double[1, 1]
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

[lambda, fval] = fzero(@ell_fusionlambda, 0.5, [], ...
    fstEllCentVec, fstEllShMat, qSecVec, secQMat, size(fstEllCentVec, 1));

if (lambda < 0) || (lambda > 1)
    if flag || (det(fstEllShMat) > det(secQMat))
        lambda = 1;
    else
        lambda = 0;
    end
end

end





%%%%%%%%

function outEll = l_polyintersect(myEll, polyt)
%
% L_POLYINTERSECT - computes external ellipsoidal approximation of 
%                   intersection of single ellipsoid with single polytope.
%
% Input:
%   regular:
%       myEllMat: ellipsod [1, 1] - matrix of ellipsoids.
%       polyt: polytope [1, 1] - polytope.
%
% Output:
%    outEll: ellipsod [1, 1] - external approximating ellipsoid.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

outEll = myEll;
hyp = polytope2hyperplane(polyt);
nDimsHyp  = size(hyp, 2);

if isinside(myEll, polyt)
    outEll = getOutterEllipsoid(polyt);
    return;
end

for iDim = 1:nDimsHyp
    outEll = intersection_ea(outEll, hyp(iDim));
end

end
