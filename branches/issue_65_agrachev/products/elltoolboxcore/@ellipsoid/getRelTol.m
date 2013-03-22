function [relTolArr, varargout] = getRelTol(ellArr, varargin)
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