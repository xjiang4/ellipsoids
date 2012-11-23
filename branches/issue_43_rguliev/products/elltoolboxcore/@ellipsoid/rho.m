function [res, x] = rho(E, L)
%
% RHO - computes the values of the support function for given ellipsoid
%       and given direction.
%
%
% Description:
% ------------
%
%         RES = RHO(E, L)  Computes the support function of the ellipsoid E
%                          in directions specified by the columns of matrix L.
%                          Or, if E is array of ellipsoids, L is expected to be
%                          a single vector.
%
%    [RES, X] = RHO(E, L)  Computes the support function of the ellipsoid E
%                          in directions specified by the columns of matrix L,
%                          and boundary points X of this ellipsoid that correspond
%                          to directions in L.
%                          Or, if E is array of ellipsoids, and L - single vector,
%                          then support functions and corresponding boundary
%                          points are computed for all the given ellipsoids in
%                          the array in the specified direction L.
%
%    The support function is defined as
%       (1)  rho(l | E) = sup { <l, x> : x belongs to E }.
%    For ellipsoid E(q,Q), where q is its center and Q - shape matrix,
%    it is simplified to
%       (2)  rho(l | E) = <q, l> + sqrt(<l, Ql>)
%    Vector x, at which the maximum at (1) is achieved is defined by
%       (3)  q + Ql/sqrt(<l, Ql>)
%
%
% Output:
% -------
%
%    RES - the values of the support function for the specified ellipsoid E
%          and directions L. Or, if E is an array of ellipsoids, and L - single
%          vector, then these are values of the support function for all the
%          ellipsoids in the array in the given direction.
%      X - boundary points of the ellipsoid E that correspond to directions in L.
%          Or, if E is an array of ellipsoids, and L - single vector,
%          then these are boundary points of all the ellipsoids in the array
%          in the given direction.
%
%
% See also:
% ---------
%
%    ELLIPSOID/ELLIPSOID.
%

%
% Author:
% -------
%
%    Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
%

modgen.common.type.simple.checkgenext(@(x1,x2)...
    isa(x1,'ellipsoid')&&isa(x2,'double'),2,E,L,'Input argumets',' ');

  [m, n] = size(E);
  [k, d] = size(L);
  if (m > 1) || (n > 1)
    if d > 1
      msg = sprintf('RHO: arguments must be single ellipsoid and matrix of direction vectors,\n     or array of ellipsoids and single direction vector.');
      error(msg);
    end
    ea = 1;
  else
    ea = 0;
  end

  dims = dimension(E);
  mn   = min(dims(:));
  mx   = max(dims(:));
  if mn ~= mx
    error('RHO: ellipsoids in the array must be of the same dimension.');
  end
  if mn ~= k
    error('RHO: dimensions of the direction vector and the ellipsoid do not match.');
  end

  
  if ea > 0 % multiple ellipsoids, one direction
    res=NaN(m,n);
    x=NaN(k,m*n);
    for i = 1:m
      for j = 1:n
        q  = E(i, j).center;
        Q  = E(i, j).shape;
        sr = sqrt(L'*Q*L);
        if sr == 0
          sr = eps;
        end
        res(i,j) = q'*L + sr;
        x(:,(i-1)*n+j)=((Q*L)/sr) + q;
      end
    end
  else % one ellipsoid, multiple directions
    q = E.center;
    Q = E.shape;
    res=NaN(1,d);
    x=NaN(k,d);
    for i = 1:d
      l   = L(:, i);
      sr  = sqrt(l'*Q*l);
      if sr == 0
        sr = eps;
      end
      res(i) = q'*l + sr;
      x(:,i)=((Q*l)/sr) + q;
    end
  end
