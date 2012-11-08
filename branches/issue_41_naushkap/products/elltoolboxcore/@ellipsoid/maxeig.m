function M = maxeig(E)
%
% MAXEIG - return the maximal eigenvalue of the ellipsoid.
%
% Description:
%    M = MAXEIG(E)  Returns the largest eigenvalues of ellipsoids in the array E.
%
% Input:
%   regular:
%       E: ellipsoid [mRows, nCols] - array of ellipsoids.
%
% Output:
%    M: numeric[mRows, nCols] - array of maximal eigenvalues of ellipsoids
%       in the input array E.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  global ellOptions;

  if ~isstruct(ellOptions)
    evalin('base', 'ellipsoids_init;');
  end

  if ~(isa(E, 'ellipsoid'))
    error('MAXEIG: input argument must be ellipsoid.')
  end

  [m, n] = size(E);
  M      = [];
  for i = 1:m
    mx = [];
    for j = 1:n
      mx = [mx max(eig(E(i, j).shape))];
    end
    M = [M; mx];
  end

  return;
