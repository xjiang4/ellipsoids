% An example of creating nTubes ellipsoid tube objects using fromQMArrays
% function.
nPoints=5;
calcPrecision=0.001;
approxSchemaDescr=char.empty(1,0);
approxSchemaName=char.empty(1,0);
nDims=3;
nTubes=4;
lsGoodDirVec=[0;0;1];
aMat=ones(nDims,nPoints);
timeVec=1:nPoints;
sTime=1;
approxType=gras.ellapx.enums.EApproxType.External;
mArrayList=repmat({repmat(diag([0.1 0.2 0.3]),[1,1,nPoints])},...
    1,nTubes);
qArrayList=repmat({repmat(diag([1 2 3]),[1,1,nPoints])},...
    1,nTubes);
ltGoodDirArray=repmat(lsGoodDirVec,[1,nTubes,nPoints]);
fromMatMEllTube=gras.ellapx.smartdb.rels.EllTube.fromQMArrays(...
    qArrayList, aMat, mArrayList, timeVec,...
    ltGoodDirArray, sTime, approxType, approxSchemaName,...
    approxSchemaDescr, calcPrecision);