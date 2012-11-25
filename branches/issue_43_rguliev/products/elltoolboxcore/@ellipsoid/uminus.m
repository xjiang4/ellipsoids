function outEllArr = uminus(ellArr)
%
% Description:
% ------------
%
%    Changes the sign of the center of ellipsoid.
%

%
% Author:
% -------
%
%    Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
%    Rustam Guliev <glvrst@gmail.com>
%

modgen.common.type.simple.checkgen(ellArr,@(x) isa(x,'ellipsoid'),...
    'Input argument');

nDimsVec = size(ellArr);
ellCArr = arrayfun(@(x) ellipsoid(-x.center,x.shape), ellArr,...
    'UniformOutput',false);

%Conver cell array to ellipsoid array
outEllArr=reshape([ellCArr{:}],nDimsVec);
