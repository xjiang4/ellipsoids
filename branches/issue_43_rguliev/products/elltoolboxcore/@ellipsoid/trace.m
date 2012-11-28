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

import modgen.common.throwerror;

modgen.common.type.simple.checkgen(ellArr,@(x) isa(x,'ellipsoid'),...
    'Input argument');

if any(isempty(ellArr(:)))
    throwerror('wrongInput:emptyEllipsoid','TRACE: input argument is empty.');
end
trArr = arrayfun(@(x) trace(x.shape), ellArr);

