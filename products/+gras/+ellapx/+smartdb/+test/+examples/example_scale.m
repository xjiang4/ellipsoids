% An example of using scale function to calculate and set new
% scaleFactor for fields in ellipsoid tube object.
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
fromMatEllTube.scale(@(varargin)2,{});