function isPositive=iscelloffunc(inpArray)
isPositive=iscell(inpArray)&&...
    all(cellfun('isclass',inpArray,'function_handle'));