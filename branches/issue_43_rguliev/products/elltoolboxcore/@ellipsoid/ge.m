function isPositiveArr = ge(firsrEllArr, secondEllArr)
%
% GE - checks if the first ellipsoid is bigger than the second one.
%      Same as GT.
%
% Input:
%   regular:
%       firsrEllArr: ellipsoid [,] - array of ellipsoids.
%       secondEllArr: ellipsoid [,] - array of ellipsoids
%           of the corresponding dimensions.
%
% Output:
%   isPositiveMat: logical[,],
%       resMat(iCount) = true - if firsrEllMat(iCount)
%       contains secondEllMat(iCount)
%       when both have same center, false - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

isPositiveArr = gt(firsrEllArr, secondEllArr);
