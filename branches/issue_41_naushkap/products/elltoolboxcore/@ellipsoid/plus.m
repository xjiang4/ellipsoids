function res = plus(X, Y)
%
% PLUS - overloaded operator '+'.
%
% Description:
%    Operation
%              E + b
%    where E is an ellipsoid in R^n, and b - vector in R^n.
%    If E(q, Q) is an ellipsoid with center q and shape matrix Q, then
%          E(q, Q) + b = E(q + b, Q).
%
% Input:
%   regular:
%       E: ellipsoid [1, nCols] - array of ellipsoids of the same dimentions nDim.
%       Y: numeric[nDim, nCols] - matrix whose columns specify the vectors.
%
% Output:
%    res: ellipsoid [1, nCols] - ellipsoid or array of ellipsoids with same
%    shapes as E, but with centers shifted by vectors in Y.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  if isa(X, 'ellipsoid') & ~(isa(Y, 'double'))
    error('PLUS: this operation is only permitted between ellipsoid and vector in R^n.');
  end
  if isa(Y, 'ellipsoid') & ~(isa(X, 'double'))
    error('PLUS: this operation is only permitted between ellipsoid and vector in R^n.');
  end

  if isa(X, 'ellipsoid')
    E = X;
    b = Y;
  else
    E = Y;
    b = X;
  end

  d = dimension(E);
  m = max(d);
  n = min(d);
  if m ~= n
    error('PLUS: all ellipsoids in the array must be of the same dimension.');
  end

  [k, l] = size(b);
  if (l ~= 1) | (k ~= n)
    error('PLUS: vector dimension does not match.');
  end

  [m, n] = size(E);
  for i = 1:m
    for j = 1:n
      r(j)        = E(i, j);
      r(j).center = E(i, j).center + b;
    end
    if i == 1
      res = r;
    else
      res = [res; r];
    end
    clear r;
  end

  return;
