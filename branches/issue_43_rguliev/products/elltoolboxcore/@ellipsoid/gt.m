function isPositiveMat = gt(firstEllMat, secondEllMat)
%
% GT - checks if the first ellipsoid is bigger than the second one.
%
% Input:
%   regular:
%       firsrEllMat: ellipsoid [mRows, nCols] - array of ellipsoids.
%       secondEllMat: ellipsoid [mRows, nCols] - array of ellipsoids
%           of the corresponding dimensions.
%
% Output:
%   isPositiveMat: logical[mRows, nCols],
%       resMat(iRows, jCols) = true - if firsrEllMat(iRows, jCols)
%       contains secondEllMat(iRows, jCols)
%       when both have same center, false - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $
import modgen.common.throwerror;
import modgen.common.checkmultvar;

ellipsoid.checkIsMe(firstEllMat,...
    'errorTag','wrongInput',...
    'errorMessage','both input arguments must be ellipsoids.');
ellipsoid.checkIsMe(secondEllMat,...
    'errorTag','wrongInput',...
    'errorMessage','both input arguments must be ellipsoids.');

nFstEllipsoids = numel(firstEllMat);
nSecEllipsoids = numel(secondEllMat);

checkmultvar('(x1==1)||(x2==1)||all(size(x3)==size(x4))',...
    4,nFstEllipsoids,nSecEllipsoids,firstEllMat,secondEllMat,...
    'errorTag','wrongSizes',...
    'errorMessage','sizes of ellipsoidal arrays do not match.');

if (nFstEllipsoids > 1) && (nSecEllipsoids > 1)
    isPositiveMat = arrayfun(@(x,y) isbigger(x,y),firstEllMat,secondEllMat);
elseif (nFstEllipsoids > 1)
    isPositiveMat = arrayfun(@(x) isbigger(x,secondEllMat),firstEllMat);
else
    isPositiveMat = arrayfun(@(x) isbigger(firstEllMat,x),secondEllMat);
end
