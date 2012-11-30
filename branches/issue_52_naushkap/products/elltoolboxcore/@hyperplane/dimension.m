function dimsArr = dimension(inpHypArr);
%
% DIMENSION - returns dimensions of hyperplanes in the array.
%
%   dimsArr = DIMENSION(hypArr) - returns dimensions of hyperplanes
%       described by hyperplane structures in the array hypArr.
%
% Input:
%   regular:
%       hypArr: hyperplane [nDims1, nDims2, ...] - array
%           of hyperplanes.
%
% Output:
%       dimsArr: double[nDims1, nDims2, ...] - dimensions
%           of hyperplanes.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $
%
% $Author: Aushkap Nikolay <n.aushkap@gmail.com> $  $Date: 30-11-2012$
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Computer Science,
%            System Analysis Department 2012 $

modgen.common.checkvar(inpHypArr, 'isa(x,''hyperplane'')',...
    'errorTag', 'wrongInput',...
    'errorMessage', 'DIMENSION: input must be array of hyperplanes.');

dimsArr = arrayfun(@(x) subDimFunc(x), inpHypArr,...
    'UniformOutput', true);

end

function nDim = subDimFunc(myHyp)
%
% SUBDIMFUNC - returns dimension of single hyperplane in.
%
% Input:
%   regular:
%       myHyp: hyperplane [1, 1] - single hyperplane.
%
% Output:
%       nDim: double[1, 1] - dimension of hyperplane.
%
% $Author: Aushkap Nikolay <n.aushkap@gmail.com> $  $Date: 30-11-2012$
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Computer Science,
%            System Analysis Department 2012 $

subDim = size(myHyp.normal, 1);
if subDim < 2
    if (abs(myHyp.normal) <= myHyp.absTol) && ...
            (abs(myHyp.shift) <= myHyp.absTol)
        nDim = 0;
    else
        nDim = subDim;
    end
else
    nDim = subDim;
end

end
