% Examples of calculating ellipsoid tube object projection to basic orths 
% using PROJECTTOORTHS function. This is an example of projectToOrths usage 
% with specified projection type.
nPoints=10;
absTol=0.01;
relTol=0.01;
approxSchemaDescr='Internal';
approxSchemaName='Internal';
nDims=3;
nTubes=1;
lsGoodDirVec=[1;0;1];
aMat=zeros(nDims,nPoints);
timeVec=(1/nPoints):(1/nPoints):1;
sTime=timeVec(randi(nPoints,1));
approxType=gras.ellapx.enums.EApproxType.Internal;
qArrayList=repmat({repmat(diag([1 2 3]),[1,1,nPoints])},...
    1,nTubes);
ltGoodDirArray=repmat(lsGoodDirVec,[1,nTubes,nPoints]);
fromMatEllTube=gras.ellapx.smartdb.rels.EllTube.fromQArrays(...
    qArrayList, aMat, timeVec,...
    ltGoodDirArray, sTime, approxType, approxSchemaName,...
    approxSchemaDescr, absTol, relTol);
projType = gras.ellapx.enums.EProjType.DynamicAlongGoodCurve;
ellTubeProjRel = fromMatEllTube.projectToOrths([1,2], projType);
plObj=smartdb.disp.RelationDataPlotter();
ellTubeProjRel.plot(plObj);