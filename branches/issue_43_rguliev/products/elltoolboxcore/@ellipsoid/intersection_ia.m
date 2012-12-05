function outEllArr = intersection_ia(myEllArr, objArr)
%
% INTERSECTION_IA - internal ellipsoidal approximation of the
%                   intersection of ellipsoid and ellipsoid,
%                   or ellipsoid and halfspace, or ellipsoid
%                   and polytope.
%
%   outEllMat = INTERSECTION_IA(myEllMat, objMat) - Given two
%       ellipsoidal matrixes of equal sizes, myEllMat and
%       objMat = ellMat, or, alternatively, myEllMat or ellMat must be
%       a single ellipsoid, comuptes the internal ellipsoidal
%       approximations of intersections of two corresponding ellipsoids
%       from myEllMat and from ellMat.
%   outEllMat = INTERSECTION_IA(myEllMat, objMat) - Given matrix of
%       ellipsoids myEllMat and matrix of hyperplanes objMat = hypMat
%       whose sizes match, computes the internal ellipsoidal
%       approximations of intersections of ellipsoids and halfspaces
%       defined by hyperplanes in hypMat.
%       If v is normal vector of hyperplane and c - shift,
%       then this hyperplane defines halfspace
%                  <v, x> <= c.
%   outEllMat = INTERSECTION_IA(myEllMat, objMat) - Given matrix of
%       ellipsoids  myEllMat and matrix of polytopes objMat = polyMat
%       whose sizes match, computes the internal ellipsoidal
%       approximations of intersections of ellipsoids myEllMat
%       and polytopes polyMat.
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
%       myEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%       objMat: ellipsoid [mRows, nCols] / hyperplane [mRows, nCols] /
%           / polytope [mRows, nCols]  - matrix of ellipsoids or
%           hyperplanes or polytopes of the same sizes.
%
% Output:
%    outEllMat: ellipsoid [mRows, nCols] - matrix of internal
%       approximating ellipsoids; entries can be empty ellipsoids
%       if the corresponding intersection is empty.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.throwerror;
import modgen.common.checkmultvar;

ellipsoid.checkIsMe(myEllArr,...
    'errorTag','wrongInput',...
    'errorMessage', 'first input argument must be ellipsoid.');
modgen.common.checkvar(objArr,@(x) isa(x, 'ellipsoid') ||...
    isa(x, 'hyperplane') || isa(x, 'polytope'),...
    'errorTag','wrongInput', 'errorMessage',...
    'second input argument must be ellipsoid,hyperplane or polytope.');

isPoly = isa(objArr, 'polytope');

nDimsArr  = dimension(myEllArr);
if isPoly
    nObjDimsArr = arrayfun(@(x) dimension(x), objArr);
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

nEllipsoids     = numel(myEllArr);
nObjects     = numel(objArr);

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
            eaEll = l_intersection_ia(singEll, obj);
        end
    end
end





%%%%%%%%

function outEll = l_intersection_ia(fstEll, secObj)
%
% L_INTERSECTION_IA - computes internal ellipsoidal approximation
%                     of intersection of single ellipsoid with single
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
%    outEll: ellipsod [1, 1] - internal approximating ellipsoid.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

if isa(secObj, 'ellipsoid')
    if fstEll == secObj
        outEll = fstEll;
    elseif ~intersect(fstEll, secObj)
        outEll = ellipsoid;
    else
        outEll = ellintersection_ia([fstEll secObj]);
    end
    return;
end

fstEllCentVec = fstEll.center;
fstEllShMat = fstEll.shape;
if rank(fstEllShMat) < size(fstEllShMat, 1)
    fstEllShMat = ell_inv(ellipsoid.regularize(fstEllShMat,...
        fstEll.absTol));
else
    fstEllShMat = ell_inv(fstEllShMat);
end

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

[intEllCentVec, intEllShMat] = parameters(hpintersection(fstEll, ...
    secObj));
[~, boundVec] = rho(fstEll, normHypVec);
hEig      = 2*sqrt(maxeig(fstEll));
secCentVec     = intEllCentVec + hEig*normHypVec;
secMat     = (normHypVec*normHypVec')/(hEig^2);
fstCoeff     = (fstEllCentVec - ...
    intEllCentVec)'*fstEllShMat*(fstEllCentVec - intEllCentVec);
secCoeff = (secCentVec - boundVec)'*secMat*(secCentVec - boundVec);
fstEllCoeff  = (1 - secCoeff)/(1 - fstCoeff*secCoeff);
secEllCoeff = (1 - fstCoeff)/(1 - fstCoeff*secCoeff);
intEllShMat      = fstEllCoeff*fstEllShMat + secEllCoeff*secMat;
intEllShMat      = 0.5*(intEllShMat + intEllShMat');
intEllCentVec      = ell_inv(intEllShMat)*...
    (fstEllCoeff*fstEllShMat*fstEllCentVec + ...
    secEllCoeff*secMat*secCentVec);
intEllShMat      = intEllShMat/(1 - ...
    (fstEllCoeff*fstEllCentVec'*fstEllShMat*fstEllCentVec + ...
    secEllCoeff*secCentVec'*secMat*secCentVec - ...
    intEllCentVec'*intEllShMat*intEllCentVec));
intEllShMat      = ell_inv(intEllShMat);
intEllShMat      = (1-fstEll.absTol)*0.5*(intEllShMat + intEllShMat');
outEll      = ellipsoid(intEllCentVec, intEllShMat);

end





%%%%%%%%

function outEll = l_polyintersect(myEll, polyt)
%
% L_POLYINTERSECT - computes internal ellipsoidal approximation of
%                   intersection of single ellipsoid with single polytope.
%
% Input:
%   regular:
%       myEllMat: ellipsod [1, 1] - matrix of ellipsoids.
%       polyt: polytope [1, 1] - polytope.
%
% Output:
%    outEll: ellipsod [1, 1] - internal approximating ellipsoid.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $


outEll = myEll;
hyp = polytope2hyperplane(polyt);
nDimsHyp  = size(hyp, 2);

for iDim = 1:nDimsHyp
    outEll = intersection_ia(outEll, hyp(iDim));
end

if isinside(myEll, polyt)
    outEll = getInnerEllipsoid(polyt);
    return;
end

end
