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

checkIsMe(ellArr,...
    'errorMessage','input argument must be array of ellipsoids.');

sizeVec = size(ellArr);
ellCArr = arrayfun(@(x) ellipsoid(-x.center,x.shape), ellArr,...
    'UniformOutput',false);

%Convert cell array to ellipsoid array
outEllArr=reshape([ellCArr{:}],sizeVec);
