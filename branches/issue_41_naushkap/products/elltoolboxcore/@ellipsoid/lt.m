function res = lt(E1, E2)
%
% LT - checks if the second ellipsoid is bigger than the first one.
%
% Description:
%    The opposite of GT.
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

  res = gt(E2, E1);

  return;
