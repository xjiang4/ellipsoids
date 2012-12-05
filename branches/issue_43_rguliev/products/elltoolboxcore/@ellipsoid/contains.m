function resMat = contains(firstEllMat, secondEllMat)
% CONTAINS - checks if one ellipsoid contains the other.
%            The condition for E1 = firstEllMat to contain
%            E2 = secondEllMat is
%            min(rho(l | E1) - rho(l | E2)) > 0, subject to <l, l> = 1.
%
% Input:
%   regular:
%       firstEllMat: ellipsoid [mRows, nCols] - first matrix
%           of ellipsoids.
%       secondEllMat: ellipsoid [mRows, nCols] - second matrix
%           of ellipsoids.
%
% Output:
%   resMat: double[mRows, nCols],
%       resMat(iRows, jCols) = 1 - firstEllMat(iRows, jCols)
%       contains secondEllMat(iRows, jCols), 0 - otherwise.
%
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

import elltool.conf.Properties;
import modgen.common.throwerror;
import modgen.common.checkmultvar;

ellipsoid.checkIsMe(firstEllMat,...
    'errorTag','wrongInput',...
    'errorMessage','input arguments must be ellipsoids.');
ellipsoid.checkIsMe(secondEllMat,...
    'errorTag','wrongInput',...
    'errorMessage','input arguments must be ellipsoids.');

nSizeFirst = numel(firstEllMat);
nSizeSecond = numel(secondEllMat);
isFirScal = nSizeFirst==1;
isSecScal = nSizeSecond==1;

checkmultvar('isscalar(x1)||isscalar(x2)|| all( size(x1)==size(x2) )',...
    2,firstEllMat,secondEllMat,...
    'errorTag','wrongInput',...
    'errorMessage','sizes of ellipsoidal arrays do not match.');

dimFirMat = dimension(firstEllMat);
dimSecMat = dimension(secondEllMat);

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
    resMat = arrayfun(@(x) l_check_containment(firstEllMat,x), secondEllMat);
elseif isSecScal
    resMat = arrayfun(@(x) l_check_containment(x, secondEllMat), firstEllMat);
else
    resMat = arrayfun(@(x,y) l_check_containment(x,y), firstEllMat,secondEllMat);
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
