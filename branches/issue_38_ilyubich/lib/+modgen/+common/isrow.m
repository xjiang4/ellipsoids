function isPositive=isrow(inpArray)
isPositive=size(inpArray,1)==1&&...
    numel(inpArray)==length(inpArray)&&...
    ismatrix(inpArray);