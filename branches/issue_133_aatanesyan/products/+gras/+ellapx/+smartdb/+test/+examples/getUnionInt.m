function unionEllTube = getUnionInt()
nTubes=10;
nPoints = 20;
timeBeg=1;
timeEnd=2;
type = 1;
ellTube = ...
    gras.ellapx.smartdb.test.examples.getEllTube(nTubes,...
    timeBeg,timeEnd,type,nPoints);
unionEllTube = ...
    gras.ellapx.smartdb.rels.EllUnionTube.fromEllTubes(ellTube);
end