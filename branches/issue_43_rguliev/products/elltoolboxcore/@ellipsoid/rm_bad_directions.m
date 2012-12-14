function clrDirsMat = rm_bad_directions(q1Mat, q2Mat, dirsMat)
%
% RM_BAD_DIRECTIONS - remove bad directions from the given list.
%	Bad directions are those which should not be used for the support 
%   function of geometric difference of two ellipsoids.
%
% Input:
%   regular:
%       q1Mat: double[nDim, nDim] - shape matrix of minuend ellipsoid
%       q2Mat: double[nDim, nDim] - shape matrix of subtrahend ellipsoid
%       dirsMat: double[nDim, nDirs] - matrix of of checked directions
%
% Output:
%   clrDirsMat: double[nDim, nClearDirs] - matrix of without bad directions
%       of dirsMat
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

isGoodDirVec=~ellipsoid.isbaddirectionmat(q1Mat,q2Mat,dirsMat);
clrDirsMat=[];
if any(isGoodDirVec)
    clrDirsMat=dirsMat(:,isGoodDirVec);
end
