classdef AEllTubeProjectable<handle
    methods (Abstract)
        [ellTubeProjRel,indProj2OrigVec]=project(self,varargin)
        % PROJECT - computes projection of the relation object onto given time
        % dependent subspase
        % Input:
        %   regular:
        %       self.
        %       projType: gras.ellapx.enums.EProjType[1,1] - type of the projection, 
        %           can be 'Static' and 'DynamicAlongGoodCurve'
        %       projMatList: cell[1,nProjs] of double[nSpDims,nDims] - list of not 
        %           necessarily orthogonal projection matrices, 
        %       fGetProjMat: function_handle[1,1] - function which creates
        %           vector of the projection matrices
        % Output:
        %   ellTubeProjRel: gras.ellapx.smartdb.rels.EllTubeProj[1, 1]/
        %       gras.ellapx.smartdb.rels.EllTubeUnionProj[1, 1] -
        %       projected ellipsoidal tube
        %    indProj2OrigVec:cell[nDims, 1] - index of the line number from
        %             which is obtained the projection
        %
        % Example:
        %   function example
        %       aMat = [0 1; 0 0]; bMat = eye(2);
        %       SUBounds = struct();
        %       SUBounds.center = {'sin(t)'; 'cos(t)'};
        %       SUBounds.shape = [9 0; 0 2];
        %       sys = elltool.linsys.LinSysContinuous(aMat, bMat, SUBounds);
        %       x0EllObj = ell_unitball(2);
        %       timeVec = [0 10];
        %       dirsMat = [1 0; 0 1]';
        %       rsObj = elltool.reach.ReachContinuous(sys, x0EllObj, dirsMat, timeVec);
        %       ellTubeObj = rsObj.getEllTubeRel();
        %       unionEllTube = ...
        %           gras.ellapx.smartdb.rels.EllUnionTube.fromEllTubes(ellTubeObj);
        %       projMatList = {[1 0;0 1]};
        %       projType = gras.ellapx.enums.EProjType.Static;
        %       statEllTubeProj = unionEllTube.project(projType,projMatList,...
        %          @fGetProjMat);
        %       plObj=smartdb.disp.RelationDataPlotter();
        %      statEllTubeProj.plot(plObj);
        %   end
        %
        %   function [projOrthMatArray,projOrthMatTransArray]=fGetProjMat(projMat,...
        %       timeVec,varargin)
        %       nTimePoints=length(timeVec);
        %       projOrthMatArray=repmat(projMat,[1,1,nTimePoints]);
        %       projOrthMatTransArray=repmat(projMat.',[1,1,nTimePoints]);
        %   end
    end
    methods
        function [ellTubeProjRel,indProj2OrigVec]=projectStatic(self,...
                projMatList)
        % PROJECTSTATIC - computes a static projection of the relation
        % object onto static subspaces specified by static matrices
        %
        % Input:
        %   regular:
        %       self.
        %       projMatList: double[nSpDims,nDims]/cell[1,nProjs] 
        %           of double[nSpDims,nDims] - list of not necessarily orthogonal 
        %           projection matrices
        %
        % Output:
        %   ellTubeProjRel: smartdb.relation.StaticRelation[1, 1]/
        %       smartdb.relation.DynamicRelation[1, 1]- projected relation
        %   indProj2OrigVec:cell[nDims, 1] - index of the line number from
        %       which is obtained the projection
        %
        % Example:
        %   function example
        %       aMat = [0 1; 0 0]; 
        %       bMat = eye(2);
        %       SUBounds = struct();
        %       SUBounds.center = {'sin(t)'; 'cos(t)'};
        %       SUBounds.shape = [9 0; 0 2];
        %       sys = elltool.linsys.LinSysContinuous(aMat, bMat, SUBounds);
        %       x0EllObj = ell_unitball(2);
        %       timeVec = [0 10];
        %       dirsMat = [1 0; 0 1]';
        %       rsObj = elltool.reach.ReachContinuous(sys, x0EllObj, dirsMat, timeVec);
        %       ellTubeObj = rsObj.getEllTubeRel();
        %       unionEllTube = ...
        %           gras.ellapx.smartdb.rels.EllUnionTube.fromEllTubes(ellTubeObj);
        %       projMatList = {[1 0;0 1]};
        %       statEllTubeProj = unionEllTube.projectStatic(projMatList);
        %       plObj=smartdb.disp.RelationDataPlotter();
        %       statEllTubeProj.plot(plObj);
        %   end
        %
            if ~iscell(projMatList)
                projMatList={projMatList};
            end
            projectorObj=gras.ellapx.proj.EllTubeStaticSpaceProjector(...
                projMatList);
            %
            [ellTubeProjRel,indProj2OrigVec]=projectorObj.project(...
                self);
        end
    end
end

