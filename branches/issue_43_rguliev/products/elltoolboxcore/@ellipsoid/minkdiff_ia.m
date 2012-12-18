function intApprEllVec = minkdiff_ia(fstEll, secEll, directionsMat)
%
% MINKDIFF_IA - computation of internal approximating ellipsoids
%               of the geometric difference of two ellipsoids along
%               given directions.
%
%   intApprEllVec = MINKDIFF_IA(fstEll, secEll, directionsMat) -
%       Computes internal approximating ellipsoids of the geometric
%       difference of two ellipsoids fstEll - secEll along directions
%       specified by columns of matrix directionsMat.
%
%   First condition for the approximations to be computed, is that
%   ellipsoid fstEll = E1 must be bigger than ellipsoid secEll = E2
%   in the sense that if they had the same center, E2 would be contained
%   inside E1. Otherwise, the geometric difference E1 - E2 is an
%   empty set. Second condition for the approximation in the given
%   direction l to exist, is the following. Given
%       P = sqrt(<l, Q1 l>)/sqrt(<l, Q2 l>)
%   where Q1 is the shape matrix of ellipsoid E1,
%   and Q2 - shape matrix of E2, and R being minimal root of the equation
%       det(Q1 - R Q2) = 0,
%   parameter P should be less than R.
%   If these two conditions are satisfied, then internal approximating
%   ellipsoid for the geometric difference E1 - E2 along the
%   direction l is defined by its shape matrix
%       Q = (1 - (1/P)) Q1 + (1 - P) Q2
%   and its center
%       q = q1 - q2,
%   where q1 is center of E1 and q2 - center of E2.
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
import modgen.common.checkmultvar;
import elltool.conf.Properties;

ellipsoid.checkIsMe(fstEll,'first');
ellipsoid.checkIsMe(secEll,'second');
checkmultvar('isscalar(x1)&&isscalar(x2)',2,fstEll,secEll,...
    'errorTag','wrongInput','errorMessage',...
    'first and second arguments must be single ellipsoids.')

intApprEllVec = [];

if ~isbigger(fstEll, secEll)
    if Properties.getIsVerbose()
        fstStr = 'MINKDIFF_IA: geometric difference of these two ';
        secStr = 'ellipsoids is empty set.\n';
        fprintf([fstStr secStr]);
    end
    return;
end

checkmultvar('(x1==x2)',2,dimension(fstEll),size(directionsMat, 1),...
    'errorTag','wrongSizes','errorMessage',...
    'direction vectors ans ellipsoids dimensions mismatch.');

centVec = fstEll.center - secEll.center;
fstEllShMat = fstEll.shape;
if isdegenerate(fstEll)
    fstEllShMat = ellipsoid.regularize(fstEllShMat,fstEll.absTol);
end
secEllShMat = secEll.shape;
if isdegenerate(secEll)
    secEllShMat = ellipsoid.regularize(secEllShMat,secEll.absTol);
end
directionsMat  = ellipsoid.rm_bad_directions(fstEllShMat, ...
    secEllShMat, directionsMat);
nDirs  = size(directionsMat, 2);
if nDirs < 1
    if Properties.getIsVerbose()
        fprintf('MINKDIFF_IA: cannot compute internal approximation');
        fprintf(' for any\n             of the specified directions.\n');
    end
    return;
end

intApprEllVec = repmat(ellipsoid,1, nDirs);
arrayfun(@(x) fSingleDir(x), 1:nDirs)
    function fSingleDir(index)
        dirVec  = directionsMat(:, index);
        coef = (sqrt(dirVec'*fstEllShMat*dirVec))/...
            (sqrt(dirVec'*secEllShMat*dirVec));
        shMat = (1 - (1/coef))*fstEllShMat + (1 - coef)*secEllShMat;
        intApprEllVec(index).center = centVec;
        intApprEllVec(index).shape = shMat;
    end
end