function [isEqualArr, reportStr] = eq(ellFirstArr, ellSecArr)

import modgen.struct.structcomparevec;
import gras.la.sqrtm;
import elltool.conf.Properties;
import modgen.common.type.simple.*;

ellipsoid.checkIsMe(ellFirstArr,...
    'errorTag','wrongInput',...
    'errorMessage','input arguments must be ellipsoids.');
ellipsoid.checkIsMe(ellSecArr,...
    'errorTag','wrongInput',...
    'errorMessage','input arguments must be ellipsoids.');

[kDim, lDim] = size(ellFirstArr);
nFirstElems = kDim * lDim;
[mDim, nDim] = size(ellSecArr);
nSecElems = mDim * nDim;

firstSizeVec = [kDim, lDim];
secSizeVec = [mDim, nDim];
relTol = ellFirstArr(1, 1).relTol;
if (nFirstElems > 1) && (nSecElems > 1)
    
    modgen.common.checkmultvar('isequal(x1,x2)',2,firstSizeVec, secSizeVec,...
        'errorTag','wrongSizes',...
        'errorMessage','sizes of ellipsoidal arrays do not match.');
    SEll1Array=arrayfun(@(x)struct('Q',gras.la.sqrtm(x.shape),'q',...
        x.center'),ellFirstArr(:, :));
    SEll2Array=arrayfun(@(x)struct('Q',gras.la.sqrtm(x.shape),'q',...
        x.center'),ellSecArr(:, :));
    [isEqualArr,reportStr]=modgen.struct.structcomparevec(SEll1Array,...
        SEll2Array,relTol);
    isEqualArr = reshape(isEqualArr, firstSizeVec);
elseif (nFirstElems > 1)
    
    SScalar = arrayfun(@(x)struct('Q',gras.la.sqrtm(x.shape),'q',...
        x.center'), ellSecArr);
    SEll1Array=arrayfun(@(x)struct('Q',gras.la.sqrtm(x.shape),'q',...
        x.center'),ellFirstArr(:, :));
    SEll2Array=repmat(SScalar, firstSizeVec);
    [isEqualArr,reportStr]=modgen.struct.structcomparevec(SEll1Array,...
        SEll2Array,relTol);
    
    isEqualArr = reshape(isEqualArr, firstSizeVec);
else
    SScalar = arrayfun(@(x)struct('Q',gras.la.sqrtm(x.shape),'q',...
        x.center'), ellFirstArr);
    SEll1Array=repmat(SScalar, secSizeVec);
    SEll2Array=arrayfun(@(x)struct('Q',gras.la.sqrtm(x.shape),'q',...
        x.center'),ellSecArr(:, :));
    [isEqualArr,reportStr]=modgen.struct.structcomparevec(SEll1Array,...
        SEll2Array,relTol);
    isEqualArr = reshape(isEqualArr, secSizeVec);
end

