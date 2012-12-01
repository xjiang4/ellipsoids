function polEllArr = polar(ellArr)

%
% POLAR - computes the polar ellipsoids.
%
%
% Description:
% ------------
%
%    P = POLAR(E)  Computes the polar ellipsoids for those ellipsoids in E,
%                  for which the origin is an interior point.
%                  For those ellipsoids in E, for which this condition
%                  does not hold, an empty ellipsoid is returned.
%
%
%    Given ellipsoid E(q, Q) where q is its center, and Q - its shape matrix,
%    the polar set to E(q, Q) is defined as follows:
%
%             P = { l in R^n  | <l, q> + sqrt(<l, Q l>) <= 1 }
%
%    If the origin is an interior point of ellipsoid E(q, Q),
%    then its polar set P is an ellipsoid.
%
%
% Output:
% -------
%
%    P - array of polar ellipsoids.
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
%    Rustam Guliev <glvrst@gmail.com>
%

import modgen.common.throwerror

checkIsMe(ellArr,...
    'errorMessage','POLAR: input argument must be array of ellipsoids.');
modgen.common.checkvar(ellArr,'~any(isdegenerate(x))',...
    'errorTag','degenerateEllipsoid',...
    'errorMessage','The resulting ellipsoid is not bounded');

polEllCArr = arrayfun(@(x) fSinglePolar(x), ellArr,...
    'UniformOutput',false);

polEllArr = reshape([polEllCArr{:}],size(ellArr));

end

function ell = fSinglePolar(singEll)
    q = singEll.center; 
    Q = singEll.shape;
    chk    = q' * ell_inv(Q) * q;
    %chk checks if zero belongs to singEll ellipsoid
    if chk < 1
        M  = ell_inv(Q - q*q');
        M  = 0.5*(M + M');
        w  = -M * q;
        W  = (1 + q'*M*q)*M;
        ell = ellipsoid(w, W);
    else
        throwerror('degenerateEllipsoid','The resulting ellipsoid is not bounded');    
    end
end