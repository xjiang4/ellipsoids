function xMat = ellbndr_3d(myEll)
%
% ELLBNDR_3D - compute the boundary of 3D ellipsoid. Private method.
%
% Input:
%   regular:
%       myEll: ellipsoid [1, 1]- ellipsoid of the dimention 3.
%
% Output:
%   xMat: double[3, nCols] - boundary points of the ellipsoid myEll.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

nMPoints   = 0.5*myEll.nPlot3dPoints;
nNPoints   = 0.5*nMPoints;

psyVec = linspace(0, pi, nNPoints);
phiVec = linspace(0, 2*pi, nMPoints);

lMat   = zeros(3,nMPoints*(nNPoints-2));
for iLayer = 2:(nNPoints - 1)
    arrVec = cos(psyVec(iLayer))*ones(1, nMPoints);
    lMat(:,(iLayer-2)*nMPoints+(1:nMPoints)) = [cos(phiVec)*sin(psyVec(iLayer));...
        sin(phiVec)*sin(psyVec(iLayer)); arrVec];
end
[~, xMat] = rho(myEll, lMat);
