function I = uminus(E)
%
% UMINUS - overloaded operation unitary minus.
%
% Description:
%    Changes the sign of the center of ellipsoid.
%
% Input:
%   regular:
%       E: ellipsoid [nRows, nCols] - ellipsoid or array of ellipsoids.
%
% Output:
%    E: ellipsoid [nRows, nCols] - array of ellipsoids as in E, whose
%       centers are multilied by -1.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  if ~(isa(E, 'ellipsoid'))
    error('UMINUS: input argument must be array of ellipsoids.');
  end

  I      = E;
  [m, n] = size(I);

  for i = 1:m
    for j = 1:n
      I(i, j).center = - I(i, j).center;
    end
  end

  return;
