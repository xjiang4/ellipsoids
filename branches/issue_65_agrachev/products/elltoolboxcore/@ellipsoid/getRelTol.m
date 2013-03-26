function [relTolArr, varargout] = getRelTol(ellArr, varargin)
% GETRELTOL - gives the array of relTol for all elements in ellArr
%
% Input:
%   regular:
%       ellArr: ellipsoid[nDim1, nDim2, ...] - multidimension array
%           of ellipsoids
%   optional 
%       fRelTolFun: - function handle, that apply to the relTolArr
%           The default is @min.
% Output:
%   regular:
%       relTolArr: double [relTol1, relTol2, ...] - return relTol for 
%           each element in ellArr
%   optional:
%       relTol: double - return result of work fRelTolFun with 
%           the relTolArr
%
% Tips:
%   use [~,relTol] = ellArr.getRelTol() if you want get only
%       relTol,
%   use [relTolArr,relTol] = ellArr.getRelTol() if you want get 
%       relTolArr and relTol,
%   use relTolArr = ellArr.getRelTol() if you want get only relTolArr
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
    fRelTolFun = @min;
elseif nargin == 2
    fRelTolFun = varargin{1};
else
    throwerror('wrongInput', 'Too many input arguments');
end

relTolArr = getProperty(ellArr,'relTol');
if nargout == 2    
    varargout{1} = fRelTolFun(relTolArr);
elseif (nargout ~= 1) && (nargout ~= 0)
    throwerror('wrongOutput', 'Too many output arguments');
end