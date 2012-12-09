function [dimArr, rankArr] = dimension(myEllArr)
%
% DIMENSION - returns the dimension of the space in which the ellipsoid
%             is defined and the actual dimension of the ellipsoid.
%
% Input:
%   regular:
%       myEllArr: ellipsoid[,] - array of ellipsoids.
%
% Output:
%   regular:
%       dimArr: double[,] - space dimensions.
%
%   optional:
%       rankArr: double[,] - dimensions of the ellipsoids
%           in myEllArr.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;

ellipsoid.checkIsMe(myEllArr);

dimArr = arrayfun(@(x) size(x.shape,1), myEllArr);
if nargout > 1
    rankArr = arrayfun(@(x) rank(x.shape), myEllArr);
end

