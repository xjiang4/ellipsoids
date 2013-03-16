function absTol = getAbsTol(hplaneArr, varargin)
% GETABSTOL - gives the smalles absTol between absTol for each ellipsoid
%   in ellArr
%
% Input:
%   regular:
%       ellArr: ellipsoid[nDim1, nDim2, ...] - multidimension array
%           of ellipsoids
%
% Output:
%   absTol: double - returns the smallest absTol of the ellArr
%
% $Author: Grachev Artem  <grachev.art@gmail.com> $
%   $Date: 7-march-2013$
% $Copyright: Moscow State University,
%            Faculty of Computational Arrhematics and Computer Science,
%            System Analysis Department 2013 $
%

if nargin == 1 
    absTolFun = @min;
elseif nargin == 2 
    absTolFun = varargin{1};
else
    error('Too many input arguments');
end

absTolArr = getAbsTolArr(hplaneArr);
absTol = absTolFun(absTolArr);