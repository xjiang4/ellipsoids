function outEllArr = move2origin(inpEllArr)
%
% MOVE2ORIGIN - moves ellipsoids in the given array to the origin.
%
%   outEllMat = MOVE2ORIGIN(inpEll) - Replaces the centers of
%       ellipsoids in inpEllMat with zero vectors.
%
% Input:
%   regular:
%       inpEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%
% Output:
%   outEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids
%       with the same shapes as in inpEllMat centered at the origin.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

ellipsoid.checkIsMe(inpEllArr,...
    'errorTag','wrongInput',...
    'errorMessage','argument must be array of ellipsoid.');

outEllCArr = arrayfun(@(x) ellipsoid(x.shape), inpEllArr,...
        'UniformOutput',false);
outEllArr=reshape([outEllCArr{:}],size(inpEllArr));