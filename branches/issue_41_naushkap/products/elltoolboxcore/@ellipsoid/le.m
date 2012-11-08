function res = le(E1, E2)
%
% LE - checks if the second ellipsoid is bigger than the first one.
%
% Description:
%    Same as LT.
%
% Input:
%   regular:
%       E1: ellipsoid [mRows, nCols] - array of ellipsoids.
%       E2: ellipsoid [mRows, nCols] - array of ellipsoids of the corresponding
%       dimensions.
%
% Output:
%    res: logical[mRows, nCols], 1 - if E2 contains E1 when both have same center,
%         0 - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  res = lt(E1, E2);

  return;
