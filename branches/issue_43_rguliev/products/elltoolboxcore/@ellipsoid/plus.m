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
import modgen.common.checkmultvar;

checkmultvar(@(x1,x2) ~( (isa(x1, 'ellipsoid') && isa(x2, 'double')) ||...
    (isa(x1, 'double') || isa(x2, 'ellipsoid')) ),2,X,Y,...
    'errorMessage','PLUS: this operation is only permitted between ellipsoid and vector in R^n.');
if isa(X, 'ellipsoid')
    ellArr = X;
    b = Y;
else
    ellArr = Y;
    b = X;
end

dimsVec = dimension(ellArr);
checkmultvar('iscolumn(x1)&&all(x2==length(x1))',2,b,dimsVec,...
    'errorMessage','PLUS: dimensions mismatch');

ellCArr = arrayfun(@(x) ellipsoid(x.center + b, x.shape), ellArr,...
    'UniformOutput',false);

outEllArr=reshape([ellCArr{:}],size(ellArr));
