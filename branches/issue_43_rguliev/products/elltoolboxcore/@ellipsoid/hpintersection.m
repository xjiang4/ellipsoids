function [intEllMat, isnIntersectedMat] = ...
    hpintersection(myEllMat, myHypMat)
%
% HPINTERSECTION - computes the intersection of ellipsoid with hyperplane.
%
% Input:
%   regular:
%       myEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%       myHypMat: hyperplane [mRows, nCols] - matrix of hyperplanes
%           of the same size.
%
% Output:
%   intEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids
%       resulting from intersections.
%
%   isnIntersectedMat: logical[mRows, nCols].
%       isnIntersectedMat(i, j) = true, if myEllMat(i, j)
%       doesn't intersect myHipMat(i, j),
%       isnIntersectedMat(i, j) = false, otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror;
import modgen.common.checkmultvar;

ellipsoid.checkIsMe(myEllMat,...
    'errorTag','wrongInput',...
    'errorMessage','first argument must be ellipsoid.');
modgen.common.checkvar(myHypMat,@(x) isa(x,'hyperplane'),...
    'errorTag','wrongInput',...
    'errorMessage','second argument must be hyperplane.');

if ndims(myEllMat) ~= 2
    throwerror('wrongInput:wrongDim','The dimension of input must be 2');
end;
if ndims(myHypMat) ~= 2
    throwerror('wrongInput:wrongDim','The dimension of input must be 2');
end;

[mEllRows, nEllCols] = size(myEllMat);
[mHipRows, nHipCols] = size(myHypMat);
nEllipsoids     = mEllRows * nEllCols;
nHiperplanes     = mHipRows * nHipCols;

checkmultvar('(x1==1)||(x2==1)||all(size(x3)==size(x4))',...
    4,nEllipsoids,nHiperplanes,myEllMat,myHypMat,...
    'errorTag','wrongSizes',...
    'errorMessage','sizes of ellipsoidal and hyperplane arrays do not match.');

isSecondOutput = nargout==2;

nEllDimsMat = dimension(myEllMat);
maxEllDim   = max(nEllDimsMat(:));

checkmultvar('all(x1(:)==x1(1))&&all(x2(:)==x2(1))',...
    2,nEllipsoids,nHiperplanes,myEllMat,myHypMat,...
    'errorTag','wrongSizes',...
    'errorMessage','ellipsoids and hyperplanes must be of the same dimension.');

if Properties.getIsVerbose()
    if (nEllipsoids > 1) || (nHiperplanes > 1)
        fprintf('Computing %d ellipsoid-hyperplane intersections...\n',...
            max([nEllipsoids nHiperplanes]));
    else
        fprintf('Computing ellipsoid-hyperplane intersection...\n');
    end
end

if (nEllipsoids > 1) && (nHiperplanes > 1)
    [intEllCMat isnInterCMat] = arrayfun(@(x,y) fSingleCase(x,y),...
        myEllMat,myHypMat,'UniformOutput',false);
    
    intEllMat = reshape([intEllCMat{:}],size(myEllMat));
    isnIntersectedMat = cell2mat(isnInterCMat);
elseif (nEllipsoids > 1)
    [intEllCMat isnInterCMat] = arrayfun(@(x) fSingleCase(x,myHypMat),...
        myEllMat,'UniformOutput',false);
    
    intEllMat = reshape([intEllCMat{:}],size(myEllMat));
    isnIntersectedMat = cell2mat(isnInterCMat);
else
    [intEllCMat isnInterCMat] = arrayfun(@(x) fSingleCase(myEllMat,x),...
        myHypMat,'UniformOutput',false);
    
    intEllMat = reshape([intEllCMat{:}],size(myHypMat));
    isnIntersectedMat = cell2mat(isnInterCMat);
end

    function [intEll isnInter] = fSingleCase(myEll, myHyp)
        if distance(myEll, myHyp) > 0
            if (~isSecondOutput)
                modgen.common.throwerror('degenerateEllipsoid',...
                    'Hypeplane doesn''t intersect ellipsoid');
            else
                intEll = ellipsoid;
                isnInter = true;
            end
        else
            intEll = l_compute1intersection(myEll,myHyp, maxEllDim);
            isnInter = false;
        end
    end
end





%%%%%%%%

function intEll = l_compute1intersection(myEll, myHyp, maxEllDim)
%
% L_COMPUTE1INTERSECTION - computes intersection of single ellipsoid with
%                          single hyperplane.
%
% Input:
%   regular:
%       myEll: ellipsoid [1, 1] - ellipsoid.
%       myHyp: hyperplane [1, 1] - hyperplane.
%       maxEllDim: double [1, 1] - maximum dimension of ellipsoids.
%
% Output:
%   intEll: ellipsoid [1, 1] - ellipsoid resulting from intersections.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;

[normHypVec, hypScalar] = parameters(myHyp);
if hypScalar < 0
    normHypVec = - normHypVec;
    hypScalar = - hypScalar;
end
tMat = ell_valign([1; zeros(maxEllDim-1, 1)], normHypVec);
rotVec = (hypScalar*tMat*normHypVec)/(normHypVec'*normHypVec);
myEll = tMat*myEll - rotVec;
myEllCentVec = myEll.center;
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
hCoefficient   = (myEllCentVec(1, 1))^2 * (invShMatrixElem - ...
    invShMatrixVec'*invMyEllShMat*invShMatrixVec);
intEllcentVec   = myEllCentVec + myEllCentVec(1, 1)*...
    [-1; invMyEllShMat*invShMatrixVec];
intEllShMat   = (1 - hCoefficient) * [0 zeros(1, maxEllDim-1); ...
    zeros(maxEllDim-1, 1) invMyEllShMat];
intEll   = ellipsoid(intEllcentVec, intEllShMat);
intEll   = ell_inv(tMat)*(intEll + rotVec);
end
