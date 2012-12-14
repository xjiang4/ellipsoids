function outEllArr = move2origin(inpEllArr)
%
% MOVE2ORIGIN - moves ellipsoids in the given array to the origin.
%
%   outEllArr = MOVE2ORIGIN(inpEll) - Replaces the centers of
%       ellipsoids in inpEllArr with zero vectors.
%
% Input:
%   regular:
%       inpEllArr: ellipsoid [nDims1,nDims2,...,nDimsN] - array of 
%           ellipsoids.
%
% Output:
%   outEllArr: ellipsoid [nDims1,nDims2,...,nDimsN] - array of ellipsoids
%       with the same shapes as in inpEllArr centered at the origin.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

ellipsoid.checkIsMe(inpEllArr,...
    'errorTag','wrongInput',...
    'errorMessage','argument must be array of ellipsoid.');
sizeCVec = num2cell(size(inpEllArr));
outEllArr(sizeCVec{:}) = ellipsoid;
arrayfun(@(x) fSingleMove(x), 1:numel(inpEllArr));
    function fSingleMove(index)
        nDim = dimension(inpEllArr(index));
        outEllArr(index).center = zeros(nDim,1);
        outEllArr(index).shape = inpEllArr(index).shape;
    end
end