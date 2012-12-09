function modEllArr = shape(ellArr, modMat)
%
% SHAPE - modifies the shape matrix of the ellipsoid without changing its center.
%
%
% Description:
% ------------
%
%    modEllArr = SHAPE(ellArr, modMat)  Modifies the shape matrices of the ellipsoids in the
%                      ellipsoidal array ellArr. The centers remain untouched -
%                      that is the difference of the function SHAPE and
%                      linear transformation modMat*ellArr.
%                      modMat is expected to be a scalar or a square matrix
%                      of suitable dimension.
%
%
% Output:
% -------
%
%    modEllArr - array of modified ellipsoids.
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


ellipsoid.checkIsMe(ellArr,'first');
modgen.common.checkvar(modMat, @(x)isa(x,'double'),...
    'errorMessage','second input argument must be double');

if isscalar(modMat)
    modMatSq = modMat*modMat;
    modEllCArr = arrayfun(@(x) ellipsoid(x.center, modMatSq*x.shape),  ellArr,...
        'UniformOutput',false);
else
    [nRows, nDim] = size(modMat);
    nDimsVec = dimension(ellArr);
    modgen.common.checkmultvar('(x1==x2)&&all(x3==x2)',3,nRows,nDim,nDimsVec,...
        'errorMessage', 'input matrix not square or dimensions do not match');
    modEllCArr = arrayfun(@(x) fSingleShape(x),  ellArr,'UniformOutput',false);
end
modEllArr=reshape([modEllCArr{:}],size(ellArr));

    function modEll = fSingleShape(singEll)
        qMat    = modMat*(singEll.shape)*modMat';
        qMat    = 0.5*(qMat + qMat');
        modEll = ellipsoid(singEll.center, qMat);
    end
end
