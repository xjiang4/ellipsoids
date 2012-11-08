function [E, S] = ellintersection_ia(EE)
%
% ELLINTERSECTION_IA - computes maximum volume ellipsoid that is contained
%                      in the intersection of given ellipsoids.
%
% Description:
%    E = ELLINTERSECTIONIA(EE)  Among all ellipsoids that are contained
%                               in the intersection of ellipsoids in EE,
%                               find the one that has maximal volume.
%     We use YALMIP as interface to the optimization tools.
%     (http://control.ee.ethz.ch/~joloef/yalmip.php)
%
% Input:
%   regular:
%       EE: ellipsoid [1, nCols] - array of ellipsoids of the same dimentions.
%
% Output:
%   regular:
%       E: ellipsoid [1, 1] - resulting maximum volume ellipsoid.
%
%   optional:
%       S - status variable returned by YALMIP.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  global ellOptions;

  if ~isstruct(ellOptions)
    evalin('base', 'ellipsoids_init;');
  end

  dims = dimension(EE);
  mn   = min(min(dims));
  mx   = max(max(dims));

  if mn ~= mx
    error('ELLINTERSECTION_IA: all ellipsoids must be of the same dimension.');
  end

  [m, n] = size(EE);
  M      = m * n;
  EE     = reshape(EE, 1, M);
  zz     = zeros(mn, 1);
  I      = eye(mn);

  if ellOptions.verbose > 0
    fprintf('Invoking YALMIP...\n');
  end

  B      = sdpvar(mn, mn);
  d      = sdpvar(mn, 1);
  ll     = sdpvar(M, 1);

  cnstr = lmi;

  for i = 1:M
    [q, Q] = double(EE(i));
    
    if rank(Q) < mn
      Q = regularize(Q);
    end
    
    A     = ell_inv(Q);
    b     = -A * q;
    c     = q' * A * q - 1;
    X     = [(-ll(i,1)-c+b'*Q*b) zz'       (d+Q*b)'
             zz                  ll(i,1)*I B
             (d+Q*b)             B         Q];

    cnstr = cnstr + set('X>=0');
    cnstr = cnstr + set('ll(i, 1)>=0');
  end

  S = solvesdp(cnstr, -logdet(B), ellOptions.sdpsettings);
  B = double(B);
  d = double(d);
  
  if rank(B) < mn
    B = regularize(B);
  end

  P = B * B';
  P = 0.5*(P + P');

  E = ellipsoid(d, P);

  if nargout < 2
    clear S;
  end

  return;
