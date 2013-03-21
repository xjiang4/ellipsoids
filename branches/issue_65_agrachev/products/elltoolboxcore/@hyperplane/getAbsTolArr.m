function [absTolArr, varargout] = getAbsTolArr(hplaneArr, varargin)
% GETABSTOLARR - gives array the same size as hplaneArr with values
%             of absTol properties for each hyperplane in hplaneArr.
% 
% Input:
%   regular:
%       hplaneArr: hyperplane[nDims1, nDims2,...] - hyperplane array.
% 
% Output:
%   absTolArr: double[nDims1, nDims2, ...] - array of absTol properties
%       for hyperplanes in hplaneArr.
% 
% $Author: Zakharov Eugene <justenterrr@gmail.com>$ $Date: 17-11-2012$
% $Copyright: Moscow State University,
%   Faculty of Computational Mathematics and Computer Science,
%   System Analysis Department 2012 $
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
    