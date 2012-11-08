function M = mineig(E)
%
% MINEIG - return the minimal eigenvalue of the ellipsoid.
%
% Description:
%    M = MINEIG(E)  Returns the smallest eigenvalues of ellipsoids in the array E.
%
% Input:
%   regular:
%       E: ellipsoid [mRows, nCols] - array of ellipsoids.
%
% Output:
%    M: numeric[mRows, nCols] - array of minimal eigenvalues of ellipsoids
%       in the input array E.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  global ellOptions;

  if ~isstruct(ellOptions)
    evalin('base', 'ellipsoids_init;');
  end

  if ~(isa(E, 'ellipsoid'))
    error('MINEIG: input argument must be ellipsoid.')
  end

  [m, n] = size(E);
  M      = [];
  for i = 1:m
    mx = [];
    for j = 1:n
      if isdegenerate(E(i, j))
        mx = [mx 0];
      else
        mx = [mx min(eig(E(i, j).shape))];
      end
    end
    M = [M; mx];
  end

  return;
