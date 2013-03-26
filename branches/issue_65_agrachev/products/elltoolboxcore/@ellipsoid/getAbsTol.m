function [absTolArr, varargout] = getAbsTol(ellArr, varargin)
% GETABSTOL - gives the array of absTol for all elements in ellArr
%
% Input:
%   regular:
%       ellArr: ellipsoid[nDim1, nDim2, ...] - multidimension array
%           of ellipsoids
%   optional 
%       fAbsTolFun: - function handle, that apply to the absTolArr
%           The default is @min.
% 
% Output:
%   regular:
%       absTolArr: double [absTol1, absTol2, ...] - return absTol for 
%           each element in ellArr
%   optional:
%       absTol: double - return result of work fAbsTolFun with 
%           the absTolArr
%
% Tips:
%   use [~,absTol] = ellArr.getAbsTol() if you want get only
%       absTol,
%   use [absTolArr,absTol] = ellArr.getAbsTol() if you want get 
%       absTolArr and absTol,
%   use absTolArr = ellArr.getAbsTol() if you want get only absTolArr
% 
%$Author: Zakharov Eugene  <justenterrr@gmail.com> $ 
% $Author: Grachev Artem  <grachev.art@gmail.com> $
%   $Date: March-2013$
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
    