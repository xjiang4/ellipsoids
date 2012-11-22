function outEll = ellunion_ea(inpEllMat)
%
% ELLUNION_EA - computes minimum volume ellipsoid that contains union
%               of given ellipsoids.
%
% Input:
%   regular:
%       inpEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids of the same dimentions.
%
% Output:
%   regular:
%       outEll: ellipsoid [1, 1] - resulting minimum volume ellipsoid.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $
%
% $Author: Vadim Kaushanskiy <vkaushanskiy@gmail.com> $    $Date: 10-11-2012 $
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Computer Science,
%            System Analysis Department 2012 $ 

  import elltool.conf.Properties;
  import modgen.common.throwerror;

  ellDimensions = dimension(inpEllMat);
  minElldim   = min(min(ellDimensions));
  maxElldim   = max(max(ellDimensions));

  if minElldim ~= maxElldim
    throwerror('wrongSizes', 'ELLUNION_EA: all ellipsoids must be of the same dimension.');
  end

  [mRows, nCols] = size(inpEllMat);
  nEllipsoids = mRows * nCols;
  inpEllMat  = reshape(inpEllMat, 1, nEllipsoids);

  if Properties.getIsVerbose()
    fprintf('Invoking CVX...\n');
  end
  

absTolVec = getAbsTol(inpEllMat);
cvx_begin sdp
    variable cvxEllMat(minElldim, minElldim) symmetric
    variable cvxEllCenterVec(minElldim)
    variable cvxDirVec(nEllipsoids)
    maximize( det_rootn( cvxEllMat ) )
    subject to
        -cvxDirVec <= 0
        for iEllipsoid = 1:nEllipsoids
            [inpEllcenrVec, inpEllShMat] = double(inpEllMat(iEllipsoid));
            inpEllShMat = (inpEllShMat + inpEllShMat')*0.5;
            if rank(inpEllShMat) < minElldim
                inpEllShMat = ellipsoid.regularize(inpEllShMat,absTolVec(iEllipsoid));
            end
    
            inpEllShMat     = inv(inpEllShMat);
            inpEllShMat = (inpEllShMat + inpEllShMat')*0.5;
            bVec    = -inpEllShMat * inpEllcenrVec;
            c    = inpEllcenrVec' * inpEllShMat * inpEllcenrVec - 1;
           
            [ -(cvxEllMat - cvxDirVec(iEllipsoid)*inpEllShMat), -(cvxEllCenterVec...
                - cvxDirVec(iEllipsoid)*bVec), zeros(minElldim, minElldim);
              -(cvxEllCenterVec - cvxDirVec(iEllipsoid)*bVec)', -(- 1 - ...
              cvxDirVec(iEllipsoid)*c), -cvxEllCenterVec';
               zeros(minElldim, minElldim), -cvxEllCenterVec, cvxEllMat] >= 0;
        end
cvx_end
 

  if strcmp(cvx_status,'Infeasible') || strcmp(cvx_status,'Inaccurate/Infeasible') || strcmp(cvx_status,'Failed')
      throwerror('cvxError','Cvx cannot solve the system');
  end;
  ellMat = inv(cvxEllMat);
  ellMat = 0.5*(ellMat + ellMat');
  ellCenterVec = -ellMat * cvxEllCenterVec;

  outEll = ellipsoid(ellCenterVec, ellMat);

end
