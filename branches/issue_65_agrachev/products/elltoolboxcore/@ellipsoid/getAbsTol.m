function [absTolArr, varargout] = getAbsTol(ellArr, varargin)
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
    