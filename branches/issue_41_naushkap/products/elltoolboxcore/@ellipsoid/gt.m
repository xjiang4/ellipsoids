function res = gt(E1, E2)
import modgen.common.throwerror;
%
% GT - checks if the first ellipsoid is bigger than the second one.
%
% Description:
%    See ISBIGGER for details.
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

  if ~(isa(E1, 'ellipsoid')) | ~(isa(E2, 'ellipsoid'))
    throwerror('wrongInput', '<>: both input arguments must be ellipsoids.');
  end

  [k, l] = size(E1);
  s      = k * l;
  [m, n] = size(E2);
  t      = m * n;

  if ((k ~= m) | (l ~= n)) & (s > 1) & (t > 1)
    throwerror('wrongSizes', '<>: sizes of ellipsoidal arrays do not match.');
  end

  res = [];
  if (s > 1) & (t > 1)
    for i = 1:m
      r = [];
      for j = 1:n
        r = [r isbigger(E1(i, j), E2(i, j))];
      end
      res = [res; r];
    end
  elseif (s > 1)
    for i = 1:k
      r = [];
      for j = 1:l
        r = [r isbigger(E1(i, j), E2)];
      end
      res = [res; r];
    end
  else
    for i = 1:m
      r = [];
      for j = 1:n
        r = [r isbigger(E1, E2(i, j))];
      end
      res = [res; r];
    end
  end

  return;
