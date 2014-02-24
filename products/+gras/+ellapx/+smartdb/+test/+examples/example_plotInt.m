% An example of plotting the projection of the ellipsoid tube internal approximation
% object using plotInt method.
nPoints=5;
absTol=0.01;
relTol=0.01;
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
    approxSchemaDescr, absTol, relTol);
projType = gras.ellapx.enums.EProjType.Static;
projMat = [1 0; 0 1; 0 0]';
p = @gras.ellapx.smartdb.test.examples.fGetProjMat;
[ellTubeProjRel,indProj2OrigVec] = fromMatEllTube.project(projType,...
    {projMat},p);
ellTubeProjRel.plotInt();