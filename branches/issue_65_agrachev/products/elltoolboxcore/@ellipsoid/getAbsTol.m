function absTol = getAbsTol(ellArr)
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
absTolArr = getAbsTolArr(ellArr);
absTol = min(absTolArr);
