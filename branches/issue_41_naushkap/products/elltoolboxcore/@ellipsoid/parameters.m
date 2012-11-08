function [q, Q] = parameters(E)
%
% PARAMETERS - returns parameters of the ellipsoid.
%
% Description:
%    [q, Q] = PARAMETERS(E)  Extracts the values of the center q and
%                            the shape matrix Q from the ellipsoid object E.
%
% Input:
%   regular:
%       E: ellipsoid [1, 1] - single ellipsoid of dimention nDims.
%
% Output:
%    q: numeric[nDims, 1] - center of the ellipsoid E.
%    Q: numeric[nDims, nDims] - shape matrix of the ellipsoid E.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  [m, n] = size(E);
  if (m > 1) | (n > 1)
    error('PARAMETERS: the argument of this function must be single ellipsoid.');
  end
  
  if nargout < 2
    q = E.shape;
  else
    q = E.center;
    Q = E.shape;
  end

  return;
