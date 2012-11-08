function T = trace(E)
%
% TRACE - returns the trace of the ellipsoid.
%
% Description:
%    T = TRACE(E)  Computes the trace of ellipsoids in ellipsoidal array E.
%
% Input:
%   regular:
%       E: ellipsoid [nRows, nCols] - ellipsoid or array of ellipsoids.
%
% Output:
%    T: numeric[nRows, nCols] - array of trace values.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  global ellOptions;

  if ~isstruct(ellOptions)
    evalin('base', 'ellipsoids_init;');
  end

  [m, n] = size(E);
  T      = [];

  for i = 1:m
    t = [];
    for j = 1:n
      t = [t trace(double(E(i, j)))];
    end
    T = [T; t];
  end

  return;
