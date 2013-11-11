% An example of usage of INTERP function from EllTubeBasic class. In this
% example an ellipsoid tube object is created, using oldTimeVec time
% vector. Then it is interpolated on newTimeVec time vector.
nPoints=5;
calcPrecision=0.001;
approxSchemaDescr=char.empty(1,0);
approxSchemaName=char.empty(1,0);
nDims=3;
nTubes=1;
lsGoodDirVec=[1;0;1];
aMat=zeros(nDims,nPoints);
oldTimeVec=1:nPoints;
sTime=nPoints;
approxType=gras.ellapx.enums.EApproxType.Internal;
qArrayList=repmat({repmat(diag([1 2 3]),[1,1,nPoints])},...
    1,nTubes);
ltGoodDirArray=repmat(lsGoodDirVec,[1,nTubes,nPoints]);
fromMatEllTube=gras.ellapx.smartdb.rels.EllTube.fromQArrays(...
    qArrayList, aMat, oldTimeVec,...
    ltGoodDirArray, sTime, approxType, approxSchemaName,...
    approxSchemaDescr, calcPrecision);
newTimeVec = 1:0.5:nPoints;
interpEllTube = fromMatEllTube.interp(newTimeVec);