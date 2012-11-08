function [d, g] = distpobjfun(x, E, y, varargin)
%
% DISTPOBJFUN - objective function for calculation of distance between
%               an ellipsoid and a point.
%
% Input:
%   regular:
%       E1ellipsoid [1, 1] - single ellipsoid of dimention nDims.
%       y: numeric[ndims, 1] - single point.
%       x: numeric[nDims, 1] - Direction vector.
%
% Output:
%    d: numeric[1, 1] -
%    g: numeric[nDims, 1] -
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  q = E.center;
  Q = E.shape;

  d = x'*q + sqrt(x'*Q*x) - x'*y;
  g = q - y + ((Q*x)/sqrt(x'*Q*x));

  return;
