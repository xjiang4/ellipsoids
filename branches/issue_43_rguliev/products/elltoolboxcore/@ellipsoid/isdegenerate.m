function isPositiveMat = isdegenerate(myEllArr)
%
% ISDEGENERATE - checks if the ellipsoid is degenerate.
%
% Input:
%   regular:
%       myEllMat: ellipsoid [mRows, nCols] - single ellipsoid.
%
% Output:
%   isResMat: logical[mRows, nCols], isPositiveMat(iRow, jCol) = true 
%       if ellipsoid myEllMat(iRow, jCol) is degenerate,
%       false - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

ellipsoid.checkIsMe(myEllArr,...
    'errorTag','wrongInput',...
    'errorMessage','input argument must be ellipsoid.');
modgen.common.checkvar(myEllArr,'~any(isempty(x(:)))',...
    'errorTag','wrongInput:emptyEllipsoid',...
    'errorMessage','input argument contains empty ellipsoid.');
isPositiveMat = arrayfun(@(x) rank(x.shape) < size(x.shape,1) ,myEllArr);