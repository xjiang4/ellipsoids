firstCentVec = zeros(3, 1);
firstWorkMat = eye(3);
secondCentVec = [1, .5, -.5]';
secondWorkMat = [2, 0, 0; 0, 1, 0;...
    0, 0, .5];
thirdCentVec = [.5, .3, 1]';
thirdWorkMat = [.5, 0, 0; 0, .5, 0;
    0, 0, 2];

centVecCVec = {firstCentVec, secondCentVec,...
    thirdCentVec};
workMatCVec = {firstWorkMat, secondWorkMat,...
    thirdWorkMat};

minDim = 3;
nElem = numel(centVecCVec);


cvx_begin sdp
cvx_solver sdpt3
variable cvxWorkMat(minDim, minDim) symmetric
variable cvxCentVec(minDim)
variable cvxDirVec(nElem)

maximize( det_rootn( cvxWorkMat ) )
subject to
-cvxDirVec <= 0;

 for iElem = 1 : nElem
     
     curCentVec = centVecCVec{iElem};
     curWorkMat = workMatCVec{iElem};
     
     invWorkMat = inv(curWorkMat);
     bVec = -invWorkMat * curCentVec;
     constraint = curCentVec' * invWorkMat * curCentVec - 1;
     [ (-cvxDirVec(iElem) - constraint + bVec' * curWorkMat * bVec),...
         zeros(minDim,1)', (cvxCentVec + curWorkMat*bVec)' ;
        zeros(minDim,1), ...
        cvxDirVec(iElem)*eye(minDim), cvxWorkMat;
        (cvxCentVec + curWorkMat*bVec), ...
        cvxWorkMat, curWorkMat] >= 0;
 end
 
cvx_end
