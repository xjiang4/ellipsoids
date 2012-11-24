function res = isinternal(myEllMat, matrixOfVecMat, mode)
%
% ISINTERNAL - checks if given points belong to the union or intersection
%              of ellipsoids in the given array.
%
%   RES = ISINTERNAL(E, X, s)  Checks if vectors specified as columns of
%       matrix X belong to the union (s = 'u'), or
%       intersection (s = 'i') of the ellipsoids in E.
%       If E is a single ellipsoid, then this function
%       checks if points in X belong to E or not.
%       Ellipsoids in E must be of the same dimension.
%       Column size of matrix X should match the dimension of ellipsoids.
%
%    Let E(q, Q) be an ellipsoid with center q and shape matrix Q.
%    Checking if given vector x belongs to E(q, Q) is equivalent to checking
%    if inequality
%                    <(x - q), Q^(-1)(x - q)> <= 1
%    holds.
%    If x belongs to at least one of the ellipsoids in the array, then it belongs
%    to the union of these ellipsoids. If x belongs to all ellipsoids in the array,
%    then it belongs to the intersection of these ellipsoids.
%    The default value of the specifier s = 'u'.
%
%    WARNING: be careful with degenerate ellipsoids.
%
% Input:
%   regular:
%       myEllMat: ellipsod [mRowsOfEllMat, nColsOfEllMat] - matrix of ellipsoids.
%       matrixOfVecMat: double [mRows, nColsOfVec] - matrix which specifiy points.
%
%   properties:
%       mode: char[1, 1] - 'u' or 'i', go to description.
%
% Output:
%    res: double[1, nColsOfVec] -
%       1 - if vector belongs to the union or intersection of ellipsoids,
%       0 - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror;

if ~isa(myEllMat, 'ellipsoid')
    fstErrMsg = 'ISINTERNAL: first argument must be an ellipsoid, ';
    secErrMsg = 'or an array of ellipsoids.';
    throwerror('wrongInput', [fstErrMsg secErrMsg]);
end

nDims = dimension(myEllMat);
maxDim    = min(min(nDims));
minDim    = max(max(nDims));
if maxDim ~= minDim
    throwerror('wrongSizes', ...
        'ISINTERNAL: ellipsoids must be of the same dimension.');
end

if ~(isa(matrixOfVecMat, 'double'))
    throwerror('wrongInput', ...
        'ISINTERNAL: second argument must be an array of vectors.');
end

if (nargin < 3) || ~(ischar(mode))
    mode = 'u';
end

if (mode ~= 'u') && (mode ~= 'i')
    fstErrMsg = 'ISINTERNAL: third argument is expected ';
    secErrMsg = 'to be either ''u'', or ''i''.';
    throwerror('wrongInput', [fstErrMsg secErrMsg]);
end

[mRows, nCols] = size(matrixOfVecMat);
if mRows ~= minDim
    throwerror('wrongInput', ...
        'ISINTERNAL: dimensions of ellipsoid and vector do not match.');
end

res=zeros(1,nCols);
for iCol = 1:nCols
    res(iCol) = isinternal_sub(myEllMat, matrixOfVecMat(:, iCol), mode, mRows);
end

end



%%%%%%%%

function res = isinternal_sub(myEllMat, xVec, mode, mRows)
%
% ISINTERNAL_SUB - compute result for single vector.
%
% Input:
%   regular:
%       myEllMat: ellipsod [mRowsOfEllMat, nColsOfEllMat] - matrix of ellipsoids.
%       xVec: double [mRows, 1] - matrix which specifiy points.
%       mRows: double[1, 1] - dimension of ellipsoids in myEllMat and xVec.
%
%   properties:
%       mode: char[1, 1] - 'u' or 'i', go to description.
%
% Output:
%    res: double[1, nColsOfVec] -
%       1 - if vector belongs to the union or intersection of ellipsoids,
%       0 - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;

if mode == 'u'
    res = 0;
else
    res = 1;
end

absTolMat = getAbsTol(myEllMat);
[mEllRows, nEllCols] = size(myEllMat);
for iEllRow = 1:mEllRows
    for jEllCol = 1:nEllCols
        qVec = xVec - myEllMat(iEllRow, jEllCol).center;
        QMat = myEllMat(iEllRow, jEllCol).shape;
        
        if rank(QMat) < mRows
            if Properties.getIsVerbose()
                fprintf('ISINTERNAL: Warning! There is degenerate ellipsoid in the array.\n');
                fprintf('            Regularizing...\n');
            end
            QMat = ellipsoid.regularize(QMat,absTolMat(iEllRow,jEllCol));
        end
        
        rScal = qVec' * ell_inv(QMat) * qVec;
        if (mode == 'u')
            if (rScal < 1) | (abs(rScal - 1) < absTolMat(iEllRow,jEllCol))
                res = 1;
                return;
            end
        else
            if (rScal > 1) & (abs(rScal - 1) > absTolMat(iEllRow,jEllCol))
                res = 0;
                return;
            end
        end
    end
end

end
