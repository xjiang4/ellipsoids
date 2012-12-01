function projEllArr = projection(ellArr, B)
%
% PROJECTION - computes projection of the ellipsoid onto the given subspace.
%
%
% Description:
% ------------
%
%    EP = PROJECTION(E, B)  Computes projection of the ellipsoid E onto a subspace,
%                           specified by orthogonal basis vectors B.
%                           E can be an array of ellipsoids of the same dimension.
%                           Columns of B must be orthogonal vectors.
%
%
% Output:
% -------
%
%    EP - projected ellipsoid (or array of ellipsoids), generally, of lower dimension.
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

checkIsMe(ellArr,...
    'errorMessage','PROJECTION: first input argument must be array of ellipsoids.');
modgen.common.checkvar(B, @(x)isa(x,'double'),'errorMessage',...
    'PROJECTION: second input argument must be matrix with orthogonal columns.');

[nDim, nBasis] = size(B);
nDimsArr   = dimension(ellArr);
modgen.common.checkmultvar('(x2<=x1) && all(x3(:)==x1)',3,nDim,nBasis,nDimsArr,...
    'errorMessage','PROJECTION: dimensions mismatch or number of basis vectors too large.');

% check the orthogonality of the columns of B
scalProdMat = B' * B;
normSqVec = diag(scalProdMat);

absTolArr = ellArr.getAbsTol();
absTol = max(absTolArr(:));
isOrtogonalMat =(scalProdMat - diag(normSqVec))> absTol;
if any(isOrtogonalMat(:))
    error('PROJECTION: basis vectors must be orthogonal.');
end

% normalize the basis vectors
normMat = repmat( sqrt(normSqVec.'), nDim, 1);
BB = B./normMat;

% compute projection
ellCArr = arrayfun(@(x) BB'*x, ellArr,'UniformOutput',false);
projEllArr=reshape([ellCArr{:}],size(ellArr));
