function disp(myEll)
%
%    DISP - Displays ellipsoid object.
%
% Input:
%   regular:
%       myEll: ellipsod [1, nCols] - ellipsoid or array of ellipsoids.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  fprintf('Ellipsoid with parameters\n');

  [mRows, nCols] = size(myEll);
  if (mRows > 1) | (nCols > 1)
    fprintf('%dx%d array of ellipsoids.\n\n', mRows, nCols);
    return;
  end

  fprintf('Center:\n'); disp(myEll.center);
  fprintf('Shape Matrix:\n'); disp(myEll.shape);

  if isempty(myEll)
    fprintf('Empty ellipsoid.\n\n');
    return;
  end

  return;
