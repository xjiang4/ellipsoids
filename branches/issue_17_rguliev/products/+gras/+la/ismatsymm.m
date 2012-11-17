function isSymm = ismatsymm(qMat)
% ISMATSYMM  checks if qMat is symmetric
% Input:
%      qMat: double[nDims, nDims]
% Output:
%   ismatsymm: logical[1,1]
%
% 
% $Author: Rustam Guliev  <glvrst@gmail.com> $	$Date: 2012-16-11$
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Cybernetics,
%            System Analysis Department 2012 $
import modgen.common.throwerror;

[nRows, nCols] = size(qMat);
if (nRows~=nCols)
    throwerror('wrongInput:nonSquareMat','ISMATSYMM: Input matrix mast be square.');
end
isSymm=false;
if (all(all(qMat==qMat')))
    isSymm=true;
end

end