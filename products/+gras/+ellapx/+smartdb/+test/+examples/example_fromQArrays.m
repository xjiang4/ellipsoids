% An example of creating nTubes ellipsoid tube objects using fromQArrays
% function.
nPoints=5;
calcPrecision=0.001;
approxSchemaDescr=char.empty(1,0);
% approxSchemaDescr={'.','..','...'}'
% approxSchemaName=char.empty(1,0);
approxSchemaName={'.','..','...'}'
nDims=3;
nTubes=3;
lsGoodDirVec=[1;0;1];
aMat=zeros(nDims,nPoints);
timeVec=1:nPoints;
sTime=nPoints;
% approxType=gras.ellapx.enums.EApproxType.Internal;
approxType=[gras.ellapx.enums.EApproxType.Internal,...
    gras.ellapx.enums.EApproxType.Internal,...
    gras.ellapx.enums.EApproxType.Internal]'
qArrayList=repmat({repmat(diag([1 2 3]),[1,1,nPoints])},...
    1,nTubes);
ltGoodDirArray=repmat(lsGoodDirVec,[1,nTubes,nPoints]);
fromMatEllTube=gras.ellapx.smartdb.rels.EllTube.fromQArrays(...
    qArrayList, aMat, timeVec,...
    ltGoodDirArray, sTime, approxType, approxSchemaName,...
    approxSchemaDescr, calcPrecision)