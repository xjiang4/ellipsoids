classdef Ellipsoid < handle
    properties (SetAccess = private)
        centerVec
        diagMat
        eigvMat
    end
    methods
        function ellObj = Ellipsoid(varargin)
            global ellOptions
            import modgen.common.throwerror
            %
            nInput=length(varargin);
            if  nInput>3
                throwerror('wrongParameters','Incorrect number of parameters');
            elseif nInput==0
                ellObj.diagMat=0;
                ellObj.eigvMat=0;
                ellObj.centerVec=0;
            elseif nInput==1   
                ellMat=varargin{1};
                [mSize nSize]=size(ellMat);
                isPar2Vector= nSize==1;
                %
                if isPar2Vector
                    ellObj.diagMat=diag(ellMat);
                    ellObj.eigvMat=eye(size(ellObj.diagMat));
                elseif (mSize~=nSize) || (min(min((ellMat == ellMat.'))) == 0)
                    throwerror('wrongMatrix','Input should be a symmetric matrix or a vector.');
                elseif ellMat==ellMat.*eye(mSize,nSize) %check if the matrix is diagonal
                    ellObj.diagMat=ellMat;
                    ellObj.eigvMat=eye(mSize);
                else %ordinary square matrix
                    [ellObj.eigvMat ellObj.diagMat]=eig(ellMat);
                end
                ellObj.centerVec=zeros(mSize,1);
                
            elseif nInput==2
                ellCenterVec=varargin{1};
                ellMat=varargin{2};
                [mCenSize nCenSize]=size(ellCenterVec);
                [mSize nSize]=size(ellMat);
                isPar2Vector= nSize==1;
                %
                if isPar2Vector
                    ellObj.diagMat=diag(ellMat);
                    ellObj.eigvMat=eye(size(ellObj.diagMat));
                elseif (mSize~=nSize) || (min(min((ellMat == ellMat.'))) == 0)
                    throwerror('wrongMatrix','Input should be a symmetric matrix or a vector.');
                elseif ellMat==(ellMat.*eye(mSize)) %check if the matrix is diagonal
                    ellObj.diagMat=ellMat;
                    ellObj.eigvMat=eye(mSize);
                else %ordinary square matrix
                    [ellObj.eigvMat ellObj.diagMat]=eig(ellMat);
                end
                if nCenSize~=1
                    throwerror('wrongCenter','Center must be a vector');
                end
                if mSize~=mCenSize
                    throwerror('wrongDimensions','Dimension of center vector must be the same as matrix');
                end
                ellObj.centerVec=ellCenterVec;
                
            elseif nInput == 3
                ellCenterVec=varargin{1};
                ellDiagMat=varargin{2};
                ellWMat=varargin{3};
                [mCenSize nCenSize]=size(ellCenterVec);
                [mDSize nDSize]=size(ellDiagMat);
                [mWSize nWSize]=size(ellWMat);
                %
                if (nCenSize~=1)
                    throwerror('wrongCenter','Center must be a vector');
                end
                if (mCenSize ~=mDSize || mCenSize~=mWSize)
                    throwerror('wrongDimensions','Input matrices and center vector must be of the same dimension');
                end
                if (nDSize>1) 
                    if nDSize~=mDSize  
                        throwerror('wrongDiagonal','Second argument should be either diagonal matrix or a vector');
                    end
                    isDiagonal=ellDiagMat==(ellDiagMat.*eye(mDSize));
                    if ~isDiagonal
                        throwerror('wrongDiagonal','Second argument should be either diagonal matrix or a vector');
                    end            
                end
                if (nWSize~=mWSize)
                    throwerror('wrongParameters','Third parameter should be a square matrix');
                end
                if (nDSize==1)
                    diagVec=ellDiagMat;
                else
                    diagVec=diag(ellDiagMat);
                end
                isInfVec=diagVec==Inf;
                diagSumMat=diag(diagVec(~isInfVec));
                ellWSumMat=ellWMat(~isInfVec,~isInfVec);
                [nonInfVMat nonInfDMat]=eig(ellWSumMat*diagSumMat*ellWSumMat.');
                ellObj.diagMat=zeros(mDSize);
                ellObj.eigvMat=zeros(mDSize);
                ellObj.diagMat(~isInfVec,~isInfVec)=nonInfDMat;
                ellObj.eigvMat(~isInfVec,~isInfVec)=nonInfVMat;
                ellObj.diagMat(isInfVec,isInfVec)=diag(diagVec(isInfVec));
                ellObj.eigvMat(isInfVec,isInfVec)=eye(length(diagVec(isInfVec)));
                ellObj.centerVec=ellCenterVec;
            end
            minEigVal=min(diag(ellObj.diagMat));     
            if (minEigVal<0 && abs(minEigVal)> ellOptions.abs_tol)
                throwerror('wrongMatrix','Ellipsoid matrix should be positive semi-definite.')
            end
        end
        ellObj = inv (ellObj)
        ellObjVec = minksumNew_ea(ellObjVec, dirVec)
    end
end

