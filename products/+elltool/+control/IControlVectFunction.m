classdef IControlVectFunction<handle
    methods (Abstract)
%        mSize=getMatrixSize(self)
        res=evaluate(self,x,timeVec)
%         nDims=getDimensionality(self)
%         nCols=getNCols(self)
%         nRows=getNRows(self)
    end
end