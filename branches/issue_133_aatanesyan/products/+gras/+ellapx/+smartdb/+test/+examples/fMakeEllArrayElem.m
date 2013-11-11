function fMakeEllArrayElem(iElem)
    nPoints=5;
    nTubes=1;
    nDims=3;
    aMat=zeros(nDims,nPoints);
    qArrayList=repmat({repmat(diag([1 2 3]),[1,1,nPoints])},1,nTubes);
    ellArray(iElem) = ellipsoid(aMat(:,iElem), qArrayList{1}(:,:,iElem));
end