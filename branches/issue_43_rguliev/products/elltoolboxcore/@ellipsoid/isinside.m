function [res, status] = isinside(fstEllMat, secObjMat, mode)
%
% ISINSIDE - checks if the intersection of ellipsoids contains the
%            union or intersection of given ellipsoids or polytopes.
%
%   res = ISINSIDE(fstEllMat, secEllMat, mode) Checks if the union
%       (mode = 'u') or intersection (mode = 'i') of ellipsoids in
%       secEllMat lies inside the intersection of ellipsoids in
%       fstEllMat. Ellipsoids in fstEllMat and secEllMat must be
%       of the same dimension. mode = 'u' (default) - union of
%       ellipsoids in secEllMat. mode = 'i' - intersection.
%   res = ISINSIDE(fstEllMat, secPolyMat, mode) Checks if the union
%       (mode = 'u') or intersection (mode = 'i')  of polytopes in
%       secPolyMat lies inside the intersection of ellipsoids in
%       fstEllMat. Ellipsoids in fstEllMat and polytopes in secPolyMat
%       must be of the same dimension. mode = 'u' (default) - union of
%       polytopes in secPolyMat. mode = 'i' - intersection.
%
%   To check if the union of ellipsoids secEllMat belongs to the
%   intersection of ellipsoids fstEllMat, it is enough to check that
%   every ellipsoid of secEllMat is contained in every
%   ellipsoid of fstEllMat.
%   Checking if the intersection of ellipsoids in secEllMat is inside
%   intersection fstEllMat can be formulated as quadratically
%   constrained quadratic programming (QCQP) problem.
%
%   Let fstEllMat(iEll) = E(q, Q) be an ellipsoid with center q and shape
%   matrix Q. To check if this ellipsoid contains the intersection of
%   ellipsoids in secObjMat:
%   E(q1, Q1), E(q2, Q2), ..., E(qn, Qn), we define the QCQP problem:
%                     J(x) = <(x - q), Q^(-1)(x - q)> --> max
%   with constraints:
%                     <(x - q1), Q1^(-1)(x - q1)> <= 1   (1)
%                     <(x - q2), Q2^(-1)(x - q2)> <= 1   (2)
%                     ................................
%                     <(x - qn), Qn^(-1)(x - qn)> <= 1   (n)
%
%   If this problem is feasible, i.e. inequalities (1)-(n) do not
%   contradict, or, in other words, intersection of ellipsoids
%   E(q1, Q1), E(q2, Q2), ..., E(qn, Qn) is nonempty, then we can find
%   vector y such that it satisfies inequalities (1)-(n)
%   and maximizes function J. If J(y) <= 1, then ellipsoid E(q, Q)
%   contains the given intersection, otherwise, it does not.
%
%   The intersection of polytopes is a polytope, which is computed
%   by the standard routine of MPT. If the vertices of this polytope
%   belong to the intersection of ellipsoids, then the polytope itself
%   belongs to this intersection.
%   Checking if the union of polytopes belongs to the intersection
%   of ellipsoids is the same as checking if its convex hull belongs
%   to this intersection.
%
% Input:
%   regular:
%       fstEllMat: ellipsoid [mRows, mCols] - matrix of ellipsoids
%           of the same size.
%       secEllMat: ellipsoid [mSecRows, nSecCols] /
%           polytope [mSecRows, nSecCols] - matrix of ellipsoids or
%           polytopes of the same sizes.
%
%           note: if mode == 'i', then fstEllMat, secEllVec should be
%               array.
%
%   optional:
%       mode: char[1, 1] - 'u' or 'i', go to description.
%
% Output:
%   res: double[1, 1] - result:
%       -1 - problem is infeasible, for example, if s = 'i',
%           but the intersection of ellipsoids in E2 is an empty set;
%       0 - intersection is empty;
%       1 - if intersection is nonempty.
%   status: double[0, 0]/double[1, 1] - status variable. status is empty
%       if mode == 'u' or mSecRows == nSecCols == 1.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $
%
% $Author: Vadim Kaushanskiy <vkaushanskiy@gmail.com>$ $Date: 10-11-2012$
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Computer Science,
%            System Analysis Department 2012 $

import elltool.conf.Properties;
import modgen.common.throwerror;
import modgen.common.checkmultvar;

ellipsoid.checkIsMe(fstEllMat,...
    'errorTag','wrongInput',...
    'errorMessage', 'first input argument must be ellipsoid.');
