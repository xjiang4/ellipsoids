classdef IEllUnionTubeStaticProj < ...
        gras.ellapx.smartdb.rels.IEllTubeProj & ...
        gras.ellapx.smartdb.rels.IEllUnionTube & ...
        gras.ellapx.smartdb.rels.IEllUnionTubeNotTightStaticProj
    %
    methods (Abstract,Access=protected)
        plotTouchArea(~)
    end
end