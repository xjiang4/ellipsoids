function isPositiveArr = isdegenerate(myEllArr)
%
% ISDEGENERATE - checks if the ellipsoid is degenerate.
%
% Input:
%   regular:
%       myEllArr: ellipsoid[nDims1,nDims2,...,nDimsN] - array of ellipsoids.
%
% Output:
%   isPositiveArr: logical[nDims1,nDims2,...,nDimsN], 
%       isPositiveArr(iCount) = true if ellipsoid myEllMat(iCount) 
%       is degenerate, false - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

ellipsoid.checkIsMe(myEllArr);
modgen.common.checkvar(myEllArr,'~any(isempty(x(:)))',...
    'errorTag','wrongInput:emptyEllipsoid',...
    'errorMessage','input argument contains empty ellipsoid.');
isPositiveArr = arrayfun(@(x) rank(x.shape) < size(x.shape,1) ,myEllArr);