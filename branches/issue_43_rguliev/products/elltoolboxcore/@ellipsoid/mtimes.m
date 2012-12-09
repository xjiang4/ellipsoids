function outEllVec = mtimes(multMat, inpEllVec)
%
% MTIMES - overloaded operator '*'.
%
%   Multiplication of the ellipsoid by a matrix or a scalar.
%   If inpEllVec(iEll) = E(q, Q) is an ellipsoid, and
%   multMat = A - matrix of suitable dimensions,
%   then A E(q, Q) = E(Aq, AQA').
%
% Input:
%   regular:
%       multMat: double[mRows, nDims]/[1, 1] - scalar or
%           matrix in R^{mRows x nDim}
%       inpEllVec: ellipsoid [1, nCols] - array of ellipsoids.
%
% Output:
%   outEllVec: ellipsoid [1, nCols] - resulting ellipsoids.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.checkvar

ellipsoid.checkIsMe(inpEllVec,'second');
checkvar(multMat,@(x) isa(x,'double'),...
    'errorTag','wrongInput','errorMessage',...
    'first input argument must be matrix or sacalar.');
checkvar(inpEllVec,'~any(isempty(x(:)))',...
    'errorTag','wrongInput','errorMessage',...
    'array of ellipsoids contains empty ellipsoid');


isFstScal=isscalar(multMat);

nDims = size(multMat,2);
nDimsVec = dimension(inpEllVec);

modgen.common.checkmultvar...
    ('all(x2(:)==x2(1)) && (x1 || (~x1)&&(x2(1)==x3))',...
    3,isFstScal,nDimsVec,nDims,...
    'errorTag','wrongSizes',...
    'errorMessage','dimensions not match.');

if isFstScal
    multMatSq = multMat*multMat;
    outEllCVec = arrayfun(@(x) ellipsoid(multMat*x.center, multMatSq*x.shape ),...
        inpEllVec, 'UniformOutput',false);
else
    outEllCVec = arrayfun(@(x) fSingleMtimes(x), inpEllVec,...
        'UniformOutput',false);
end
outEllVec=reshape([outEllCVec{:}],size(inpEllVec));

    function newEll = fSingleMtimes(singEll)
        shMat = multMat*(singEll.shape)*multMat';
        shMat = 0.5*(shMat + shMat');
        newEll = ellipsoid(multMat *singEll.center, shMat);
    end
end