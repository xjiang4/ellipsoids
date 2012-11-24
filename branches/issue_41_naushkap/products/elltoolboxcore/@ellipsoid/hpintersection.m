function [intEllMat, isnIntersectedMat] = hpintersection(myEllMat, myHipMat)
%
% HPINTERSECTION - computes the intersection of ellipsoid with hyperplane.
%
% Input:
%   regular:
%       myEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%       myHipMat: hyperplane [mRows, nCols] - matrix of hyperplanes
%           of the same size.
%
% Output:
%   regular:
%       intEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids
%           resulting from intersections.
%
%   optional:
%       isnIntersectedMat - logical[mRows, nCols].
%           isnIntersectedMat(i, j) = true, if myEllMat(i, j) 
%           doesn't intersect myHipMat(i, j),
%           isnIntersectedMat(i, j) = false, otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror;

if ~(isa(myEllMat, 'ellipsoid')) || ~(isa(myHipMat, 'hyperplane'))
    fstErrMsg = 'HPINTERSECTION: first argument must be ellipsoid';
    secErrMsg = 'second argument - hyperplane.';
    throwerror('wrongInput', [fstErrMsg ', ' secErrMsg]);
end
if ndims(myEllMat) ~= 2
    throwerror('wrongInput:wrongDim','The dimension of input must be 2');
end;
if ndims(myHipMat) ~= 2
    throwerror('wrongInput:wrongDim','The dimension of input must be 2');
end;

[mEllRows, nEllCols] = size(myEllMat);
[mHipRows, nHipCols] = size(myHipMat);
nEllipsoids     = mEllRows * nEllCols;
nHiperplanes     = mHipRows * nHipCols;
if (nEllipsoids > 1) && (nHiperplanes > 1) && ...
        ((mEllRows ~= mHipRows) || (nEllCols ~= nHipCols))
    fstErrMsg = 'HPINTERSECTION: ';
    secErrMsg = 'sizes of ellipsoidal and hyperplane arrays do not match.';
    throwerror('wrongSizes', [fstErrMsg secErrMsg]);
end

isSecondOutput = nargout==2;

if (isSecondOutput)
    isnIntersectedMat = false(mEllRows, nEllCols);
end;

nEllDimsMat = dimension(myEllMat);
nHipDimsMat = dimension(myHipMat);
minEllDim   = min(min(nEllDimsMat));
minHipDim   = min(min(nHipDimsMat));
maxEllDim   = max(max(nEllDimsMat));
maxHipDim   = max(max(nHipDimsMat));
if (minEllDim ~= maxEllDim)
    throwerror('wrongSizes', ...
        'HPINTERSECTION: ellipsoids must be of the same dimension.');
end
if (minHipDim ~= maxHipDim)
    throwerror('wrongSizes', ...
        'HPINTERSECTION: hyperplanes must be of the same dimension.');
end

if Properties.getIsVerbose()
    if (nEllipsoids > 1) || (nHiperplanes > 1)
        fprintf('Computing %d ellipsoid-hyperplane intersections...\n',...
            max([nEllipsoids nHiperplanes]));
    else
        fprintf('Computing ellipsoid-hyperplane intersection...\n');
    end
end

intEllMat = [];
if (nEllipsoids > 1) && (nHiperplanes > 1)
    for iRow = 1:mEllRows
        intEll = [];
        for jCol = 1:nEllCols
            if distance(myEllMat(iRow, jCol), myHipMat(iRow, jCol)) > 0
                intEll = [intEll ellipsoid];
                if (~isSecondOutput)
                    throwerror('degenerateEllipsoid',...
                        'Hypeplane doesn''t intersect ellipsoid');
                else
                    isnIntersectedMat(iRow, jCol) = true;
                end;
            else
                intEll = [intEll ...
                    l_compute1intersection(myEllMat(iRow, jCol), ...
                    myHipMat(iRow, jCol), maxEllDim)];
            end
        end
        intEllMat = [intEllMat; intEll];
    end
elseif (nEllipsoids > 1)
    for iRow = 1:mEllRows
        intEll = [];
        for jCol = 1:nEllCols
            if distance(myEllMat(iRow, jCol), myHipMat) > 0
                intEll = [intEll ellipsoid];
            else
                intEll = [intEll ...
                    l_compute1intersection(myEllMat(iRow, jCol), ...
                    myHipMat, maxEllDim)];
            end
        end
        intEllMat = [intEllMat; intEll];
    end
else
    for iRow = 1:mHipRows
        intEll = [];
        for jCol = 1:nHipCols
            if distance(myEllMat, myHipMat(iRow, jCol)) > 0
                intEll = [intEll ellipsoid];
                if (~isSecondOutput)
                    throwerror('degenerateEllipsoid',...
                        'Hypeplane doesn''t intersect ellipsoid');
                else
                    isnIntersectedMat(iRow, jCol) = true;
                end;
            else
                intEll = [intEll ...
                    l_compute1intersection(myEllMat, myHipMat(iRow, jCol), ...
                    maxEllDim)];
            end
        end
        intEllMat = [intEllMat; intEll];
    end
end

end





%%%%%%%%

function intEll = l_compute1intersection(myEll, myHip, maxEllDim)
%
% L_COMPUTE1INTERSECTION - computes intersection of single ellipsoid with
%                          single hyperplane.
%
% Input:
%   regular:
%       myEll: ellipsoid [1, 1] - ellipsoid.
%       myHip: hyperplane [1, 1] - hyperplane.
%       maxEllDim: double [1, 1]
%
% Output:
%   regular:
%       intEll: ellipsoid [1, 1] - ellipsoid resulting from intersections.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;

[normHipVec, HipScalar] = parameters(myHip);
if HipScalar < 0
    normHipVec = - normHipVec;
    HipScalar = - HipScalar;
end
TMat = ell_valign([1; zeros(maxEllDim-1, 1)], normHipVec);
fscal = (HipScalar*TMat*normHipVec)/(normHipVec'*normHipVec);
myEll = TMat*myEll - fscal;
myEllcentVec = myEll.center;
myEllShMat = myEll.shape;

if rank(myEllShMat) < maxEllDim
    if Properties.getIsVerbose()
        fprintf('HPINTERSECTION: Warning! Degenerate ellipsoid.\n');
        fprintf('                Regularizing...\n');
    end
    myEllShMat = ellipsoid.regularize(myEllShMat,myEll.absTol);
end

invMyEllShMat   = ell_inv(myEllShMat);
invMyEllShMat   = 0.5*(invMyEllShMat + invMyEllShMat');
invShMatrixVec   = invMyEllShMat(2:maxEllDim, 1);
invShMatrixElem = invMyEllShMat(1, 1);
invMyEllShMat   = ell_inv(invMyEllShMat(2:maxEllDim, 2:maxEllDim));
invMyEllShMat   = 0.5*(invMyEllShMat + invMyEllShMat');
hscal   = (myEllcentVec(1, 1))^2 * (invShMatrixElem - ...
    invShMatrixVec'*invMyEllShMat*invShMatrixVec);
intEllcentVec   = myEllcentVec + myEllcentVec(1, 1)*...
    [-1; invMyEllShMat*invShMatrixVec];
intEllShMat   = (1 - hscal) * [0 zeros(1, maxEllDim-1); ...
    zeros(maxEllDim-1, 1) invMyEllShMat];
intEll   = ellipsoid(intEllcentVec, intEllShMat);
intEll   = ell_inv(TMat)*(intEll + fscal);
end
