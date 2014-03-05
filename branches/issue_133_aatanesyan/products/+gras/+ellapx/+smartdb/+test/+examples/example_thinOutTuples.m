% An example of usage of THINOUTTUPLES function from EllTubeBasic class. In
% this example an ellipsoid tube object is created, using TimeVec time
% vector. Then it is thinned out using indVec vector of random indices of 
% elements from timeVec.
nTubes=1;
nPoints = 20;
timeBeg=0;
timeEnd=1;
type = 1;
EllTube=...
    gras.ellapx.smartdb.test.examples.getEllTube(nTubes,timeBeg,timeEnd,type,nPoints);
newnPoints=50;
newTimeVec = (1/nPoints):(1/newnPoints):1;
interpEllTube = EllTube.interp(newTimeVec);
indVec = randi(nPoints,1,5);
thinOutEllTube = EllTube.thinOutTuples(indVec);