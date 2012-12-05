function outEllVec = minus(inpEllVec, inpVec)
%
% MINUS - overloaded operator '-'
%
%   Operation E - b where E = inpEll is an ellipsoid in R^n,
%   and b = inpVec - vector in R^n. If E(q, Q) is an ellipsoid
%   with center q and shape matrix Q, then
%   E(q, Q) - b = E(q - b, Q).
%
% Input:
%   regular:
%       inpEllVec: ellipsoid [1, nCols] - array of ellipsoids
%           of the same dimentions nDims.
%       inpVec: double[nDims, 1] - vector.
%
% Output:
%   outEllVec: ellipsoid [1, nCols] - array of ellipsoids with
%       same shapes as inpEllVec, but with centers
%       shifted by vectors in -inpVec.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.throwerror;

ellipsoid.checkIsMe(inpEllVec,...
    'errorTag','wrongInput',...
    'errorMessage','first input argument must be ellipsoid.');
modgen.common.checkvar(inpVec,@(x) isa(x, 'double'),...
    'errorTag','wrongInput',...
    'errorMessage','second argument must be vector in R^n.');

nDimsVec = dimension(inpEllVec);
[mRows, nColsInpVec] = size(inpVec);

modgen.common.checkmultvar('all(x1(:)==x2)&&(x3==1)',...
    3,nDimsVec,mRows,nColsInpVec,...
    'errorTag','wrongSizes',...
    'errorMessage','dimensions mismatch.');

outEllCVec = arrayfun(@(x) ellipsoid(x.center-inpVec,x.shape), inpEllVec,...
        'UniformOutput',false);
outEllVec=reshape([outEllCVec{:}],size(inpEllVec));
