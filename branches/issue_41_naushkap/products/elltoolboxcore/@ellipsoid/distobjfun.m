function [resD, resG] = distobjfun(xVec, firstEll, secondEll, varargin)
%
% DISTOBJFUN - objective function for calculation of distance between two ellipsoids.
%
% Input:
%   regular:
%       firstEll, secondEll: ellipsoid [1, 1] - ellipsoids of the same dimentions nDims.
%       xVec: double[nDims, 1] - Direction vector.
%
% Output:
%    resD: double[1, 1] -
%    resG: double[nDims, 1] -
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  firstEllCenterVec = firstEll.center;
  firstEllShapeMat = firstEll.shape;
  secondEllCenterVec = secondEll.center;
  secondEllShapeMat = secondEll.shape;

  resD = xVec'*secondEllCenterVec + sqrt(xVec'*firstEllShapeMat*xVec) + ...
      sqrt(xVec'*secondEllShapeMat*xVec) - xVec'*firstEllCenterVec;
  resG = secondEllCenterVec - firstEllCenterVec + ...
      ((firstEllShapeMat*xVec)/sqrt(xVec'*firstEllShapeMat*xVec)) +...
      ((secondEllShapeMat*x)/sqrt(xVec'*secondEllShapeMat*xVec));

  return;
