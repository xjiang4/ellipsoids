function display(myEll)
%
%    DISPLAY - Displays the details of the ellipsoid object.
%
% Input:
%   regular:
%       myEll: ellipsod [1, nCols] - ellipsoid or array of ellipsoids.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  fprintf('\n');
  disp([inputname(1) ' =']);

  [mRows, nCols] = size(myEll);
  if (mRows > 1) | (nCols > 1)
    fprintf('%dx%d array of ellipsoids.\n\n', mRows, nCols);
    return;
  end

  fprintf('\n');
  fprintf('Center:\n'); disp(myEll.center);
  fprintf('Shape Matrix:\n'); disp(myEll.shape);

  if isempty(myEll)
    fprintf('Empty ellipsoid.\n\n');
    return;
  end

  [spaceDim, ellDim]    = dimension(myEll);  
  if ellDim < spaceDim
    fprintf('Degenerate (rank %d) ellipsoid in R^%d.\n\n', ellDim, spaceDim);
  else
    fprintf('Nondegenerate ellipsoid in R^%d.\n\n', s);
  end
  
  return;
