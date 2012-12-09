function trArr = trace(ellArr)
%
% TRACE - returns the trace of the ellipsoid.
%
%
% Description:
% ------------
%
%    trArr = TRACE(ellArr)  Computes the trace of ellipsoids in ellipsoidal array ellArr.
%
%
% Output:
% -------
%
%    trArr - array of trace values, same size as ellArr.
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

ellipsoid.checkIsMe(ellArr);
modgen.common.checkvar(ellArr,'~any(isempty(x(:)))',...
    'errorTag','wrongInput:emptyEllipsoid',...
    'errorMessage','input argument contains empty ellipsoid.')
trArr = arrayfun(@(x) trace(x.shape), ellArr);
