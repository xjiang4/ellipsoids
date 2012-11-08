function display(E)
%
%    DISPLAY - Displays the details of the ellipsoid object.
%
% Input:
%   regular:
%       E: ellipsod [1, nCols] - ellipsoid or array of ellipsoids.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  fprintf('\n');
  disp([inputname(1) ' =']);

  [m, n] = size(E);
  if (m > 1) | (n > 1)
    fprintf('%dx%d array of ellipsoids.\n\n', m, n);
    return;
  end

  fprintf('\n');
  fprintf('Center:\n'); disp(E.center);
  fprintf('Shape Matrix:\n'); disp(E.shape);

  if isempty(E)
    fprintf('Empty ellipsoid.\n\n');
    return;
  end

  [s, e]    = dimension(E);  
  if e < s
    fprintf('Degenerate (rank %d) ellipsoid in R^%d.\n\n', e, s);
  else
    fprintf('Nondegenerate ellipsoid in R^%d.\n\n', s);
  end
  
  return;
