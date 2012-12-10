function isPositiveArr = isempty(myEllArr)
%
% ISEMPTY - checks if the ellipsoid object is empty.
%
% Input:
%   regular:
%       myEllArr: ellipsoid [nDims1,nDims2,...,nDimsN] - array of ellipsoids.
%
% Output:
%   isPositiveArr: logical[nDims1,nDims2,...,nDimsN], 
%       isPositiveArr(iCount) = true - if ellipsoid
%       myEllMat(iCount) is empty, false - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;

ellipsoid.checkIsMe(myEllArr);

isPositiveArr = ~dimension(myEllArr);
