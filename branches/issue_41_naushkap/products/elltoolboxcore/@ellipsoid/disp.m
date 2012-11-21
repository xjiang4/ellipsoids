function disp(myEllArray)
%
%    DISP - Displays ellipsoid object.
%
% Input:
%   regular:
%       myEllArray: ellipsod [mRows, nCols] - array of ellipsoids.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  fprintf('Ellipsoid with parameters\n');

  [mRows, nCols] = size(myEllArray);
  if (mRows > 1) || (nCols > 1)
    fprintf('%dx%d array of ellipsoids.\n\n', mRows, nCols);
  else
    fprintf('Center:\n'); disp(myEllArray.center);
    fprintf('Shape Matrix:\n'); disp(myEllArray.shape);
    if isempty(myEllArray)
        fprintf('Empty ellipsoid.\n\n');
    end
  end

end
