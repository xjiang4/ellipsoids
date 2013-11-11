% Examples of calculating ellipsoid tube object projection to basic orths 
% using PROJECTTOORTHS function.
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
qArrayList=repmat({repmat(diag([1 2 3]),[1,1,nPoints])},...
    1,nTubes);
ltGoodDirArray=repmat(lsGoodDirVec,[1,nTubes,nPoints]);
fromMatEllTube=gras.ellapx.smartdb.rels.EllTube.fromQArrays(...
    qArrayList, aMat, timeVec,...
    ltGoodDirArray, sTime, approxType, approxSchemaName,...
    approxSchemaDescr, calcPrecision);
% Example of projectToOrths usage with one input variable. The defaul value
% of projection type is used.
ellTubeProjRel = fromMatEllTube.projectToOrths([1,2]);
% Example of projectToOrths usage with specified projection type.
projType = gras.ellapx.enums.EProjType.DynamicAlongGoodCurve;
ellTubeProjRel = fromMatEllTube.projectToOrths([1,2], projType);
plObj=smartdb.disp.RelationDataPlotter();
ellTubeProjRel.plot(plObj);