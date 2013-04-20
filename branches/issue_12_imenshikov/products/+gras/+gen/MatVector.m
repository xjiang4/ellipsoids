classdef MatVector
    %MATVECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
        function dataArray=triu(dataArray)
            for iElem=1:size(dataArray,3)
                dataArray(:,:,iElem)=triu(dataArray(:,:,iElem));
            end
        end
        function resDataArray=makeSymmetric(dataArray)
            import gras.gen.MatVector;
            resDataArray=0.5*(dataArray+MatVector.transpose(dataArray));
        end
        %
        function invDataArray=pinv(dataArray)
            Xsize=size(dataArray);
            if length(Xsize)==2
                Xsize(3)=1;
            end
            invDataArray=zeros(Xsize([2 1 3]));
            for t=1:1:Xsize(3)
                invDataArray(:,:,t)=pinv(dataArray(:,:,t));
            end
        end
        %
        function outTransArray=transpose(inpArray)
            Asize=size(inpArray);
            if length(Asize)==2
                Asize(3)=1;
            end
            outTransArray=zeros([Asize(2) Asize(1) Asize(3)]);
            for t=1:1:Asize(3)
                outTransArray(:,:,t)=inpArray(:,:,t).';
            end
        end
        function Y=fromFormulaMat(X,t)
            import gras.gen.MatVector;
            expStr=modgen.cell.cellstr2expression(X);
            Y=MatVector.fromExpression(expStr,t);
        end
        %
        function yArray=fromFunc(fHandle,t)
            nTimePoints = numel(t);
            mMat = fHandle(t(1));
            yArray = zeros([size(mMat) nTimePoints]);
            yArray(:,:,1) = mMat;
            for iTimePoint = 2:nTimePoints
                yArray(:,:,iTimePoint) = fHandle(t(iTimePoint));
            end
        end
        %
        function Y=fromExpression(expStr,t)
            if numel(t)==1
                Y=eval(expStr);
            else
                t=shiftdim(t,-1);
                Y=eval(expStr);
                nTimePoints=numel(t);
                if size(Y,3)==1&&nTimePoints>1
                    Y=repmat(Y,[1,1,nTimePoints]);
                end
            end
        end
        %
        function cMat = rMultiplyByVec(aArray,bMat,useSparseMatrix)
            if nargin < 3
                useSparseMatrix = true;
            end
            [nRows, nCols, nTimePoints] = size(aArray);
            if useSparseMatrix
                iVec = 1:nCols*nTimePoints;
                jVec = reshape(repmat(1:nTimePoints,nCols,1), ...
                    nCols*nTimePoints,1);
                bSparseMat = sparse(iVec,jVec,bMat, ...
                    nCols*nTimePoints,nTimePoints,nCols*nTimePoints);
                cMat = reshape(aArray,nRows,nCols*nTimePoints)*bSparseMat;      
            else
                cMat = zeros(nRows,nTimePoints);
                for iTimePoint = 1:nTimePoints
                    cMat(:,iTimePoint) = ...
                        aArray(:,:,iTimePoint)*bMat(:,iTimePoint);
                end;
            end
        end
        %
        function dArray = rMultiply(aArray, bArray, varargin)
            switch nargin
                case 4
                    cArray = varargin{1};
                    useSparseMatrix = varargin{2};
                case 3
                    if isscalar(varargin{1})
                        cArray = [];
                        useSparseMatrix = varargin{1};
                    else
                        cArray = varargin{1};
                        useSparseMatrix = false;
                    end
                case 2
                    cArray = [];
                    useSparseMatrix = false;
            end
            %           
            [nARows, nACols, nTimePoints] = size(aArray);
            nBCols = size(bArray,2);
            nCCols = size(cArray,2);
            %
            if useSparseMatrix
                aMat = reshape(aArray,nARows,nACols*nTimePoints);
                if isempty(cArray)
                    dMat = aMat*getSparseMat(bArray);
                    dArray = reshape(dMat,nARows,nBCols,nTimePoints);
                else
                    dMat = aMat*getSparseMat(bArray)*getSparseMat(cArray);
                    dArray = reshape(dMat,nARows,nCCols,nTimePoints);
                end
            else
                if isempty(cArray)
                    dArray = zeros(nARows,nBCols,nTimePoints);
                    for iTimePoint = 1:nTimePoints
                        dArray(:,:,iTimePoint) = aArray(:,:,iTimePoint)...
                            *bArray(:,:,iTimePoint);
                    end
                else
                    dArray = zeros(nARows,nCCols,nTimePoints);
                    for iTimePoint = 1:nTimePoints
                        dArray(:,:,iTimePoint) = aArray(:,:,iTimePoint)...
                            *bArray(:,:,iTimePoint)*cArray(:,:,iTimePoint);
                    end
                end
            end
            %
            function rSparseMat = getSparseMat(rArray)
                [nRows, nCols, ~] = size(rArray);
                iMat = repmat(1:nRows*nTimePoints,nCols,1);
                iArray = reshape(iMat,nCols,nRows,nTimePoints);
                iArray = permute(iArray,[2 1 3]);
                iVec = reshape(iArray,nRows*nCols*nTimePoints,1);
                jVec = reshape(repmat(1:nCols*nTimePoints,nRows,1),...
                    nRows*nCols*nTimePoints,1);
                rSparseMat = sparse(iVec,jVec,rArray(:),...
                    nRows*nTimePoints,nCols*nTimePoints,...
                    nRows*nCols*nTimePoints);
            end
        end
    end
end
