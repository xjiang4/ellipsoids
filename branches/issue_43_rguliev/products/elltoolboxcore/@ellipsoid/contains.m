function resArr = contains(firstEllArr, secondEllArr)
% CONTAINS - checks if one ellipsoid contains the other.
%            The condition for E1 = firstEllArr to contain
%            E2 = secondEllArr is
%            min(rho(l | E1) - rho(l | E2)) > 0, subject to <l, l> = 1.
%
% Input:
%   regular:
%       firstEllArr: ellipsoid [,] - first array
%           of ellipsoids.
%       secondEllArr: ellipsoid [,] - second array
%           of ellipsoids.
%
% Output:
%   resArr: double[,],
%       resArr(iCount) = 1 - firstEllMat(iCount)
%       contains secondEllMat(iCount), 0 - otherwise.
%
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror;
import modgen.common.checkmultvar;

ellipsoid.checkIsMe(firstEllArr,'first');
ellipsoid.checkIsMe(secondEllArr,'second');

nSizeFirst = numel(firstEllArr);
nSizeSecond = numel(secondEllArr);
isFirScal = nSizeFirst==1;
isSecScal = nSizeSecond==1;

checkmultvar('isscalar(x1)||isscalar(x2)|| all( size(x1)==size(x2) )',...
    2,firstEllArr,secondEllArr,...
    'errorTag','wrongInput',...
    'errorMessage','sizes of ellipsoidal arrays do not match.');

dimFirMat = dimension(firstEllArr);
dimSecMat = dimension(secondEllArr);

checkmultvar('all(x1(:)==x1(1)) && all(x2(:)==x1(1))',2,dimFirMat,dimSecMat,...
    'errorTag','wrongSizes',...
    'errorMessage','ellipsoids must be of the same dimension.');

if Properties.getIsVerbose()
    if isFirScal && isSecScal
        fprintf('Checking ellipsoid-in-ellipsoid containment...\n');
    else
        fprintf('Checking %d ellipsoid-in-ellipsoid containments...\n',...
            max([nSizeFirst nSizeSecond]));
    end
end

if isFirScal
    resArr = arrayfun(@(x) l_check_containment(firstEllArr,x), secondEllArr);
elseif isSecScal
    resArr = arrayfun(@(x) l_check_containment(x, secondEllArr), firstEllArr);
else
    resArr = arrayfun(@(x,y) l_check_containment(x,y), firstEllArr,secondEllArr);
end

end




%%%%%%%%

function res = l_check_containment(firstEll, secondEll)
%
% L_CHECK_CONTAINMENT - check if secondEll is inside firstEll.
%
% Input:
%   regular:
%       firstEll: ellipsoid [1, nCols] - first ellipsoid.
%       secondEll: ellipsoid [1, nCols] - second ellipsoid.
%
% Output:
%   res: double[1,1], 1 - secondEll is inside firstEll, 0 - otherwise.
%
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror;

[fstEllCentVec, fstEllShMat] = double(firstEll);
[secEllCentVec, secEllShMat] = double(secondEll);
if size(fstEllShMat, 2) > rank(fstEllShMat)
    fstEllShMat = ellipsoid.regularize(fstEllShMat,firstEll.absTol);
end
if size(secEllShMat, 2) > rank(secEllShMat)
    secEllShMat = ellipsoid.regularize(secEllShMat,secondEll.absTol);
end

invFstEllShMat = ell_inv(fstEllShMat);
invSecEllShMat = ell_inv(secEllShMat);

AMat = [invFstEllShMat -invFstEllShMat*fstEllCentVec;...
    (-invFstEllShMat*fstEllCentVec)' ...
    (fstEllCentVec'*invFstEllShMat*fstEllCentVec-1)];
BMat = [invSecEllShMat -invSecEllShMat*secEllCentVec;...
    (-invSecEllShMat*secEllCentVec)'...
    (secEllCentVec'*invSecEllShMat*secEllCentVec-1)];

AMat = 0.5*(AMat + AMat');
BMat = 0.5*(BMat + BMat');
if Properties.getIsVerbose()
    fprintf('Invoking CVX...\n');
end
cvx_begin sdp
variable cvxxVec(1, 1)
AMat <= cvxxVec*BMat
cvxxVec >= 0
cvx_end

if strcmp(cvx_status,'Failed')
    throwerror('cvxError','Cvx failed');
end;
if strcmp(cvx_status,'Solved') ...
        || strcmp(cvx_status, 'Inaccurate/Solved')
    res = 1;
else
    res = 0;
end
end
