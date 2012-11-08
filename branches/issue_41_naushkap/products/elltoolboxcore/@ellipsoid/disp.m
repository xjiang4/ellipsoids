function disp(E)
%
%    DISP - Displays ellipsoid object.
%
% Input:
%   regular:
%       E: ellipsod [1, nCols] - ellipsoid or array of ellipsoids.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $


  fprintf('Ellipsoid with parameters\n');

  [m, n] = size(E);
  if (m > 1) | (n > 1)
    fprintf('%dx%d array of ellipsoids.\n\n', m, n);
    return;
  end

  fprintf('Center:\n'); disp(E.center);
  fprintf('Shape Matrix:\n'); disp(E.shape);

  if isempty(E)
    fprintf('Empty ellipsoid.\n\n');
    return;
  end

  return;
