function [sd, ed] = dimension(E)
%
% DIMENSION - returns the dimension of the space in which the ellipsoid
%             is defined and the actual dimension of the ellipsoid.
%
% Description:
%    [SD, ED] = DIMENSION(E)  Retrieves the space dimension SD in which
%                             the ellipsoid E is defined and the actual
%                             dimension ED of this ellipsoid.
%
%          SD = DIMENSION(E)  Retrieves just the space dimension SD in which
%                             the ellipsoid E is defined.
%
% Input:
%   regular:
%       E: ellipsoid [1, 1] - single ellipsoid.
%
% Output:
%   regular:
%       SD: numeric[1, 1] - space dimension.
%
%   optional:
%       ED: numeric[1, 1] - dimension of the ellipsoid E.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  global ellOptions;

  if ~isstruct(ellOptions)
    evalin('base', 'ellipsoids_init;');
  end

  [m, n] = size(E);

  for i = 1:m
    for j = 1:n
      sd(i, j) = size(E(i, j).shape, 1);
      ed(i, j) = rank(E(i, j).shape);
      if isempty(E(i, j).shape) | isempty(E(i, j).center)
        sd(i, j) = 0;
        ed(i, j) = 0;
      end
    end
  end

  return;
