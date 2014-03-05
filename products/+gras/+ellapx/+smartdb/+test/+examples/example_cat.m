% An example of concatenating ellipsoid tube objects containing random 
% number of ellipsoid tubes (from one to ten tubes).
%
nTubes = randi(10,1);
nPoints = 20;
type = 1;
timeBeg1 = 0;
timeEnd1 = 1;
firstEllTube =...
    gras.ellapx.smartdb.test.examples.getEllTube(nTubes,timeBeg1,timeEnd1,type,nPoints);
timeBeg2 = 1;
timeEnd2 = 2;
secondEllTube =...
    gras.ellapx.smartdb.test.examples.getEllTube(nTubes,timeBeg2,timeEnd2,type,nPoints);
%
% Concatenating firstEllTube and secondEllTube on [timeBeg1, timeEnd2]
% vector of time.
%
resEllTube = firstEllTube.cat(secondEllTube);
%
% Concatenating the same firstEllTube and secondEllTube on [timeBeg1,timeEnd2]
% vector of time, but the sTime and values of properties corresponding to 
% sTime are taken from secondEllTube.
%
resEllTube = firstEllTube.cat(secondEllTube,'isReplacedByNew',true);
%
% Concatenating the same firstEllTube and secondEllTube on [timeBeg1,timeEnd2]
% vector of time, but the sTime and values of properties corresponding to 
% sTime are taken from firstEllTube.
%
resEllTube = firstEllTube.cat(secondEllTube,'isReplacedByNew',false);
%
% Note that we cannot concatenate ellipsoid tubes with  overlapping time
% limits.
%


