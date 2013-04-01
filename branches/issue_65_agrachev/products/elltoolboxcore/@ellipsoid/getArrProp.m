function [propArr, propVal] = getArrProp(ellArr, propName, fPropFun)

if nargin == 2
    fPropFun = @min;
end

propArr = getProperty(ellArr, propName);

if nargout == 2
    propVal = fPropFun(propArr);
end


