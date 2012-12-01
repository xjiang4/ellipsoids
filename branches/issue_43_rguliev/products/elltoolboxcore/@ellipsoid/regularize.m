function regQMat = regularize(qMat,absTol)
%
% REGULARIZE - regularization of singular symmetric matrix.
%

modgen.common.checkvar(qMat,'gras.la.ismatsymm(x)',...
    'errorMessage','REGULARIZE: matrix must be symmetric.');

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
