function minEigArr = mineig(inpEllArr)
%
% MINEIG - return the minimal eigenvalue of the ellipsoid.
%
% Input:
%   regular:
%       inpEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%
% Output:
%   minEigMat: double[mRows, nCols] - array of minimal eigenvalues
%       of ellipsoids in the input array inpEllMat.
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

minEigArr = arrayfun(@(x) min(eig(x.shape)),inpEllArr);
