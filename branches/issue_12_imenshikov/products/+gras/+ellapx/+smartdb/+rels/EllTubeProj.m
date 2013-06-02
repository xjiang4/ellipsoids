classdef EllTubeProj < ...
        gras.ellapx.smartdb.rels.AEllTube & ...
        gras.ellapx.smartdb.rels.AEllTubeProj & ...
        gras.ellapx.smartdb.rels.TypifiedByFieldCodeRel
    %
    methods(Access=protected)
        function changeDataPostHook(self)
            self.checkDataConsistency();
        end
        %
        function checkDataConsistency(self)
            checkDataConsistency@gras.ellapx.smartdb.rels.AEllTube(self);
            checkDataConsistency@gras.ellapx.smartdb.rels.AEllTubeProj(self);
        end
        %
        function dependencyFieldList=getTouchCurveDependencyFieldList(varargin)
            dependencyFieldList=getTouchCurveDependencyFieldList@...
                gras.ellapx.smartdb.rels.AEllTubeProj(varargin{:});
        end
        %
        function figureGroupKeyName=figureGetGroupKeyFunc(varargin)
            figureGroupKeyName=figureGetGroupKeyFunc@...
                gras.ellapx.smartdb.rels.AEllTubeProj(varargin{:});
        end
        %
        function figureSetPropFunc(varargin)
            figureSetPropFunc@...
                gras.ellapx.smartdb.rels.AEllTubeProj(varargin{:});
        end
        %
        function hVec=axesSetPropBasicFunc(varargin)
            hVec=axesSetPropBasicFunc@...
                gras.ellapx.smartdb.rels.AEllTubeProj(varargin{:});
        end
        %
        function checkTouchCurves(varargin)
            checkTouchCurves@...
                gras.ellapx.smartdb.rels.AEllTubeProj(varargin{:});
        end
    end
    %
    methods
        function plObj=plot(varargin)
            plObj=plot@...
                gras.ellapx.smartdb.rels.AEllTubeProj(varargin{:});
        end
        %
        function self=EllTubeProj(varargin)
            self=self@gras.ellapx.smartdb.rels.TypifiedByFieldCodeRel(varargin{:});
        end
    end
end