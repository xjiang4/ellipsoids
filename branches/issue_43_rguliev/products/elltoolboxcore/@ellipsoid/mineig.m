function minEigArr = mineig(inpEllArr)
%
% MINEIG - return the minimal eigenvalue of the ellipsoid.
%
% Input:
%	regular:
%       inpEllArr: ellipsoid [nDims1,nDims2,...,nDimsN] - array of ellipsoids.
%
% Output:
%	minEigArr: double[nDims1,nDims2,...,nDimsN] - array of minimal eigenvalues
%       of ellipsoids in the input array inpEllMat.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;

ellipsoid.checkIsMe(inpEllArr);
modgen.common.checkvar(inpEllArr,'~any(isempty(x(:)))',...
    'errorTag','wrongInput:emptyEllipsoid','errorMessage',...
    'input argument contains empty ellipsoid');

minEigArr = arrayfun(@(x) min(eig(x.shape)),inpEllArr);
