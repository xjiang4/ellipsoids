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

checkIsMe(ellArr);
modgen.common.type.simple.checkgen(B, @(x)isa(x,'double'),...
    'Input argumet');

[k, l] = size(B);
dims   = dimension(ellArr);
m = min(dims(:));
n = max(dims(:));
if (m ~= n)
    error('PROJECTION: ellipsoids in the array must be of the same dimenion.');
end
if (k ~= n)
    error('PROJECTION: dimension of basis vectors does not dimension of ellipsoids.');
end
if (k < l)
    msg = sprintf('PROJECTION: number of basis vectors must be less or equal to %d.', n);
    error(msg);
end

% check the orthogonality of the columns of B
scalProdMat = B' * B;
normSqVec = diag(scalProdMat);

absTolArr = ellArr.getAbsTol();
absTol = max(absTolArr);
isOrtogonalMat =(scalProdMat - diag(normSqVec))> absTol;
if any(isOrtogonalMat(:))
    error('PROJECTION: basis vectors must be orthogonal.');
end

% normalize the basis vectors
normVec = sqrt(normSqVec);
BB = B./normVec(ones(1,dims),1);

% compute projection
ellCArr = arrayfun(@(x) BB'*x, ellArr,'UniformOutput',false);
projEllArr=reshape([ellCArr{:}],size(ellArr));
