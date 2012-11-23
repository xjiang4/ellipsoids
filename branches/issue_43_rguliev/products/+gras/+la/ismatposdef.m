function isPosDef = ismatposdef(qMat)
% ISMATPOSDEF  checks if qMat is positive definiteness
%
% Input:
%	regular:
%       qMat: double[nDims, nDims]
%
% Output:
%   isPosDef: logical[1,1] - indicates whether a matrix is positive definiteness.
% 
%
% $Author: Rustam Guliev  <glvrst@gmail.com> $	$Date: 2012-24-11$
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Cybernetics,
%            System Analysis Department 2012 $
%

import modgen.common.throwerror;

[nRows, nCols] = size(qMat);
if (nRows~=nCols)
    throwerror('wrongInput:nonSquareMat',...
        'ISMATSYMM: Input matrix mast be square.');
end
isPosDef=false;
if min(eig(qMat))>0
    isPosDef=true;
end