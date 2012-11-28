function outEllArr = plus(X, Y)
%
%
% Description:
% ------------
%
%    Operation
%              E + b
%    where E is an ellipsoid in R^n, and b - vector in R^n.
%    If E(q, Q) is an ellipsoid with center q and shape matrix Q, then
%          E(q, Q) + b = E(q + b, Q).
%
%
% Output:
% -------
%
%    Resulting ellipsoid E(q + b, Q).
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

if ~( (isa(X, 'ellipsoid') && isa(Y, 'double')) ||...
        (isa(X, 'double') || isa(Y, 'ellipsoid')) )
    error('PLUS: this operation is only permitted between ellipsoid and vector in R^n.');
end
if isa(X, 'ellipsoid')
    ellArr = X;
    b = Y;
else
    ellArr = Y;
    b = X;
end

d = dimension(ellArr);
m = max(d);
n = min(d);
if m ~= n
    error('PLUS: all ellipsoids in the array must be of the same dimension.');
end

[k, l] = size(b);
if (l ~= 1) || (k ~= n)
    error('PLUS: vector dimension does not match.');
end

ellCArr = arrayfun(@(x) ellipsoid(x.center + b, x.shape), ellArr,...
    'UniformOutput',false);

outEllArr=reshape([ellCArr{:}],size(ellArr));
