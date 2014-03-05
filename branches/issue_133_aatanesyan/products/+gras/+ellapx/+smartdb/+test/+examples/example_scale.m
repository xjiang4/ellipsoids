% An example of using scale function to calculate and set new
% scaleFactor for fields in ellipsoid tube object.
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
EllTube.scale(@(varargin)2,{});