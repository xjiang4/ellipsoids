function [normVec, hypScal] = double(myHyp)
%
% DOUBLE - return parameters of hyperplane - normal vector and shift.
%
%   [normVec, hypScal] = DOUBLE(myHyp) - returns normal vector
%       and scalar value of the hyperplane.
%
% Input:
%   regular:
%       myHyp: hyperplane [1, 1] - single hyperplane of dimention nDims.
%
% Output:
%   normVec: double[nDims, 1] - normal vector of the hyperplane myHyp.
%   hypScal: double[1, 1] - scalar of the hyperplane myHyp.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $
%
% $Author: Aushkap Nikolay <n.aushkap@gmail.com> $  $Date: 30-11-2012$
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Computer Science,
%            System Analysis Department 2012 $

modgen.common.checkvar(myHyp, 'isa(x,''hyperplane'')',...
    'errorTag', 'wrongInput',...
    'errorMessage', 'DOUBLE: input argument must be hyperplanes.');

modgen.common.checkvar(myHyp, '~(min(size(x) == [1 1]) < 1)',...
    'errorTag', 'wrongInput', 'errorMessage', ...
    'DOUBLE: input argument must be single hyperplane.');

normVec = myHyp.normal;
if ~(nargout < 2)
    hypScal = myHyp.shift;
end
