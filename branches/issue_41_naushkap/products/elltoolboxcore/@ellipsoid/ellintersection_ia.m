function outEll = ellintersection_ia(inpEllMat)
%
% ELLINTERSECTION_IA - computes maximum volume ellipsoid that is contained
%                      in the intersection of given ellipsoids.
%
% Input:
%   regular:
%       inpEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids of the same dimentions.
%
% Output:
%   regular:
%       outEll: ellipsoid [1, 1] - resulting maximum volume ellipsoid.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $
%    Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
%
% $Author: Vadim Kaushanskiy <vkaushanskiy@gmail.com> $    $Date: 10-11-2012 $
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Computer Science,
%            System Analysis Department 2012 $ 
  
  import modgen.common.throwerror 
  import elltool.conf.Properties;


  ellDimensions = dimension(inpEllMat);
  minElldim   = min(min(ellDimensions));
  maxElldim   = max(max(ellDimensions));

  if minElldim ~= maxElldim
    throwerror('wrongSizes', 'ELLINTERSECTION_IA: all ellipsoids must be of the same dimension.');
  end

  [mRows, nCols] = size(inpEllMat);
  nEllipsoids = mRows * nCols;
  inpEllMat = reshape(inpEllMat, 1, nEllipsoids);

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
        -cvxDirVec <= 0;
        for iEllipsoid = 1:nEllipsoids
            [inpEllcenrVec, inpEllShMat] = double(inpEllMat(iEllipsoid));
            if rank(inpEllShMat) < minElldim
                inpEllShMat = ellipsoid.regularize(inpEllShMat,absTolVec(iEllipsoid));
            end
            invShMat     = ell_inv(inpEllShMat);
            bVec     = -invShMat * inpEllcenrVec;
            c     = inpEllcenrVec' * invShMat * inpEllcenrVec - 1;
            [ (-cvxDirVec(iEllipsoid)-c+bVec'*inpEllShMat*bVec), zeros(minElldim,1)',...
                (cvxEllCenterVec + inpEllShMat*bVec)' ;
                
              zeros(minElldim,1), cvxDirVec(iEllipsoid)*eye(minElldim), cvxEllMat;
              (cvxEllCenterVec + inpEllShMat*bVec), cvxEllMat, inpEllShMat] >= 0;             
        end
        
  cvx_end

  if strcmp(cvx_status,'Infeasible') || strcmp(cvx_status,'Inaccurate/Infeasible')...
          || strcmp(cvx_status,'Failed')
      throwerror('cvxError','Cvx cannot solve the system');
  end;
 
  if rank(cvxEllMat) < minElldim
    cvxEllMat = ellipsoid.regularize(cvxEllMat,min(getAbsTol(inpEllMat(:))));
  end

  ellMat = cvxEllMat * cvxEllMat';
  ellMat = 0.5*(ellMat + ellMat');

  outEll = ellipsoid(cvxEllCenterVec, ellMat);
  
end
