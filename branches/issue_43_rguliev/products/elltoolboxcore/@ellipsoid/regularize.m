function regQMat = regularize(qMat,absTol)
%
% REGULARIZE - regularization of singular symmetric matrix.
%
% Input:
%   regular:
%       qMat: double [nDim,nDim] - symmetric matrix
%       absTol: double [1,1] - absolute tolerance
%
% Output:
%	regQMat: double [nDim,nDim] - regularized qMat with
%       absTol tolerance    
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

modgen.common.checkvar(qMat,'gras.la.ismatsymm(x)',...
    'errorMessage','matrix must be symmetric.');

[~, n] = size(qMat);
r      = rank(qMat);

if r < n
    [U, ~, ~] = svd(qMat);
    E       = absTol * eye(n - r);
    regQMat       = qMat + (U * [zeros(r, r) zeros(r, (n-r)); zeros((n-r), r) E] * U');
    regQMat       = 0.5*(regQMat + regQMat');
else
    regQMat = qMat;
end
