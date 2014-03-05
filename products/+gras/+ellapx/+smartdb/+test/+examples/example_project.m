% An example of calculating ellipsoid tube union projection using PROJECT
% method. For unions the type of projection can only be Static.
unionEllTube = ...
    gras.ellapx.smartdb.test.examples.getUnion();
projType = gras.ellapx.enums.EProjType.Static;
projMat = [1 0; 0 1]';
p = @gras.ellapx.smartdb.test.examples.fGetProjMat;
[ellTubeProjRel,indProj2OrigVec] = unionEllTube.project(projType,...
    {projMat},p);