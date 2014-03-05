% An example of ISEQUAL method usage. The compared ellTubeProjections are 
% equal.
firstProj = gras.ellapx.smartdb.test.examples.getProj();
secondProj = gras.ellapx.smartdb.test.examples.getProj();
res = firstProj.isEqual(secondProj);