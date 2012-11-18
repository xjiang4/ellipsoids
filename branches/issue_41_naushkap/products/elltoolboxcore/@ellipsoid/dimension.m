function [spaceDim, ellDim] = dimension(myEll)
%
% DIMENSION - returns the dimension of the space in which the ellipsoid
%             is defined and the actual dimension of the ellipsoid.
%
% Description:
%    [SPACEDIM, ELLDIM] = DIMENSION(myEll)  Retrieves the space dimension SPACEDIM in which
%                             the ellipsoid myEll is defined and the actual
%                             dimension ELLDIM of this ellipsoid.
%
%          SPACEDIM = DIMENSION(myEll)  Retrieves just the space dimension SPACEDIM in which
%                             the ellipsoid myEll is defined.
%
% Input:
%   regular:
%       myEll: ellipsoid [1, 1] - single ellipsoid.
%
% Output:
%   regular:
%       SPACEDIM: double[1, 1] - space dimension.
%
%   optional:
%       ELLDIM: double[1, 1] - dimension of the ellipsoid myEll.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  global ellOptions;

  if ~isstruct(ellOptions)
    evalin('base', 'ellipsoids_init;');
  end

  [mRows, nCols] = size(myEll);

  for iRows = 1:mRows
    for jCols = 1:nCols
      spaceDim(iRows, jCols) = size(myEll(iRows, jCols).shape, 1);
      ellDim(iRows, jCols) = rank(myEll(iRows, jCols).shape);
      if isempty(myEll(iRows, jCols).shape) | isempty(myEll(iRows, jCols).center)
        spaceDim(iRows, jCols) = 0;
        ellDim(iRows, jCols) = 0;
      end
    end
  end

  return;
