% An example of creating nTubes ellipsoid tube objects using 
% fromQMScaledArrays function.
nPoints=5;
calcPrecision=0.001;
approxSchemaDescr=char.empty(1,0);
approxSchemaName=char.empty(1,0);
nDims=3;
nTubes=1;
lsGoodDirVec=[1;0;1];
aMat=zeros(nDims,nPoints);
timeVec=1:nPoints;
sTime=nPoints;
approxType=gras.ellapx.enums.EApproxType.Internal;
mArrayList=repmat({repmat(diag([0.1 0.2 0.3]),[1,1,nPoints])},...
    1,nTubes);
qArrayList=repmat({repmat(diag([1 2 3]),[1,1,nPoints])},...
    1,nTubes);
ltGoodDirArray=repmat(lsGoodDirVec,[1,nTubes,nPoints]);
scaleFactor = ones(1,nTubes);
fromQMScaledArraysEllTube = ...
    gras.ellapx.smartdb.rels.EllTube.fromQMScaledArrays(...
    qArrayList,aMat,mArrayList,timeVec,...
    ltGoodDirArray,sTime,approxType,approxSchemaName,...
    approxSchemaDescr,calcPrecision,...
    scaleFactor);