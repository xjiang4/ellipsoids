function [F0, F, G0, G] = ellconstraint(x, Q1, Q2, varargin)
%
% ELLCONSTRAINT - describes ellipsoidal constraint.
%
% Description:
%    This function describes ellipsoidal constraint
%                          <l, Q l> = 1,
%    where Q is positive semidefinite.
%
% Input:
%   regular:
%       x: numeric[nDims, 1] -  direction vector.
%       Q1, Q2: are ignored.
%
%   optional:
%       Q: numeric[nDims, nDims] - shape matrix of ellipsoid.
%          default values - identity matrix.
%
% Output:
%       F0, G0: [] - always empty.
%       F: numeric[1, 1] - ellipsoidal constraint
%       G: numeric[nDims, 1] - 
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  F0 = [];
  G0 = [];

  if nargin > 3
    Q = varargin{1};
    F = (x' * Q * x) - 1;
    G = 2 * Q * x;
  else
    F = (x' * x) - 1;
    G = 2 * x;
  end

  return;
