function [absTolArr, varargout] = getAbsTolArr(ellArr, varargin)
% GETABSTOLARR - gives array the same size as ellArr with values of absTol
%   properties for each ellipsoid in ellArr
%
% Input:
%   regular:
%       ellArr: ellipsoid[nDim1, nDim2, ...] - multidimension array
%           of ellipsoids
%
% Output:
%   absTolArr: double[nDim1, nDim2,...] - multidimension array of absTol
%       properties for ellipsoids in ellArr
%
% $Author: Zakharov Eugene  <justenterrr@gmail.com> $
%   $Date: 17-november-2012$
% $Copyright: Moscow State University,
%            Faculty of Computational Arrhematics and Computer Science,
%            System Analysis Department 2012 $
%

import modgen.common.throwerror;

if nargin == 1
    fAbsTolFun = @min;
elseif nargin == 2
    fAbsTolFun = varargin{1};
else
    throwerror('wrongInput', 'Too many input arguments');
end

absTolArr = getProperty(ellArr,'absTol');
if nargout == 2    
    varargout{1} = fAbsTolFun(absTolArr);
elseif (nargout ~= 1) && (nargout ~= 0)
    throwerror('wrongOutput', 'Too many output arguments');
end
    
