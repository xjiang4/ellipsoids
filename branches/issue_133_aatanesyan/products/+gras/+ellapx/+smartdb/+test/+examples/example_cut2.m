% An example of usage of CUT function from EllTubeBasic class. In
% this example an ellipsoid tube object is created, using TimeVec time
% vector. Then it is cut using cutTimePoint point
% of time.
nTubes=1;
nPoints = 20;
timeBeg=0;
timeEnd=1;
type = 1;
EllTube=...
    gras.ellapx.smartdb.test.examples.getEllTube(nTubes,timeBeg,timeEnd,type,nPoints);
timeVec = EllTube.timeVec{1,:};
cutTimePoint = timeVec(randi(size(timeVec,2),1));
cutPointEllTube = EllTube.cut(cutTimePoint);