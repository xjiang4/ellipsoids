function res = ne(E1, E2)
%
% NE - overloaded operator '~=', it checs if two ellipsoids are not equal.
%
% Description:
%    The opposite of EQ.
%
% Input:
%   regular:
%       E1: ellipsoid [mRows, nCols] - array of ellipsoids.
%       E2: ellipsoid [mRows, nCols] - array of ellipsoids of the corresponding
%       dimensions.
%
% Output:
%    res: logical[mRows, nCols], 0 - if E1 == E2, 1 - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  res = ~(eq(E1, E2));

  return;
