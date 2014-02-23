% An example of creating nTubes ellipsoid tube objects using fromEllArray
% function.
nPoints=10;
absTol=0.01;
relTol=0.01;
approxSchemaDescr='Internal';
approxSchemaName='Internal';
nDims=3;
nTubes=5;
lsGoodDirVec=[1;0;1];
timeVec=(1/nPoints):(1/nPoints):1;
sTime=timeVec(randi(nPoints,1));
approxType=gras.ellapx.enums.EApproxType.Internal;
ellArray(nPoints) = ellipsoid();
aMat=zeros(nDims,nPoints);
qArrayList=repmat({repmat(diag([1 2 3]),[1,1,nPoints])},1,nTubes);
for iElem = 1:nPoints
    ellArray(iElem) = ellipsoid(aMat(:,iElem), qArrayList{1}(:,:,iElem));
end;
ellArray
fromEllArrayEllTube = gras.ellapx.smartdb.rels.EllTube.fromEllArray(...
    ellArray,timeVec, ltGoodDirArray, sTime, approxType,...
    approxSchemaName,approxSchemaDescr, absTol, relTol)