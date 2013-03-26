function [absTolArr, varargout] = getAbsTol(hplaneArr, varargin)
% GETABSTOL - gives the array of absTol for all elements in hplaneArr
%
% Input:
%   regular:
%       ellArr: hyperplane[nDim1, nDim2, ...] - multidimension array
%           of hyperplane
%   optional 
%       fAbsTolFun: - function handle, that apply to the absTolArr
%           The default is @min.
% 
% Output:
%   regular:
%       absTolArr: double [absTol1, absTol2, ...] - return absTol for 
%           each element in hplaneArr
%   optional:
%       absTol: double - return result of work fAbsTolFun with 
%           the absTolArr
%
% Tips:
%   use [~,absTol] = hplaneArr.getAbsTol() if you want get only
%       absTol,
%   use [absTolArr,absTol] = hplaneArr.getAbsTol() if you want get 
%       absTolArr and absTol,
%   use absTolArr = hplaneArr.getAbsTol() if you want get only absTolArr
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

absTolArr = arrayfun(@(x)x.absTol,hplaneArr);
if nargout == 2    
    varargout{1} = fAbsTolFun(absTolArr);
elseif (nargout ~= 1) && (nargout ~= 0)
    throwerror('wrongOutput', 'Too many output arguments');
end
    