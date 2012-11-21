function [spaceDimMat, ellDimMat] = dimension(myEllArray)
%
% DIMENSION - returns the dimension of the space in which the ellipsoid
%             is defined and the actual dimension of the ellipsoid.
%
% Input:
%   regular:
%       myEllArray: ellipsoid [mRows, nCols] - Array of ellipsoids.
%
% Output:
%   regular:
%       spaceDimMat: double[mRows, nCols] - space dimensions.
%
%   optional:
%       ellDimMat: double[mRows, nCols] - dimensions of the ellipsoids in myEllArray.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  global ellOptions;

  if ~isstruct(ellOptions)
    evalin('base', 'ellipsoids_init;');
  end

  [mRows, nCols] = size(myEllArray);

  for iRows = 1:mRows
    for jCols = 1:nCols
      spaceDimMat(iRows, jCols) = size(myEllArray(iRows, jCols).shape, 1);
      ellDimMat(iRows, jCols) = rank(myEllArray(iRows, jCols).shape);
      if isempty(myEllArray(iRows, jCols).shape) || isempty(myEllArray(iRows, jCols).center)
        spaceDimMat(iRows, jCols) = 0;
        ellDimMat(iRows, jCols) = 0;
      end
    end
  end

end
