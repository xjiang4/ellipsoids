function res = ge(E1, E2)
%
% GE - checks if the first ellipsoid is bigger than the second one.
%
% Description:
%    Same as GT.
%
% Input:
%   regular:
%       E1: ellipsoid [mRows, nCols] - array of ellipsoids.
%       E2: ellipsoid [mRows, nCols] - array of ellipsoids of the corresponding
%       dimensions.
%
% Output:
%    res: logical[mRows, nCols], 1 - if E1 contains E2 when both have same center,
%         0 - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  res = gt(E1, E2);

  return;
