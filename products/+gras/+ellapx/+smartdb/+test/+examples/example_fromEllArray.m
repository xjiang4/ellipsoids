% An example of creating nTubes ellipsoid tube objects using FROMELLARRAY
% method.
[nTubes, nPoints, nDims, absTol, relTol, timeVec,...
    sTime, lsGoodDirVec, ltGoodDirArray, aMat, qArrayList] = ...
    gras.ellapx.smartdb.test.examples.getDataForOneTube();
[approxSchemaDescr, approxSchemaName, approxType] = ...
    gras.ellapx.smartdb.test.examples.getSameApprox();
ellArray(nPoints) = ellipsoid();
for iElem = 1:nPoints
    ellArray(iElem) = ellipsoid(aMat(:,iElem), qArrayList{1}(:,:,iElem));
end;
fromEllArrayEllTubeObj = gras.ellapx.smartdb.rels.EllTube.fromEllArray(...
    ellArray,timeVec, ltGoodDirArray, sTime, approxType,...
    approxSchemaName,approxSchemaDescr, absTol, relTol);