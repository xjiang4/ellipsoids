% An example of usage of THINOUTTUPLES function from EllTubeBasic class. In
% this example an ellipsoid tube object is created, using TimeVec time
% vector. Then it is thinned out using indVec vector of indices of elements
% from timeVec.
nPoints=10;
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
indVec = [1 2 5 6 8 9 10];
thinOutEllTube = fromMatEllTube.thinOutTuples(indVec);