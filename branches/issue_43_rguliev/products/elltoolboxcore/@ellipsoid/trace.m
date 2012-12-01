function trArr = trace(ellArr)
%
% TRACE - returns the trace of the ellipsoid.
%
%
% Description:
% ------------
%
%    T = TRACE(E)  Computes the trace of ellipsoids in ellipsoidal array E.
%
%
% Output:
% -------
%
%    T - array of trace values, same size as E.
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

checkIsMe(ellArr,...
    'errorMessage','TRACE: input argument must be array of ellipsoids.');
modgen.common.checkvar(ellArr,'~any(isempty(ellArr(:)))',...
    'errorTag','wrongInput:emptyEllipsoid',...
    'erroeMessage','TRACE: input argument contains empty ellipsoid.')
trArr = arrayfun(@(x) trace(x.shape), ellArr);
