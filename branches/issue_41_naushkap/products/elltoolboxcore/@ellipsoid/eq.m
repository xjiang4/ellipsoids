function resMat = eq(firstEllMat, secondEllMat)
%
% EQ - overloaded operator '==', it checks if two ellipsoids are equal.
%
% Input:
%   regular:
%       firstEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%       secondEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids of the corresponding
%       dimensions.
%
% Output:
%    resMat: double[mRows, nCols], resMat[iRows, jCols] = 1 - if 
%               firstEllMat[iRows, jCols] == secondEllMat[iRows, jCols],
%                                                         0 - otherwise.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

  import modgen.common.throwerror;
  import gras.la.sqrtm;
  import elltool.conf.Properties;
  
  if ~(isa(firstEllMat, 'ellipsoid')) || ~(isa(secondEllMat, 'ellipsoid'))
    throwerror('wrongInput', '==: both arguments must be ellipsoids.');
  end

  [mRowsFstEllMatrix, nColsFstEllMatrix] = size(firstEllMat);
  nFstEllipsoids = mRowsFstEllMatrix * nColsFstEllMatrix;
  [mRowsSecEllMatrix, nColsSecEllMatrix] = size(secondEllMat);
  nSecEllipsoids = mRowsSecEllMatrix * nColsSecEllMatrix;

  if ((mRowsFstEllMatrix ~= mRowsSecEllMatrix) || (nColsFstEllMatrix ~= ...
          nColsSecEllMatrix)) && (nFstEllipsoids > 1) && (nSecEllipsoids > 1)
    throwerror('wrongSizes', '==: sizes of ellipsoidal arrays do not match.');
  end

  resMat = [];
  if (nFstEllipsoids > 1) && (nSecEllipsoids > 1)
    for iRowsSecEllMatrix = 1:mRowsSecEllMatrix
      resPartVec = [];
      for jColsSecEllMatrix = 1:nColsSecEllMatrix
        if dimension(firstEllMat(iRowsSecEllMatrix, jColsSecEllMatrix)) ~= ...
                dimension(secondEllMat(iRowsSecEllMatrix, jColsSecEllMatrix))
          resPartVec = [resPartVec 0];
          continue;
        end
        qVec = firstEllMat(iRowsSecEllMatrix, jColsSecEllMatrix).center - ...
            secondEllMat(iRowsSecEllMatrix, jColsSecEllMatrix).center;
        QMat = sqrtm(firstEllMat(iRowsSecEllMatrix, jColsSecEllMatrix).shape) ...
            - sqrtm(secondEllMat(iRowsSecEllMatrix, jColsSecEllMatrix).shape);
        if (norm(qVec) > firstEllMat(iRowsSecEllMatrix,jColsSecEllMatrix).relTol)...
                || (norm(QMat) > firstEllMat(iRowsSecEllMatrix,jColsSecEllMatrix).relTol)
          resPartVec = [resPartVec 0];
        else
          resPartVec = [resPartVec 1];
        end
      end
      resMat = [resMat; resPartVec];
    end
  elseif (nFstEllipsoids > 1)
    for iRowsFstEllMatrix = 1:mRowsFstEllMatrix
      resPartVec = [];
      for jColsFstEllMatrix = 1:nColsFstEllMatrix
        if dimension(firstEllMat(iRowsFstEllMatrix, jColsFstEllMatrix)) ~= ...
                dimension(secondEllMat)
          resPartVec = [resPartVec 0];
          continue;
        end
        qVec = firstEllMat(iRowsFstEllMatrix, jColsFstEllMatrix).center - ...
            secondEllMat.center;
        QMat = sqrtm(firstEllMat(iRowsFstEllMatrix, jColsFstEllMatrix).shape) ...
            - sqrtm(secondEllMat.shape);
        if (norm(qVec) > firstEllMat(iRowsFstEllMatrix,jColsFstEllMatrix).relTol)...
                || (norm(QMat) > firstEllMat(iRowsFstEllMatrix,jColsFstEllMatrix).relTol)
          resPartVec = [resPartVec 0];
        else
          resPartVec = [resPartVec 1];
        end
      end
      resMat = [resMat; resPartVec];
    end
  else
    for iRowsSecEllMatrix = 1:mRowsSecEllMatrix
      resPartVec = [];
      for jColsSecEllMatrix = 1:nColsSecEllMatrix
        if dimension(firstEllMat) ~= dimension(secondEllMat(iRowsSecEllMatrix, jColsSecEllMatrix))
          resPartVec = [resPartVec 0];
          continue;
        end
        qVec = firstEllMat.center - secondEllMat(iRowsSecEllMatrix, jColsSecEllMatrix).center;
        QMat = sqrtm(firstEllMat.shape) - sqrtm(secondEllMat(iRowsSecEllMatrix, jColsSecEllMatrix).shape);
        if (norm(qVec) > firstEllMat.relTol) || (norm(QMat) > firstEllMat.relTol)
           resPartVec = [resPartVec 0];
        else
          resPartVec = [resPartVec 1];
        end
      end
      resMat = [resMat; resPartVec];
    end
  end

end
