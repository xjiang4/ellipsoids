function outEllArr = intersection_ea(myEllArr, objArr)
%
% INTERSECTION_EA - external ellipsoidal approximation of the
%                   intersection of two ellipsoids, or ellipsoid and
%                   halfspace, or ellipsoid and polytope.
%
%   outEllArr = INTERSECTION_EA(myEllArr, objArr) Given two ellipsoidal
%       matrixes of equal sizes, myEllArr and objArr = ellArr, or,
%       alternatively, myEllArr or ellMat must be a single ellipsoid,
%       computes the ellipsoid that contains the intersection of two
%       corresponding ellipsoids from myEllArr and from ellArr.
%   outEllArr = INTERSECTION_EA(myEllArr, objArr) Given matrix of
%       ellipsoids myEllArr and matrix of hyperplanes objArr = hypArr
%       whose sizes match, computes the external ellipsoidal
%       approximations of intersections of ellipsoids
%       and halfspaces defined by hyperplanes in hypArr.
%       If v is normal vector of hyperplane and c - shift,
%       then this hyperplane defines halfspace
%               <v, x> <= c.
%   outEllArr = INTERSECTION_EA(myEllArr, objArr) Given matrix of
%       ellipsoids myEllArr and matrix of polytopes objArr = polyArr
%       whose sizes match, computes the external ellipsoidal
%       approximations of intersections of ellipsoids myEllMat and
%       polytopes polyArr.
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
%       myEllArr: ellipsoid [] - array of ellipsoids.
%       objArr: ellipsoid [] / hyperplane [] /
%           / polytope []  - array of ellipsoids or
%           hyperplanes or polytopes of the same sizes.
%
% Output:
%    outEllMat: ellipsoid [] - array of external
%       approximating ellipsoids; entries can be empty ellipsoids
%       if the corresponding intersection is empty.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.throwerror;
import modgen.common.checkmultvar;

ellipsoid.checkIsMe(myEllArr,'first');
modgen.common.checkvar(objArr,@(x) isa(x, 'ellipsoid') ||...
    isa(x, 'hyperplane') || isa(x, 'polytope'),...
    'errorTag','wrongInput', 'errorMessage',...
    'second input argument must be ellipsoid,hyperplane or polytope.');

isPoly = isa(objArr, 'polytope');

nDimsArr  = dimension(myEllArr);
if isPoly
    nObjDimsArr = arrayfun(@(x) dimension(x),objArr);
else
    nObjDimsArr = dimension(objArr);
end

checkmultvar( '(numel(x1)==1)||(numel(x2)==1)&&all(size(x1)==size(x2) )',...
	2,myEllArr,objArr,...
    'errorTag','wrongSizes',...
    'errorMessage','sizes of input arrays do not match.');

checkmultvar('(x1(1)==x2(1))&&all(x1(:)==x1(1))&&all(x2(:)==x2(1))',...
	2,nDimsArr,nObjDimsArr,...
    'errorTag','wrongSizes',...
    'errorMessage','input arguments must be of the same dimension.');

nEllipsoids = numel(myEllArr);
nObjects = numel(objArr);

if (nEllipsoids > 1) && (nObjects > 1)
    outEllCArr = arrayfun(@(x,y) fCoose(x, y),myEllArr,objArr,...
        'UniformOutput',false);
    outEllArr = reshape([outEllCArr{:}],size(myEllArr));
elseif nEllipsoids > 1
    outEllCArr = arrayfun(@(x) fCoose(x, objArr),myEllArr,...
        'UniformOutput',false);
    outEllArr = reshape([outEllCArr{:}],size(myEllArr));
else
    outEllCArr = arrayfun(@(x) fCoose(myEllArr, x), objArr,...
        'UniformOutput',false);
    outEllArr = reshape([outEllCArr{:}],size(objArr));
end
    function eaEll = fCoose(singEll, obj)
        if isPoly
            eaEll = l_polyintersect(singEll, obj);
        else
            eaEll = l_intersection_ea(singEll, obj);
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
%       secObj: ellipsoid [1, 1]/hyperplane [1, 1] - ellipsoidal
%           matrix or matrix of hyperplanes of the same sizes.
%
% Output:
%    outEll: ellipsod [1, 1] - external approximating ellipsoid.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

fstEllCentVec = fstEll.center;
fstEllShMat = fstEll.shape;
if rank(fstEllShMat) < size(fstEllShMat, 1)
    fstEllShMat = ...
        ell_inv(ellipsoid.regularize(fstEllShMat,fstEll.absTol));
else
    fstEllShMat = ell_inv(fstEllShMat);
end

if isa(secObj, 'hyperplane')
    [normHypVec, hypScalar] = parameters(-secObj);
    hypScalar      = hypScalar/sqrt(normHypVec'*normHypVec);
    normHypVec      = normHypVec/sqrt(normHypVec'*normHypVec);
    if (normHypVec'*fstEllCentVec > hypScalar) ...
            && ~(intersect(fstEll, secObj))
        outEll = fstEll;
        return;
    end
    if (normHypVec'*fstEllCentVec < hypScalar) ...
            && ~(intersect(fstEll, secObj))
        outEll = ellipsoid;
        return;
    end
    hEig  = 2*sqrt(maxeig(fstEll));
    qSecVec = hypScalar*normHypVec + hEig*normHypVec;
    seqQMat = (normHypVec*normHypVec')/(hEig^2);
    
    [qCenterVec, shQMat] = parameters(hpintersection(fstEll, secObj));
    qSecVec     = qCenterVec + hEig*normHypVec;
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
    seqQMat = secObj.shape;
    if rank(seqQMat) < size(seqQMat, 1)
        seqQMat = ell_inv(ellipsoid.regularize(seqQMat,secObj.absTol));
    else
        seqQMat = ell_inv(seqQMat);
    end
end

lambda = l_get_lambda(fstEllCentVec, fstEllShMat, qSecVec, ...]
    seqQMat, isa(secObj, 'hyperplane'));
xMat = lambda*fstEllShMat + (1 - lambda)*seqQMat;
xMat = 0.5*(xMat + xMat');
invXMat = ell_inv(xMat);
invXMat = 0.5*(invXMat + invXMat');
const = 1 - lambda*(1 - lambda)*(qSecVec - ...
    fstEllCentVec)'*seqQMat*invXMat*fstEllShMat*(qSecVec - fstEllCentVec);
qCenterVec = invXMat*(lambda*fstEllShMat*fstEllCentVec + ...
    (1 - lambda)*seqQMat*qSecVec);
shQMat = (1+fstEll.absTol)*const*invXMat;
outEll = ellipsoid(qCenterVec, shQMat);

end





%%%%%%%%

function lambda = l_get_lambda(fstEllCentVec, fstEllShMat, qSecVec, ...
    secQMat, isFlag)
%
% L_GET_LAMBDA - find parameter value for minimal volume ellipsoid.
%
% Input:
%   regular:
%       fstEllCentVec, qSecVec: double[nDims, 1]
%       fstEllShMat, secQMat: double[nDims, nDims]
%       isFlag: logical[1, 1]
%
% Output:
%    lambda: double[1, 1] - parameter value for minimal volume ellipsoid.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

[lambda, fVal] = fzero(@ell_fusionlambda, 0.5, [], ...
    fstEllCentVec, fstEllShMat, qSecVec, secQMat, size(fstEllCentVec, 1));

if (lambda < 0) || (lambda > 1)
    if isFlag || (det(fstEllShMat) > det(secQMat))
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

for iElem = 1:nDimsHyp
    outEll = intersection_ea(outEll, hyp(iElem));
end

end
