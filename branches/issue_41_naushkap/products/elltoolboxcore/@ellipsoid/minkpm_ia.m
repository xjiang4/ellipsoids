function IA = minkpm_ea(EE, E2, L)
import modgen.common.throwerror;
%
% MINKPM_IA - computation of internal approximating ellipsoids
%             of (E1 + E2 + ... + En) - E in given directions.
%
% Description:
%    IA = MINKPM_IA(EE, E, L)  Computes internal approximating ellipsoids
%                              of (E1 + E2 + ... + En) - E,
%                              where E1, E2, ..., En are ellipsoids in array EE,
%                              in directions specified by columns of matrix L.
%
% Input:
%   regular:
%       EE: ellipsoid [1, nCols] - array of ellipsoids of the same dimentions.
%       E: ellipsoid [1, 1] - ellipsoid of the same dimention.
%       L: numeric[nDim, nCols] - matrix whose columns specify the directions for which the
%       approximations should be computed.
%
% Output:
%    EA: ellipsoid [1, nCols] - array of internal approximating ellipsoids
%         (empty, if for all specified directions approximations cannot be computed).
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  global ellOptions;

  if ~isstruct(ellOptions)
    evalin('base', 'ellipsoids_init;');
  end

  if ~(isa(EE, 'ellipsoid')) | ~(isa(E2, 'ellipsoid'))
    throwerror('wrongInput', 'MINKPM_IA: first and second arguments must be ellipsoids.');
  end

  [m, n] = size(E2);
  if (m ~= 1) | (n ~= 1)
    throwerror('wrongInput', 'MINKPM_IA: second argument must be single ellipsoid.');
  end

  k  = size(L, 1);
  n  = dimension(E2);
  mn = min(min(dimension(EE)));
  mx = max(max(dimension(EE)));
  if (mn ~= mx) | (mn ~= n)
    throwerror('wrongSizes', 'MINKPM_IA: all ellipsoids must be of the same dimension.');
  end
  if n ~= k
    throwerror('wrongSizes', 'MINKPM_IA: dimension of the direction vectors must be the same as dimension of ellipsoids.');
  end

  N                  = size(L, 2);
  IA                 = [];
  ES                 = minksum_ia(EE, L);
  vrb                = ellOptions.verbose;
  ellOptions.verbose = 0;

  for i = 1:N
    E = ES(i);
    l = L(:, i);
    if isbigger(E, E2)
      if ~isbaddirection(E, E2, l)
        IA = [IA minkdiff_ia(E, E2, l)];
      end
    end
  end

  ellOptions.verbose = vrb;

  if isempty(IA)
    if ellOptions.verbose > 0
      fprintf('MINKPM_IA: cannot compute internal approximation for any\n');
      fprintf('           of the specified directions.\n');
    end
  end

  return;
