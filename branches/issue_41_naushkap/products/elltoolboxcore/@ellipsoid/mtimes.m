function res = mtimes(A, E)
import modgen.common.throwerror;
%
% MTIMES - overloaded operator '*'.
%
% Description:
%    Multiplication of the ellipsoid by a matrix or a scalar.
%    If E(q,Q) is an ellipsoid, and A - matrix of suitable dimensions,
%    then
%          A E(q, Q) = E(Aq, AQA').
%
% Input:
%   regular:
%       A: numeric[mRows, nDim] / [1, 1] - scalar or matrix in R^{mRows x nDim}
%       E: ellipsoid [1, nCols] - ellipsoid or array of ellipsoids.
%
% Output:
%    res: ellipsoid [1, nCols] - resulting ellipsoids.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  if ~(isa(A, 'double')) | ~(isa(E, 'ellipsoid'))
    throwerror('wrongInput', 'MTIMES: first multiplier is expected to be a matrix or a scalar,\n        and second multiplier - an ellipsoid.');
  end

  [m, n] = size(A); 
  d      = dimension(E);
  k      = max(d);
  l      = min(d);
  if ((k ~= l) & (n ~= 1) & (m ~= 1)) | ((k ~= n) & (n ~= 1) & (m ~= 1))
    throwerror('wrongSizes', 'MTIMES: dimensions do not match.');
  end

  [m, n] = size(E);
  for i = 1:m
    for j = 1:n
     Q    = A*(E(i, j).shape)*A';
     Q    = 0.5*(Q + Q');
     r(j) = ellipsoid(A*(E(i, j).center), Q);
    end
    if i == 1
      res = r;
    else
      res = [res; r];
    end
    clear r;
  end

  return;
