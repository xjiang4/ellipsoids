% An example of ISEQUAL method usage. The compared ellTubeUnions are not
% equal because one has external approximation, and the oter has internal
% approximation.
firstUnion = gras.ellapx.smartdb.test.examples.getUnionExt();
secondUnion = gras.ellapx.smartdb.test.examples.getUnionInt();
res = firstUnion.isEqual(secondUnion);