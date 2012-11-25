function isRes = isbigger(fstEll, secEll)
%
% ISBIGGER - checks if one ellipsoid would contain the other if their
%            centers would coincide.
%   RES = ISBIGGER(E1, E2)  Given two single ellipsoids of the same
%       dimension, E1 and E2, check if E1 would contain E2 inside if
%       they were both centered at origin.
%
% Input:
%   regular:
%       E1: ellipsod [1, 1] - first ellipsoid.
%       E2: ellipsod [1, 1] - second ellipsoid of the same dimention.
%
% Output:
%   isRes: logical[1, 1], 1 - if ellipsoid E1 would contain E2 inside,
%       0 - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror;

if ~(isa(fstEll, 'ellipsoid')) || ~(isa(secEll, 'ellipsoid'))
    throwerror('wrongInput', ...
        'ISBIGGER: both arguments must be single ellipsoids.');
end

[mFstEllRows, nFstEllCols] = size(fstEll);
[mSecEllRows, nSecEllCols] = size(secEll);
if (mFstEllRows > 1) || (nFstEllCols > 1) || (mSecEllRows > 1) ...
        || (nSecEllCols > 1)
    throwerror('wrongInput', ...
        'ISBIGGER: both arguments must be single ellipsoids.');
end

[nFstEllSpaceDim, nFstEllDim] = dimension(fstEll);
[nSecEllSpaceDim, nSecEllDim] = dimension(secEll);
if nFstEllSpaceDim ~= nSecEllSpaceDim
    throwerror('wrongSizes', ...
        'ISBIGGER: both ellipsoids must be of the same dimension.');
end
if nFstEllDim < nSecEllDim
    isRes = false;
    return;
end

fstEllShMat = fstEll.shape;
secEllShMat = secEll.shape;
if nFstEllDim < nFstEllSpaceDim
    if Properties.getIsVerbose()
        fprintf('ISBIGGER: Warning! First ellipsoid is degenerate.');
        fprintf('          Regularizing...');
    end
    fstEllShMat = ellipsoid.regularize(fstEllShMat,fstEll.absTol);
end

tMat = ell_simdiag(fstEllShMat, secEllShMat);
if max(abs(diag(tMat*secEllShMat*tMat'))) < (1 + fstEll.absTol)
    isRes = true;
else
    isRes = false;
end
