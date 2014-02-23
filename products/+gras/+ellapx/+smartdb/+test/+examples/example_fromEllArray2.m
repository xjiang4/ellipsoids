% An example of creating nTubes ellipsoid tube objects using fromEllArray
% function.
nPoints=10;
absTol=0.01;
relTol=0.01;
approxSchemaDescr=['Internal', 'External', 'Internal']';
approxSchemaName=['Internal', 'External', 'Internal']';
nDims=3;
nTubes=3;
lsGoodDirVec=[1;0;1];
timeVec=(1/nPoints):(1/nPoints):1;
sTime=timeVec(randi(nPoints,1));
approxType=[gras.ellapx.enums.EApproxType.Internal,...
    gras.ellapx.enums.EApproxType.External,...
    gras.ellapx.enums.EApproxType.Internal]';
ellArray(nPoints) = ellipsoid();
aMat=zeros(nDims,nPoints);
qArrayList=repmat({repmat(diag([1 2 3]),[1,1,nPoints])},1,1);
for iElem = 1:nPoints
    ellArray(iElem) = ellipsoid(aMat(:,iElem), qArrayList{1}(:,:,iElem));
end;
ellnArray = repmat(ellArray,nTubes,1)'
fromEllArrayEllTube = gras.ellapx.smartdb.rels.EllTube.fromEllArray(...
    ellnArray,timeVec, ltGoodDirArray, sTime, approxType,...
    approxSchemaName,approxSchemaDescr, absTol, relTol);