function intApprEllVec = minkdiff_ia(fstEll, secEll, directionsMat)
%
% MINKDIFF_IA - computation of internal approximating ellipsoids
%               of the geometric difference of two ellipsoids in
%               given directions.
%
%   intApprEllVec = MINKDIFF_IA(fstEll, secEll, directionsMat) -
%       Computes internal approximating ellipsoids of the geometric
%       difference of two ellipsoids fstEll - secEll in directions
%       specified by columns of matrix directionsMat.
%
%   First condition for the approximations to be computed, is that
%   ellipsoid fstEll must be bigger than ellipsoid secEll in the
%   sense that if they had the same center, secEll would be contained
%   inside fstEll. Otherwise, the geometric difference
%   fstEll - secEll is an empty set. Second condition for the
%   approximation in the given direction lVec to exist,
%   is the following. Given
%       param = sqrt(<lVec, fstShMat lVec>)/sqrt(<lVec, secShMat lVec>)
%   where fstShMat is the shape matrix of ellipsoid fstEll,
%   and secShMat - shape matrix of secEll, and minRoot being minimal
%   root of the equation
%       det(fstShMat - minRoot secShMat) = 0,
%   parameter param should be less than minRoot.
%   If these two conditions are satisfied, then internal approximating
%   ellipsoid for the geometric difference fstEll - secEll in the
%   direction lVec
%   is defined by its shape matrix
%       shMat = (1 - (1/param)) fstShMat + (1 - param) secShMat
%   and its center
%       centVec = fstCentVec - secCentVec,
%   where fstCentVec is center of fstEll and
%   secCentVec - center of secEll.
%
% Input:
%   regular:
%       fstEll: ellipsoid [1, 1] - first ellipsoid. Suppose
%           nDim - space dimension.
%       secEll: ellipsoid [1, 1] - second ellipsoid
%           of the same dimention.
%       directionsMat: double[nDim, nCols] - matrix whose columns
%           specify the directions for which the approximations
%           should be computed.
%
% Output:
%   intApprEllVec: ellipsoid [1, nCols] - array of internal
%       approximating ellipsoids (empty, if for all specified directions
%       approximations cannot be computed).
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.throwerror;
import elltool.conf.Properties;

if ~(isa(fstEll, 'ellipsoid')) || ~(isa(secEll, 'ellipsoid'))
    fstStr = 'MINKDIFF_IA: first and second arguments must ';
    secStr = 'be single ellipsoids.';
    throwerror('wrongInput', [fstStr secStr]);
end

[mRowsFstEll, nColsFstEll] = size(fstEll);
[mRowsSecEll, nColsSecEll] = size(secEll);
if (mRowsFstEll ~= 1) || (nColsFstEll ~= 1) || ...
        (mRowsSecEll ~= 1) || (nColsSecEll ~= 1)
    fstStr = 'MINKDIFF_IA: first and second arguments must ';
    secStr = 'be single ellipsoids.';
    throwerror('wrongInput', [fstStr secStr]);
end

intApprEllVec = [];

if isbigger(fstEll, secEll) == false
    if Properties.getIsVerbose()
        fstStr = 'MINKDIFF_IA: geometric difference of these two ';
        secStr = 'ellipsoids is empty set.\n';
        fprintf([fstStr secStr]);
    end
    return;
end

nRowsDirMat = size(directionsMat, 1);
nDims = dimension(fstEll);
if nRowsDirMat ~= nDims
    fstStr = 'MINKDIFF_IA: dimension of the direction vectors must ';
    secStr = 'be the same as dimension of ellipsoids.';
    throwerror('wrongSizes', [fstStr secStr]);
end
centVec = fstEll.center - secEll.center;
fstEllShMat = fstEll.shape;
if rank(fstEllShMat) < size(fstEllShMat, 1)
    fstEllShMat = ellipsoid.regularize(fstEllShMat,fstEll.absTol);
end
secEllShMat = secEll.shape;
if rank(secEllShMat) < size(secEllShMat, 1)
    secEllShMat = ellipsoid.regularize(secEllShMat,secEll.absTol);
end
directionsMat  = ellipsoid.rm_bad_directions(fstEllShMat, ...
    secEllShMat, directionsMat);
nColsDirMat  = size(directionsMat, 2);
if nColsDirMat < 1
    if Properties.getIsVerbose()
        fprintf('MINKDIFF_IA: cannot compute internal approximation');
        fprintf(' for any\n             of the specified directions.\n');
    end
    return;
end
for iCol = 1:nColsDirMat
    nColsFstEll  = directionsMat(:, iCol);
    coef = (sqrt(nColsFstEll'*fstEllShMat*nColsFstEll))/...
        (sqrt(nColsFstEll'*secEllShMat*nColsFstEll));
    shMat = (1 - (1/coef))*fstEllShMat + (1 - coef)*secEllShMat;
    intApprEllVec = [intApprEllVec ellipsoid(centVec, shMat)];
end
