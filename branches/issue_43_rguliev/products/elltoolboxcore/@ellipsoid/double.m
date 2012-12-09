function [myEllCentVec, myEllshMat] = double(myEll)
%
% DOUBLE - returns parameters of the ellipsoid.
%
% Input:
%   regular:
%       myEll: ellipsoid [1, 1] - single ellipsoid of dimention nDims.
%
% Output:
%   myEllCenterVec: double[nDims, 1] - center of the ellipsoid myEll.
%   myEllshapeMat: double[nDims, nDims] - shape matrix
%       of the ellipsoid myEll.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

ellipsoid.checkIsMe(myEll);
modgen.common.checkvar(myEll,'isscalar(x)',...
    'errorMessage','input argument must be single ellipsoid.');

if nargout < 2
    myEllCentVec = myEll.shape;
else
    myEllCentVec = myEll.center;
    myEllshMat = myEll.shape;
end
