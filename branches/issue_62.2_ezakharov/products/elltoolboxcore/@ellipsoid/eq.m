function [isEqualArr, reportStr] = eq(ellFirstArr, ellSecArr,varargin)
% EQ - compares two arrays of ellipsoids
%
% Input:
%   regular:
%       ellFirstArr: ellipsoid: [nDims1,nDims2,...,nDimsN]/[1,1]- the first
%           array of ellipsoid objects
%       ellSecArr: ellipsoid: [nDims1,nDims2,...,nDimsN]/[1,1] - the second
%           array of ellipsoid objects
%   optional:
%       maxTol: double[1,1] - maximum tolerance, used 
%           intstead of ellFirstArr.getRelTol()
% Output:
%   isEqualArr: logical: [nDims1,nDims2,...,nDimsN]- array of comparison
%       results
%
%   reportStr: char[1,] - comparison report
%
% $Author: Vadim Kaushansky  <vkaushanskiy@gmail.com> $    $Date: Nov-2012$
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Cybernetics,
%            System Analysis Department 2012 $
% $Author: Peter Gagarinov  <pgagarinov@gmail.com> $    $Date: Dec-2012$
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Cybernetics,
%            System Analysis Department 2012 $

import modgen.struct.structcomparevec;
import gras.la.sqrtmpos;
import elltool.conf.Properties;
import modgen.common.throwerror;
%
ellipsoid.checkIsMe(ellFirstArr,'first');
ellipsoid.checkIsMe(ellSecArr,'second');
%

nFirstElems = numel(ellFirstArr);
nSecElems = numel(ellSecArr);

modgen.common.checkvar( ellFirstArr, 'numel(x) > 0', 'errorTag', ...
    'wrongInput:emptyArray', 'errorMessage', ...
    'Each array must be not empty.');

modgen.common.checkvar( ellSecArr, 'numel(x) > 0', 'errorTag', ...
    'wrongInput:emptyArray', 'errorMessage', ...
    'Each array must be not empty.');

firstSizeVec = size(ellFirstArr);
secSizeVec = size(ellSecArr);
isnFirstScalar=nFirstElems > 1;
isnSecScalar=nSecElems > 1;
if nargin < 3
    [~, relTol] = ellFirstArr.getRelTol;
    tolerance = relTol;
else
    modgen.common.checkvar( varargin{1}, ...
    'isa(x,''double'') && (numel(x) == 1)', 'errorTag', ...
    'wrongInput:maxTolerance', 'errorMessage', ...
    'Tolerance must be scalar double.');
    tolerance = varargin{1};
end
%
SEll1Array=arrayfun(@formCompStruct,ellFirstArr);
SEll2Array=arrayfun(@formCompStruct,ellSecArr);
%
if isnFirstScalar&&isnSecScalar
    if ~isequal(firstSizeVec, secSizeVec)
        throwerror('wrongSizes',...
            'sizes of ellipsoidal arrays do not... match');
    end;
    compare();
    isEqualArr = reshape(isEqualArr, firstSizeVec);
elseif isnFirstScalar
    SEll2Array=repmat(SEll2Array, firstSizeVec);
    compare();
    
    isEqualArr = reshape(isEqualArr, firstSizeVec);
else
    SEll1Array=repmat(SEll1Array, secSizeVec);
    compare();
    isEqualArr = reshape(isEqualArr, secSizeVec);
end
    function compare()
        [isEqualArr,reportStr]=modgen.struct.structcomparevec(SEll1Array,...
            SEll2Array,tolerance);
    end
end
function SComp=formCompStruct(ellObj)
    SComp=struct('Q',gras.la.sqrtmpos(ellObj.shape, ellObj.absTol),'q',ellObj.center.');
end