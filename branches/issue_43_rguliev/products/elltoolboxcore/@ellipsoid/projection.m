function projEllArr = projection(ellArr, B)
%
% PROJECTION - computes projection of the ellipsoid onto the given subspace.
%
%
% Description:
% ------------
%
%    projEllArr = projection(ellArr, B)  Computes projection of the 
%                                        ellipsoid ellArr onto a subspace,
%                                        specified by orthogonal basis vectors B.
%                                        ellArr can be an array of ellipsoids of 
%                                        the same dimension. Columns of B must
%                                        be orthogonal vectors.
%
%
% Output:
% -------
%
%    projEllArr - projected ellipsoid (or array of ellipsoids), 
%                 generally, of lower dimension.
%
%
% See also:
% ---------
%
%    ELLIPSOID/ELLIPSOID.
%

%
% Author:
% -------
%
%    Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
%    Rustam Guliev <glvrst@gmail.com>
%

ellipsoid.checkIsMe(ellArr,'first');
modgen.common.checkvar(B, @(x)isa(x,'double'),'errorMessage',...
    'second input argument must be matrix with orthogonal columns.');

[nDim, nBasis] = size(B);
nDimsArr   = dimension(ellArr);
modgen.common.checkmultvar('(x2<=x1) && all(x3(:)==x1)',3,nDim,nBasis,nDimsArr,...
    'errorMessage','dimensions mismatch or number of basis vectors too large.');

% check the orthogonality of the columns of B
scalProdMat = B' * B;
normSqVec = diag(scalProdMat);

absTolArr = ellArr.getAbsTol();
absTol = max(absTolArr(:));
isOrtogonalMat =(scalProdMat - diag(normSqVec))> absTol;
if any(isOrtogonalMat(:))
    error('basis vectors must be orthogonal.');
end

% normalize the basis vectors
normMat = repmat( sqrt(normSqVec.'), nDim, 1);
BB = B./normMat;

% compute projection
ellCArr = arrayfun(@(x) BB'*x, ellArr,'UniformOutput',false);
projEllArr=reshape([ellCArr{:}],size(ellArr));
