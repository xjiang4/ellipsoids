function [spaceDimMat, ellDimMat] = dimension(myEllArr)
%
% DIMENSION - returns the dimension of the space in which the ellipsoid
%             is defined and the actual dimension of the ellipsoid.
%
% Input:
%   regular:
%       myEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%
% Output:
%   regular:
%       spaceDimMat: double[mRows, nCols] - space dimensions.
%
%   optional:
%       ellDimMat: double[mRows, nCols] - dimensions of the ellipsoids
%           in myEllMat.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;

spaceDimMat = arrayfun(@(x) size(x.shape,1), myEllArr);
if nargout > 1
    ellDimMat = arrayfun(@(x) rank(x.shape), myEllArr);
end

