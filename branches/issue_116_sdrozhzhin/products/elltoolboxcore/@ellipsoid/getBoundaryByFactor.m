function [bpGridMat, fGridMat] = getBoundaryByFactor(ellObj,factorVec)
%
%   GETBOUNDARYBYFACTOR - computes grid of 2d or 3d ellipsoid and vertices
%                         for each face in the grid
%
% Input:
%   regular:
%       ellObj: ellipsoid[1,1] - ellipsoid object
%   optional:
%       factorVec: double[1,2]\double[1,1] - number of points is calculated
%           by:
%           factorVec(1)*nPlot2dPoints - in 2d case
%           factorVec(2)*nPlot3dPoints - in 3d case.
%           If factorVec is scalar then for calculating the number of
%           in the grid it is multiplied by nPlot2dPoints
%           or nPlot3dPoints depending on the dimension of the ellObj
%
% Output:
%   regular:
%       bpGridMat: double[nVertices,nDims]/
%           double[nDims, ([nPoints/(vNum+eNum+1)]+1)*(vNum+eNum) + 1]
%           - vertices of the grid.
%              In the first step: vNum = 12, eNum = 30, fNum = 20.
%              In the next step: fNum = 4*fNum, eNum = 2*eNum + 3*fNum, vNum = vNum
%              + eNum. This process ends when vNum>=nPlot3dPoints*nPoints.
%
%       fGridMat: double[nFaces, nDims]/double[4 * fNum, nDims]
%           - indices of vertices in each face in the grid (2d/3d cases).
%
% $Author:  Vitaly Baranov  <vetbar42@gmail.com> $    $Date: <04-2013> $
% $Author: Ilya Lyubich  <lubi4ig@gmail.com> $    $Date: <03-2013> $
% $Copyright: Lomonosov Moscow State University,
%            Faculty of Computational Mathematics and Cybernetics,
%            System Analysis Department 2013 $
%
import modgen.common.throwerror
ellObj.checkIfScalar();
nDim=dimension(ellObj);

if nDim<2 || nDim>3
    throwerror('wrongDim','ellipsoid must be of dimension 2 or 3');
end

if nargin<2
    factor=1;
else
    factor=factorVec(nDim-1);
end
if nDim==2
    nPlotPoints=ellObj.nPlot2dPoints;
    if ~(factor==1)
        nPlotPoints=floor(nPlotPoints*factor);
    end
else
    nPlotPoints=ellObj.nPlot3dPoints;
    if ~(factor==1)
        nPlotPoints=floor(nPlotPoints*factor);
    end
end
[bpGridMat, fGridMat] = getBoundary(ellObj,nPlotPoints);