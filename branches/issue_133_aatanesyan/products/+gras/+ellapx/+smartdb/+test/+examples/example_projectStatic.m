% Example of PROJECTSTATIC function usage for creating a projection of
% ellipsoid tube union object.
unionEllTube = ...
    gras.ellapx.smartdb.test.examples.getUnion();
projMatList = {[1 0;0 1]};
statEllTubeProj = unionEllTube.projectStatic(projMatList);