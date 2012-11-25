function modEllArr = shape(ellArr, modMat)
%
% SHAPE - modifies the shape matrix of the ellipsoid without changing its center.
%
%
% Description:
% ------------
%
%    EM = SHAPE(E, A)  Modifies the shape matrices of the ellipsoids in the
%                      ellipsoidal array E. The centers remain untouched -
%                      that is the difference of the function SHAPE and
%                      linear transformation A*E.
%                      A is expected to be a scalar or a square matrix
%                      of suitable dimension.
%
%
% Output:
% -------
%
%    EM - array of modified ellipsoids.
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

modgen.common.type.simple.checkgenext(@(x1,x2)...
    isa(x1,'ellipsoid')&&isa(x2,'double'),2,ellArr,modMat,'Input argumets',' ');

if isscalar(modMat)
    modEllCArr = arrayfun(@(x) ellipsoid(x.center, modMat*modMat*x.shape),  ellArr,...
        'UniformOutput',false);
else
    [nRows, nDim] = size(modMat);
    if nRows ~= nDim
        error('SHAPE: only square matrices are allowed.');
    end
    nDimsVec = dimension(ellArr);
    if any(nDimsVec ~= nDim)
        error('SHAPE: dimensions do not match.');
    end
    modEllCArr = arrayfun(@(x) fsingleShape(x),  ellArr,...
        'UniformOutput',false);
end
modEllArr=reshape([modEllCArr{:}],size(ellArr));

    function modEll = fsingleShape(singEll)
        qMat    = modMat*(singEll.shape)*modMat';
        qMat    = 0.5*(qMat + qMat');
        modEll = ellipsoid(singEll.center, qMat);
    end
end
