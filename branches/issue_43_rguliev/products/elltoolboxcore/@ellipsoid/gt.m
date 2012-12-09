function isPositiveArr = gt(firstEllArr, secondEllArr)
%
% GT - checks if the first ellipsoid is bigger than the second one.
%
% Input:
%   regular:
%       firsrEllArr: ellipsoid [,] - array of ellipsoids.
%       secondEllArr: ellipsoid [,] - array of ellipsoids
%           of the corresponding dimensions.
%
% Output:
%   isPositiveArr: logical[,],
%       resMat(iCount) = true - if firsrEllMat(iCount)
%       contains secondEllMat(iCount)
%       when both have same center, false - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $
import modgen.common.throwerror;
import modgen.common.checkmultvar;

ellipsoid.checkIsMe(firstEllArr,'first');
ellipsoid.checkIsMe(secondEllArr,'second');

nFstEllipsoids = numel(firstEllArr);
nSecEllipsoids = numel(secondEllArr);

checkmultvar('(x1==1)||(x2==1)||all(size(x3)==size(x4))',...
    4,nFstEllipsoids,nSecEllipsoids,firstEllArr,secondEllArr,...
    'errorTag','wrongSizes',...
    'errorMessage','sizes of ellipsoidal arrays do not match.');

if (nFstEllipsoids > 1) && (nSecEllipsoids > 1)
    isPositiveArr = arrayfun(@(x,y) isbigger(x,y),firstEllArr,secondEllArr);
elseif (nFstEllipsoids > 1)
    isPositiveArr = arrayfun(@(x) isbigger(x,secondEllArr),firstEllArr);
else
    isPositiveArr = arrayfun(@(x) isbigger(firstEllArr,x),secondEllArr);
end
