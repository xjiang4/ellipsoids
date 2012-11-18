function [resD, resG] = distpobjfun(xVec, myEll, yVec, varargin)
%
% DISTPOBJFUN - objective function for calculation of distance between
%               an ellipsoid and a point.
%
% Input:
%   regular:
%       myEll: E1ellipsoid [1, 1] - single ellipsoid of dimention nDims.
%       yVec: double[ndims, 1] - single point.
%       xVec: double[nDims, 1] - Direction vector.
%
% Output:
%    resD: double[1, 1] -
%    resG: double[nDims, 1] -
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  myEllCenterVec = myEll.center;
  myEllShapeMat = myEll.shape;

  resD = xVec'*myEllCenterVec + sqrt(xVec'*myEllShapeMat*xVec) - xVec'*yVec;
  resG = myEllCenterVec - yVec + ((myEllShapeMat*xVec)/sqrt(xVec'*myEllShapeMat*xVec));

  return;
