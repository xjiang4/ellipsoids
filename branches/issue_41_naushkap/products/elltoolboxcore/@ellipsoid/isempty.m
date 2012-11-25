function isResMat = isempty(myEllMat)
%
% ISEMPTY - checks if the ellipsoid object is empty.
%
% Input:
%   regular:
%       myEllMat: ellipsod [mRows, nCols] - matrix of ellipsoids.
%
% Output:
%   isResMat: logical[1mRows, nCols], isResMat(iRow, jCol) = 1 - if
%       ellipsoid myEllMat(iRow, jCol) is empty, 0 - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror;

if ~(isa(myEllMat, 'ellipsoid'))
    throwerror('wrongInput', ...
        'ISEMPTY: input argument must be ellipsoid.');
end

isResMat = ~dimension(myEllMat);
