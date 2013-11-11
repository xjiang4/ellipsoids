nPoints=5;
calcPrecision=0.001;
approxSchemaDescr=char.empty(1,0);
approxSchemaName=char.empty(1,0);
nDims=3;
nTubes=1;
lsGoodDirVec=[1;0;1];
timeVec=1:nPoints;
sTime=nPoints;
approxType=gras.ellapx.enums.EApproxType.Internal;
mArrayList=repmat({repmat(diag([0.1 0.2 0.3]),[1,1,nPoints])},...
    1,nTubes);
ltGoodDirArray=repmat(lsGoodDirVec,[1,nTubes,nPoints]);
ellArray(nPoints) = ellipsoid();
arrayfun(@(iElem)gras.ellapx.smartdb.test.examples.fMakeEllArrayElem(iElem),...
    1:nPoints);
fromEllMArrayEllTube=...
    gras.ellapx.smartdb.rels.EllTube.fromEllMArray(...
    ellArray, mArrayList{1}, timeVec,...
    ltGoodDirArray, sTime, approxType, approxSchemaName,...
    approxSchemaDescr, calcPrecision);