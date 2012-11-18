function [resD, resG] = contobjfun(xVec, firstEll, secondEll, varargin)
%
% CONTOBJFUN - objective function for containment checking of two ellipsoids 
%               (secondEll in firstEll).
%
% Input:
%   regular:
%       firstEll, secondEll: ellipsoid [1, 1] - ellipsoids of the same dimentions nDims.
%       x: numeric[nDims, 1] - Direction vector.
%
% Output:
%    resD: double[1, 1] - Subtraction between 
%       of ellipsoides support functions.
%    resG: double[nDims, 1] - Subtraction between 
%       of ellipsoides support vectors.
%
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  firstEllCenterVec = firstEll.center;
  firstEllShapeMat = firstEll.shape;
  secondEllCenterVec = secondEll.center;
  secondEllShapeMat = secondEll.shape;

  resD = xVec'*firstEllCenterVec + sqrt(xVec'*firstEllShapeMat1*xVec) - ...
      xVec'*secondEllCenterVec - sqrt(xVec'*secondEllShapeMat*xVec);
  resG = firstEllCenterVec + ((firstEllShapeMat*xVec)/sqrt(xVec'*firstEllShapeMat*xVec))...
      - secondEllCenterVec - ((secondEllShapeMat*xVec)/sqrt(xVec'*secondEllShapeMat*xVec));

  return;
