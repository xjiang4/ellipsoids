function res = eq(E1, E2)
import modgen.common.throwerror;
%
% EQ - overloaded operator '==', it checks if two ellipsoids are equal.
%
% Input:
%   regular:
%       E1: ellipsoid [mRows, nCols] - array of ellipsoids.
%       E2: ellipsoid [mRows, nCols] - array of ellipsoids of the corresponding
%       dimensions.
%
% Output:
%    res: logical[mRows, nCols], 1 - if E1 == E2, 0 - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  global ellOptions;

  if ~isstruct(ellOptions)
    evalin('base', 'ellipsoids_init;');
  end

  if ~(isa(E1, 'ellipsoid')) | ~(isa(E2, 'ellipsoid'))
    throwerror('wrongInput', '==: both arguments must be ellipsoids.');
  end

  [k, l] = size(E1);
  s      = k * l;
  [m, n] = size(E2);
  t      = m * n;

  if ((k ~= m) | (l ~= n)) & (s > 1) & (t > 1)
    throwerror('wrongSizes', '==: sizes of ellipsoidal arrays do not match.');
  end

  res = [];
  if (s > 1) & (t > 1)
    for i = 1:m
      r = [];
      for j = 1:n
        if dimension(E1(i, j)) ~= dimension(E2(i, j))
          r = [r 0];
          continue;
        end
        q = E1(i, j).center - E2(i, j).center;
        Q = E1(i, j).shape - E2(i, j).shape;
        if (norm(q) > ellOptions.abs_tol) | (norm(Q) > ellOptions.abs_tol)
          r = [r 0];
        else
          r = [r 1];
        end
      end
      res = [res; r];
    end
  elseif (s > 1)
    for i = 1:k
      r = [];
      for j = 1:l
        if dimension(E1(i, j)) ~= dimension(E2)
          r = [r 0];
          continue;
        end
        q = E1(i, j).center - E2.center;
        Q = E1(i, j).shape - E2.shape;
        if (norm(q) > ellOptions.abs_tol) | (norm(Q) > ellOptions.abs_tol)
          r = [r 0];
        else
          r = [r 1];
        end
      end
      res = [res; r];
    end
  else
    for i = 1:m
      r = [];
      for j = 1:n
        if dimension(E1) ~= dimension(E2(i, j))
          r = [r 0];
          continue;
        end
        q = E1.center - E2(i, j).center;
        Q = E1.shape - E2(i, j).shape;
        if (norm(q) > ellOptions.abs_tol) | (norm(Q) > ellOptions.abs_tol)
          r = [r 0];
        else
          r = [r 1];
        end
      end
      res = [res; r];
    end
  end

  return; 
