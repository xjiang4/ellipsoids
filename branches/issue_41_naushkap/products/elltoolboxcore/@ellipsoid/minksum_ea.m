function extApprEllVec = minksum_ea(inpEllMat, dirMat)
%
% MINKSUM_EA - computation of external approximating ellipsoids
%              of the geometric sum of ellipsoids in given directions.
%
%   EA = MINKSUM_EA(E, L)  Computes tight external approximating
%       ellipsoids for the geometric sum of the ellipsoids in the
%       array E in directions specified by columns of L.
%       If ellipsoids in E are n-dimensional, matrix L must have
%       dimension (n x k) where k can be arbitrarily chosen.
%       In this case, the output of the function will contain k
%       ellipsoids computed for k directions specified in L.
%
%   Let E(q1, Q1), E(q2, Q2), ..., E(qm, Qm) be ellipsoids in R^n,
%   and l - some vector in R^n. Then tight external approximating
%   ellipsoid E(q, Q) for the geometric sum
%   E(q1, Q1) + E(q2, Q2) + ... + E(qm, Qm) in direction l,
%   is such that
%       rho(l | E(q, Q)) = rho(l | (E(q1, Q1) + ... + E(qm, Qm)))
%   and is defined as follows:
%       q = q1 + q2 + ... + qm,
%       Q = (p1 + ... + pm)((1/p1)Q1 + ... + (1/pm)Qm),
%   where
%       p1 = sqrt(<l, Q1l>), ..., pm = sqrt(<l, Qml>).
%
% Input:
%   regular:
%       inpEllMat: ellipsoid [mRows, nColsInpEllMatrix] - matrix
%           of ellipsoids of the same dimentions.
%       dirMat: numeric[nDims, nCols] - matrix whose columns specify
%           the directions for which the approximations
%           should be computed.
%
% Output:
%   extApprEllVec: ellipsoid [1, nCols] - array external
%       approximating ellipsoids.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror;
%
if ~(isa(inpEllMat, 'ellipsoid'))
    throwerror('wrongInput', ...
        'MINKSUM_EA: first argument must be array of ellipsoids.');
end

nDimsInpEllMat = dimension(inpEllMat);
minDim = min(min(nDimsInpEllMat));
maxDim = max(max(nDimsInpEllMat));
if minDim ~= maxDim
    fstStr = 'MINKSUM_EA: ellipsoids in the array must be ';
    secStr = 'of the same dimension.';
    throwerror('wrongSizes', [fstStr secStr]);
end

[nDims, nCols] = size(dirMat);
if (nDims ~= maxDim)
    msg = ...
        sprintf('MINKSUM_EA: second argument must be vector(s) in R^%d.',...
        maxDim);
    throwerror(msg);
end

[mRows, nColsInpEllMatrix] = size(inpEllMat);
if (mRows == 1) && (nColsInpEllMatrix == 1)
    extApprEllVec = inpEllMat;
    return;
end
%
extApprEllVec(nCols) = ellipsoid();
absTolMat = getAbsTol(inpEllMat);
for iCol = 1:nCols
    dirVec = dirMat(:, iCol);
    for iRow = 1:mRows
        for jColsInpEllMatrix = 1:nColsInpEllMatrix
            shMat = inpEllMat(iRow, jColsInpEllMatrix).shape;
            if size(shMat, 1) > rank(shMat)
                if Properties.getIsVerbose()
                    fprintf('MINKSUM_EA: Warning! Degenerate ');
                    fprintf('ellipsoid.\n            Regularizing...\n');
                end
                shMat = ellipsoid.regularize(shMat, ...
                    absTolMat(iRow,jColsInpEllMatrix));
            end
            
            fstCoef = sqrt(dirVec'*shMat*dirVec);
            
            if (iRow == 1) && (jColsInpEllMatrix == 1)
                centVec = inpEllMat(iRow, jColsInpEllMatrix).center;
                subShMat = (1/fstCoef) * shMat;
                secCoef = fstCoef;
            else
                centVec = centVec + ...
                    inpEllMat(iRow, jColsInpEllMatrix).center;
                subShMat = subShMat + ((1/fstCoef) * shMat);
                secCoef = secCoef + fstCoef;
            end
        end
    end
    subShMat  = 0.5*secCoef*(subShMat + subShMat');
    extApprEllVec(iCol) = ellipsoid(centVec, subShMat);
end
