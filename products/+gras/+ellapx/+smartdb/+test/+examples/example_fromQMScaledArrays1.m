% An example of creating nTubes ellipsoid tube objects using fromQMScaledArrays
% function with the same type of approximation.
nPoints=10;
absTol=0.01;
relTol=0.01;
approxSchemaDescr='Internal';
approxSchemaName='Internal';
nDims=3;
nTubes=5;
lsGoodDirVec=[1;0;1];
aMat=zeros(nDims,nPoints);
timeVec=(1/nPoints):(1/nPoints):1;
sTime=timeVec(randi(nPoints,1));
approxType=gras.ellapx.enums.EApproxType.Internal;
qArrayList=repmat({repmat(diag([1 2 3]),[1,1,nPoints])},...
    1,nTubes);
mArrayList=repmat({repmat(diag([0.1 0.2 0.3]),[1,1,nPoints])},...
    1,nTubes);
ltGoodDirArray=repmat(lsGoodDirVec,[1,nTubes,nPoints]);
scaleFactor = ones(1,nTubes);
fromQMScaledArraysEllTube = ...
    gras.ellapx.smartdb.rels.EllTube.fromQMScaledArrays(...
    qArrayList,aMat,mArrayList,timeVec,...
    ltGoodDirArray,sTime,approxType,approxSchemaName,...
    approxSchemaDescr,absTol, relTol,...
    scaleFactor);