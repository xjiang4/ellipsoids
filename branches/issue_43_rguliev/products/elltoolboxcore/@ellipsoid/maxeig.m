function maxEigArr = maxeig(inpEllArr)
%
% MAXEIG - return the maximal eigenvalue of the ellipsoid.
%
% Input:
%   regular:
%       inpEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%
% Output:
%   maxEigMat: double[mRows, nCols] - matrix of maximal eigenvalues
%       of ellipsoids in the input matrix inpEllMat.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;

ellipsoid.checkIsMe(inpEllArr,...
    'errorTag','wrongInput',...
    'errorMessage','second input argument must be ellipsoid.');
modgen.common.checkvar(inpEllArr,'~any(isempty(x(:)))',...
    'errorTag','wrongInput:emptyEllipsoid','errorMessage',...
    'input argument contains empty ellipsoid');

maxEigArr = arrayfun(@(x) max(eig(x.shape)),inpEllArr);