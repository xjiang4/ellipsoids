function [myEllCenterVec, myEllShapeMat] = parameters(myEll)
%
% PARAMETERS - returns parameters of the ellipsoid.
%
% Input:
%   regular:
%       myEll: ellipsoid [1, 1] - single ellipsoid of dimention nDims.
%
% Output:
%   myEllCenterVec: double[nDims, 1] - center of the ellipsoid myEll.
%   myEllShapeMat: double[nDims, nDims] - shape matrix
%       of the ellipsoid myEll.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

if nargout < 2
    myEllCenterVec = double(myEll);
else
    [myEllCenterVec, myEllShapeMat] = double(myEll);
end
