classdef EllUnionTube < ...
        gras.ellapx.smartdb.rels.AEllTube & ...
        gras.ellapx.smartdb.rels.AEllUnionTube & ...
        gras.ellapx.smartdb.rels.TypifiedByFieldCodeRel
    %
    methods(Access=protected)
        function changeDataPostHook(self)
            self.checkDataConsistency();
        end
        %
        function checkDataConsistency(self)
            checkDataConsistency@gras.ellapx.smartdb.rels.AEllTube(self);
            checkDataConsistency@gras.ellapx.smartdb.rels.AEllUnionTube(self);
        end
    end
    %
    methods
        function self=EllUnionTube(varargin)
            self=self@gras.ellapx.smartdb.rels.TypifiedByFieldCodeRel(...
                varargin{:});
        end
        %
        function [ellTubeProjRel,indProj2OrigVec]=project(self,projType,...
                varargin)
            import gras.ellapx.smartdb.rels.EllUnionTubeStaticProj;
            import gras.ellapx.enums.EProjType;
            import modgen.common.throwerror;
            %
            if self.getNTuples()>0
                if projType~=EProjType.Static
                    throwerror('wrongInput',...
                        'only projections on Static subspace are supported');
                end
                
                [SProjData,indProj2OrigVec]=self.projectInternal(...
                    projType,varargin{:});
                projRel=smartdb.relations.DynamicRelation(SProjData);
                projRel.catWith(self.getTuples(indProj2OrigVec),...
                    'duplicateFields','useOriginal');
                ellTubeProjRel=EllUnionTubeStaticProj(projRel);
            else
                ellTubeProjRel=EllUnionTubeStaticProj();
            end
        end
    end
    %
    methods (Static)
        function ellUnionTubeRel=fromEllTubes(ellTubeRel)
            import gras.ellapx.smartdb.rels.EllUnionTube
            import gras.ellapx.smartdb.rels.AEllUnionTube
            %
            SData = AEllUnionTube.fromEllTubesInternal(ellTubeRel);
            ellUnionTubeRel = EllUnionTube(SData);
        end
    end
end