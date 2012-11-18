function [myEllCenterVec, myEllshapeMat] = double(myEll)
%
% DOUBLE - returns parameters of the ellipsoid.
%
% Description:
%    [myEllCenterVec, myEllshapeMat] = DOUBLE(myEll)  Extracts the values of the center 
%                           myEllCenterVec and the shape matrix myEllshapeMat from the 
%                           ellipsoid object myEll.
%
% Input:
%   regular:
%       myEll: ellipsoid [1, 1] - single ellipsoid of dimention nDims.
%
% Output:
%    myEllCenterVec: double[nDims, 1] - center of the ellipsoid myEll.
%    myEllshapeMat: double[nDims, nDims] - shape matrix of the ellipsoid myEll.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $
  import modgen.common.throwerror;

  [mRows, nCols] = size(myEll);
  if (mRows > 1) | (nCols > 1)
    throwerror('wrongInput', 'DOUBLE: the argument of this function must be single ellipsoid.');
  end
  
  if nargout < 2
    myEllshapeMat = myEll.shape;
  else
    myEllCenterVec = myEll.center;
    myEllshapeMat = myEll.shape;
  end

  return;
