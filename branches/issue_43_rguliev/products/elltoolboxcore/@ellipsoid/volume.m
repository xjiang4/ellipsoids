function volArr = volume(ellArr)
%
% VOLUME - returns the volume of the ellipsoid.
%
%
% Description:
% ------------
%
%    V = VOLUME(E)  Computes the volume of ellipsoids in ellipsoidal array E.
%
%    The volume of ellipsoid E(q, Q) with center q and shape matrix Q is given by
%                  V = S sqrt(det(Q))
%    where S is the volume of unit ball.
%
%
% Output:
% -------
%
%    V - array of volume values, same size as E.
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

ellipsoid.checkIsMe(ellArr,...
    'errorMessage','input argument must be array of ellipsoids.'); 

modgen.common.checkvar(ellArr,'~any(isempty(x(:)))',...
    'errorTag','wrongInput:emptyEllipsoid',...
    'errorMessage','input argument is empty.');
volArr = arrayfun(@(x) fSingleVolume(x), ellArr);

end

function vol = fSingleVolume(singEll)
if isdegenerate(singEll)
    vol = 0;
else
    qMat = singEll.shape;
    nDim = size(qMat, 1);
    
    if mod(nDim,2)
        k = (nDim-1)/2;
        s = ((2^(2*k + 1))*(pi^k)*factorial(k))/factorial(2*k + 1);
    else
        k = nDim /2;
        s = (pi^k)/factorial(k);
    end
    vol = s*sqrt(det(qMat));
end
end
