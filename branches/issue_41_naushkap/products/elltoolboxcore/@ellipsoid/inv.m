function invEll = inv(myEll)
%
% INV - inverts shape matrices of ellipsoids in the given array.
%   I = INV(myEll)  Inverts shape matrices of ellipsoids in the
%       array myEll. In case shape matrix is sigular, it is
%       regularized before inversion.
%
% Input:
%   regular:
%       myEll: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%
% Output:
%    invEll: ellipsoid [mRows, nCols] - matrix of ellipsoids with inverted
%       shape matrices.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.throwerror;

if ~(isa(myEll, 'ellipsoid'))
    throwerror('wrongInput', ...
        'INV: input argument must be array of ellipsoids.');
end

invEll      = myEll;
[mRows, nCols] = size(invEll);

absTolMat = getAbsTol(invEll);
for iRow = 1:mRows
    for jCol = 1:nCols
        if isdegenerate(invEll(iRow, jCol))
            regShMat = ellipsoid.regularize(invEll(iRow, jCol).shape, ...
                absTolMat(iRow,jCol));
        else
            regShMat = invEll(iRow, jCol).shape;
        end
        regShMat = ell_inv(regShMat);
        invEll(iRow, jCol).shape = 0.5*(regShMat + regShMat');
    end
end
