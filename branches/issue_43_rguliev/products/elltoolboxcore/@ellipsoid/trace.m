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
    'errorMessage','input argument must be array of ellipsoids.');
modgen.common.checkvar(ellArr,'~any(isempty(x(:)))',...
    'errorTag','wrongInput:emptyEllipsoid',...
    'errorMessage','input argument contains empty ellipsoid.')
trArr = arrayfun(@(x) trace(x.shape), ellArr);
