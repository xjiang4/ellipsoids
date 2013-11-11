% An example of creating nTubes ellipsoid tube objects using fromEllArray
% function.
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
ellArray(nPoints) = ellipsoid();
arrayfun(@(iElem)gras.ellapx.smartdb.test.examples.fMakeEllArrayElem(iElem),...
    1:nPoints);
fromEllArrayEllTube = gras.ellapx.smartdb.rels.EllTube.fromEllArray(...
    ellArray,timeVec, ltGoodDirArray, sTime, approxType,...
    approxSchemaName,approxSchemaDescr, calcPrecision);