modgen.common.checkvar(secObjMat,@(x) isa(x, 'ellipsoid') ||...
    isa(x, 'hyperplane') || isa(x, 'polytope'),...
    'errorTag','wrongInput', 'errorMessage',...
    'second input argument must be ellipsoid,hyperplane or polytope.');

if (nargin < 3) || ~(ischar(mode))
    mode = 'u';
end

status = [];

if isa(secObjMat, 'polytope')
    if mode == 'i'
        xVec = extreme(and(secObjMat));
    else
        xVec = arrayfun(@(x) extreme(x), secObjMat);
    end
    if isempty(xVec)
        res = -1;
    else
        res = min(isinternal(fstEllMat, xVec', 'i'));
    end
    
    if nargout < 2
        clear status;
    end
    
    return;
end

if mode == 'u'
    res    = 1;
    isContain = arrayfun(@(x) all(all(contains(x, secObjMat))), fstEllMat);
    if ~all( isContain(:) )
        res=0;
        return;
    end
elseif isscalar(secObjMat)
    res = 1;
    if ~all(all(contains(fstEllMat, secObjMat)))
        res = 0;
    end
else
    nFstEllDimsMat = dimension(fstEllMat);
    nSecEllDimsMat = dimension(secObjMat);
    checkmultvar('(x1(1)==x2(1))&&all(x1(:)==x1(1))&&all(x2(:)==x2(1))',...
        2,nFstEllDimsMat,nSecEllDimsMat,...
        'errorTag','wrongSizes',...
        'errorMessage','input arguments must be of the same dimension.');
    if Properties.getIsVerbose()
        fprintf('Invoking CVX...\n');
    end
    res    = 1;
    resMat  =arrayfun (@(x) qcqp(secObjMat,x), fstEllMat);
    if any(resMat(:)<1)
        res=0;
        if any(resMat(:)==-1)
            status = 0;
        end
        return;
    end
end

end





%%%%%%%%

function res = qcqp(fstEllMat, secObj)
%
% QCQP - formulate quadratically constrained quadratic programming
%        problem and invoke external solver.
%
% Input:
%   regular:
%       fstEllMat: ellipsod [mEllRows, nEllCols] - matrix of ellipsoids.
%       secObj: ellipsoid [1, 1] - ellipsoid.
%               or
%               polytope [1, 1] - polytope.
%
% Output:
%   res: double[1, 1]
%   status: double[1, 1]
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import modgen.common.throwerror;
import elltool.conf.Properties;

absTolSec = getAbsTol(secObj);
[cSecVec, shSecMat] = double(secObj);
if isdegenerate(secObj)
    if Properties.getIsVerbose()
        fprintf('QCQP: Warning! Degenerate ellipsoid.\n');
        fprintf('      Regularizing...\n');
    end
    shSecMat = ellipsoid.regularize(shSecMat,absTolSec);
end
invQMat = ell_inv(shSecMat);
invQMat = 0.5*(invQMat + invQMat');

cvx_begin sdp
variable xVec(length(invQMat), 1)

minimize(xVec'*invQMat*xVec + 2*(-invQMat*cSecVec)'*xVec + ...
    (cSecVec'*invQMat*cSecVec - 1))
subject to

arrayfun(@(x) fRepPart(x), fstEllMat);

cvx_end


status = 1;
if strcmp(cvx_status,'Failed')
    throwerror('cvxError','Cvx failed');
end;
if strcmp(cvx_status,'Infeasible') ...
        || strcmp(cvx_status,'Inaccurate/Infeasible')
    % problem is infeasible, or global minimum cannot be found
    res = -1;
    return;
end

if (xVec'*invQMat*xVec + 2*(-invQMat*cSecVec)'*xVec + ...
        (cSecVec'*invQMat*cSecVec - 1)) < min(getAbsTol(fstEllMat(:)))
    res = 1;
else
    res = 0;
end
    function fRepPart(singEll)
        [cVec, shMat] = parameters(singEll);
        if isdegenerate(singEll)
            shMat = ...
                ellipsoid.regularize(shMat,getAbsTol(singEll));
        end
        invShMat = ell_inv(shMat);
        invShMat = 0.5*(invShMat + invShMat');
        xVec'*invShMat*xVec + 2*(-invShMat*cVec)'*xVec + ...
            (cVec'*invShMat*cVec - 1) <= 0;
    end
end
