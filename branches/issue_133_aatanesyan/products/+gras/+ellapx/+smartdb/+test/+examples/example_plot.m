% An example of calculating ellipsoid tube object projection using project
% function.
EllProj = gras.ellapx.smartdb.test.examples.getProj();
plObj=smartdb.disp.RelationDataPlotter();
EllProj.plot(plObj);