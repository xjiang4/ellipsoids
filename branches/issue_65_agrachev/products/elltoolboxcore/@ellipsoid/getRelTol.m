function relTol = getRelTol(ellArr, varargin)
% GETRELTOL - gives the smalles relTol between relTol for each ellipsoid
%   in ellArr
%
% Input:
%   regular:
%       ellArr: ellipsoid[nDim1, nDim2, ...] - multidimension array
%           of ellipsoids
%
% Output:
%   relTolArr: double[nDim1, nDim2,...] - multidimension array of relTol
%       properties for ellipsoids in ellArr
%
% $Author: Grachev Artem <grachev.art@gmail.com> $
%   $Date: 7-march-2013$
% $Copyright: Moscow State University,
%            Faculty of Computational Arrhematics and Computer Science,
%            System Analysis Department 2013 $
%
if nargin == 1 
    relTolFun = @min;
elseif nargin == 2 
    relTolFun = varargin{1};
else
    error('Too many input arguments');
end

relTolArr = getRelTolArr(ellArr);
relTol = relTolFun(relTolArr);
