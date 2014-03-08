classdef EllUnionTube<gras.ellapx.smartdb.rels.ATypifiedAdjustedRel&...
        gras.ellapx.smartdb.rels.EllTubeBasic&...        
        gras.ellapx.smartdb.rels.EllUnionTubeBasic&...
        gras.ellapx.smartdb.rels.AEllTubeProjectable
    % A class which allows to work with unions of ellipsoid tube objects.
    % 
    % Fields:
    %   QArray: cell[1,1] of double[nDims,nDims,nTimePoints] -
    %       a 3-dimentional matrix in which each of nTimePoints slices is a 
    %       double[nDims,nDims] ellipsoid matrix at nTimePoint point of time. 
    %       Here nTimePoints is number of elements in timeVec.
    %   aMat: cell[1,nTimePoints] of double[nDims,1] - a 2-dimentional matrix 
    %       in which each of nTimePoints columns is a 
    %       double[nDims, 1] ellipsoid center. Each center is specified for 
    %       nTimePoint point of time
    %   scaleFactor: double[1, 1] - scale for the created ellipsoid tube
    %   MArray: cell[1,1] of double[nDims,nDims,nTimePoints] -
    %       a 3-dimentional matrix in which each of nTimePoints slices is 
    %       a double[nDims,nDims] regularization matrix at nTimePoint point 
    %       of time.
    %   dim: double[1, 1] - the dimension of the space in which the touching 
    %       curves are defined
    %   sTime: double[1, 1] - specific point of time which is best suited to
    %       describe good direction
    %   approxSchemaName: cell[1, 1] of char[1,] - name of the 
    %       approximation schema
    %   approxSchemaDescr: cell[1, 1] of char[1,] - description of the 
    %       approximation schema
    %   approxType: gras.ellapx.enums.EApproxType[1,1] - type of approximation 
    %       (External, Internal, NotDefined)
    %   timeVec: double[1, nTimePoints] - time vector 
    %   calcPrecision: double[1, 1] - calculation precision
    %   indSTime: double[1, 1]  - index of sTime point within timeVec
    %   ltGoodDirMat: cell[1, nTimePoints] of double[nDims, 1] - matrix of 
    %       good direction vectors at any point of time from timeVec
    %   lsGoodDirVec: cell[1, 1] of double[nDims, 1] - good direction vector 
    %       at sTime point of time
    %   ltGoodDirNormVec: cell[1, 1] of double[1, nTimePoints] - norm of good 
    %       direction vector at any point of time from timeVec
    %   lsGoodDirNorm: double[1, 1] - norm of good direction vector at
    %       sTime point of time
    %   xTouchCurveMat: cell[1, nTimePoints] of double[nDims, 1] - touch 
    %       point curve for good direction matrix
    %   xTouchOpCurveMat: cell[1, nTimePoints] of double[nDims, 1] - touch 
    %       point curve oposite to the xTouchCurveMat touch point curve
    %   xsTouchVec: cell[1, 1] of double[nDims, 1]  - touch point at sTime
    %       point of time
    %   xsTouchOpVec: cell[1, 1] of double[nDims, 1] - a point opposite to
    %       the xsTouchVec touch point
    %   isLsTouch: logical[1, 1] - a logical variable which indicates whether
    %       a touch takes place along good direction at sTime point of time
    %   isLtTouchVec: cell[1, 1] of logical[nTimePoints, 1] - a logical
    %       vector which indicates whether a touch takes place along good 
    %       direction at any point of time from timeVec
    %   ellUnionTimeDirection: gras.ellapx.enums.EEllUnionTimeDirection[1, 1] - 
    %       direction in time along which union is performed
    %   timeTouchEndVec: cell [1, 1] of double[1, nTimePoints] - points of
    %       time when touch is occured in good direction
    %   timeTouchOpEndVec: cell [1, 1] of double[1, nTimePoints] - points of
    %       time when touch is occured in direction opposite to good direction
    %   isLsTouchOp: logical[1, 1] - a logical variable which indicates whether 
    %       a touch takes place along the direction opposite to the good direction
    %       at sTime point of time
    %   isLtTouchOpVec: cell [1, 1] of logical[nTimePoints, 1] - a logical 
    %       variable which indicates whether a touch takes place
    %       along the direction opposite to the good direction at any point
    %       of time from timeVec
    %
    methods 
        function fieldsList = getNoCatOrCutFieldsList(self)
            % GETNOCATORCUTFIELDLIST - returns a list of fields of
            % EllUionTube object, which are not to be
            % concatenated or cut.
            %
            % Input:
            %   regular:
            %       self.
            % Output:
            %   fieldsList: cell[nFields, 1] of char[1, ] - list of fields 
            %       of EllUionTube object, which are not to be
            %       concatenated or cut
            %
            import  gras.ellapx.smartdb.F;
            fieldsList = [getNoCatOrCutFieldsList@gras.ellapx.smartdb.rels.EllTubeBasic(self);
                getNoCatOrCutFieldsList@gras.ellapx.smartdb.rels.EllUnionTubeBasic(self)];
        end        
    end
    methods (Access = protected)
        function fieldsList = getSFieldsList(self)
            import  gras.ellapx.smartdb.F;
            fieldsList = [getSFieldsList@gras.ellapx.smartdb.rels.EllTubeBasic(self);
                getSFieldsList@gras.ellapx.smartdb.rels.EllUnionTubeBasic(self)];
        end
        function fieldsList = getTFieldsList(self)
            import  gras.ellapx.smartdb.F;
            fieldsList = [getTFieldsList@gras.ellapx.smartdb.rels.EllTubeBasic(self);
                getTFieldsList@gras.ellapx.smartdb.rels.EllUnionTubeBasic(self)];
        end
        function fieldsList = getScalarFieldsList(self)
            import  gras.ellapx.smartdb.F;
            fieldsList = [getScalarFieldsList@gras.ellapx.smartdb.rels.EllTubeBasic(self);
                getScalarFieldsList@gras.ellapx.smartdb.rels.EllUnionTubeBasic(self)];
        end
        function [valFieldNameList,touchFieldNameList]=...
                getPossibleNanFieldList(self)
            [valFieldNameList,touchFieldNameList]=...
                getPossibleNanFieldList@gras.ellapx.smartdb.rels.EllUnionTubeBasic(self);
        end     
        function fieldsList=getTouchCurveDependencyFieldList(self)
            fieldsList = [...
                getTouchCurveDependencyFieldList@gras.ellapx.smartdb.rels.EllTubeBasic(self),...
                getTouchCurveDependencyFieldList@gras.ellapx.smartdb.rels.EllUnionTubeBasic(self)];
        end           
        function checkDataConsistency(self)
            checkDataConsistency@gras.ellapx.smartdb.rels.EllTubeBasic(self);
            checkDataConsistency@gras.ellapx.smartdb.rels.EllUnionTubeBasic(self);
        end
        function changeDataPostHook(self)
            self.checkDataConsistency();
        end
        function SData = getInterpInternal(self, newTimeVec)
            SData = struct;
            import gras.ellapx.smartdb.F;
            if (~isempty(newTimeVec))
                SData = getInterpInternal@...
                    gras.ellapx.smartdb.rels.EllTubeBasic(self,newTimeVec);
                tEllTube = gras.ellapx.smartdb.rels.EllTube(...
                    ).createInstance(SData);
                SData = self.fromEllTubes(tEllTube).getData();
            end
            %
        end
    end
    methods (Static)
        function ellUnionTubeRel=fromEllTubes(ellTubeRel)
            % FROMELLTUBES - returns union of the ellipsoidal tubes on time
            %
            % Input:
            %    ellTubeRel: smartdb.relation.StaticRelation[1, 1]/
            %       smartdb.relation.DynamicRelation[1, 1] - relation
            %       object
            %
            % Output:
            % ellUnionTubeRel: ellapx.smartdb.rel.EllUnionTube - union of the 
            %             ellipsoidal tubes
            %       
            import gras.ellapx.smartdb.rels.EllUnionTube;
            import gras.ellapx.smartdb.rels.EllUnionTubeBasic;
            import gras.ellapx.enums.EEllUnionTimeDirection;
            import gras.ellapx.enums.EApproxType;
            import modgen.common.throwerror;
            %            
            ellUnionTubeRel=EllUnionTube();
            ellUnionTubeRel.setDataFromEllTubesInternal(ellTubeRel);
        end
    end
    methods 
        function [ellTubeProjRel,indProj2OrigVec]=project(self,projType,...
                varargin)
            % PROJECT - projects ellipsoid tube union onto subspace
            %
            % Input:
            %   regular:
            %       self.
            %       projType: gras.ellapx.enums.EProjType[1, 1] - type of
            %           projection. It can only be Static for ellipsoid tube 
            %           unions.
            %       projMatList: double[nDims, nDims] -  subspace defined by 
            %           its basis vectors on which ellipsoid tube has to be 
            %           projected
            %       fGetProjMat: cell_fun[1, ] - function that is used to
            %           get the projection.
            %
            % Output:
            %   ellTubeProjRel: gras.ellapx.smartdb.rels.EllTubeProj[1, 1] -
            %       ellipsoid tube projection
            %   indProj2OrigVec: double[1, ] - vector of indices
            %
            import gras.ellapx.smartdb.rels.EllUnionTubeStaticProj;
            import gras.ellapx.smartdb.rels.EllTubeBasic;
            import gras.ellapx.enums.EProjType;
            import modgen.common.throwerror;
            import gras.ellapx.smartdb.F;
            %
            if self.getNTuples()>0
                if projType~=EProjType.Static
                    throwerror('wrongInput',...
                        'only projections on Static subspace are supported');
                end
                %store original values of IS_LT_TOUCH_VEC and F.IS_LT_TOUCH_OP_VEC
                [projRel,indProj2OrigVec]=...
                    self.projectInternal(projType,varargin{:});
                %
                isLtTouchVecList=self.(F.IS_LT_TOUCH_VEC)(indProj2OrigVec);
                isLtTouchOpVecList=self.(F.IS_LT_TOUCH_OP_VEC)(indProj2OrigVec);
                %
                projRel.catWith(self.getTuples(indProj2OrigVec),...
                    'duplicateFields','useOriginal');  
                [~,indTimeTouchEndVecList]=cellfun(@ismember,...
                    projRel.(F.TIME_TOUCH_END_VEC),projRel.(F.TIME_VEC),...
                    'UniformOutput',false);
                [~,indTimeTouchOpEndVecList]=cellfun(@ismember,...
                    projRel.(F.TIME_TOUCH_OP_END_VEC),projRel.(F.TIME_VEC),...
                    'UniformOutput',false);
                %
                isTouchCandidateCVec=cellfun(@calcTouchCandidateVec,...
                    projRel.(F.LT_GOOD_DIR_NORM_VEC),...
                    indTimeTouchEndVecList,...
                    num2cell(projRel.(F.ABS_TOLERANCE)),'UniformOutput',false);
                %
                isTouchCandidateOpCVec=cellfun(@calcTouchCandidateVec,...
                    projRel.(F.LT_GOOD_DIR_NORM_VEC),...
                    indTimeTouchOpEndVecList,...
                    num2cell(projRel.(F.ABS_TOLERANCE)),'UniformOutput',false);                
                %
                projRel.(F.IS_LT_TOUCH_OP_VEC)=cellfun(@and,...
                    isTouchCandidateOpCVec,...
                    isLtTouchOpVecList,'UniformOutput',false);
                %
                projRel.(F.IS_LT_TOUCH_VEC)=cellfun(@and,...
                    isTouchCandidateCVec,...
                    isLtTouchVecList,'UniformOutput',false);
                %
                projRel.(F.IS_LS_TOUCH)=cellfun(@(x,y)x(y),...
                    projRel.(F.IS_LT_TOUCH_VEC),num2cell(projRel.indSTime));
                %
                projRel.(F.IS_LS_TOUCH_OP)=cellfun(@(x,y)x(y),...
                    projRel.(F.IS_LT_TOUCH_OP_VEC),num2cell(projRel.indSTime));
                %
                projRel.(F.TIME_TOUCH_END_VEC)=cellfun(@assignNans,...
                    projRel.(F.TIME_TOUCH_END_VEC), projRel.(F.IS_LT_TOUCH_VEC),...
                    'UniformOutput',false);
                projRel.(F.TIME_TOUCH_OP_END_VEC)=cellfun(@assignNans,...
                    projRel.(F.TIME_TOUCH_OP_END_VEC),projRel.(F.IS_LT_TOUCH_OP_VEC),...
                    'UniformOutput',false);     
                %
                projRel.(F.X_TOUCH_CURVE_MAT)=cellfun(@assignNans,...
                    projRel.(F.X_TOUCH_CURVE_MAT), projRel.(F.IS_LT_TOUCH_VEC),...
                    'UniformOutput',false);
                projRel.(F.X_TOUCH_OP_CURVE_MAT)=cellfun(@assignNans,...
                    projRel.(F.X_TOUCH_OP_CURVE_MAT),projRel.(F.IS_LT_TOUCH_OP_VEC),...
                    'UniformOutput',false);
                %
                projRel.(F.XS_TOUCH_VEC)=cellfun(@(x,y)x(:,y),...
                    projRel.(F.X_TOUCH_CURVE_MAT),...
                    num2cell(projRel.indSTime),'UniformOutput',false);                
                projRel.(F.XS_TOUCH_OP_VEC)=cellfun(@(x,y)x(:,y),...
                    projRel.(F.X_TOUCH_OP_CURVE_MAT),...
                    num2cell(projRel.indSTime),'UniformOutput',false);
                %
                ellTubeProjRel=EllUnionTubeStaticProj(projRel);
            else
                ellTubeProjRel=EllUnionTubeStaticProj();
                indProj2OrigVec=zeros(0,1);
            end
            function isTouchVec=calcTouchCandidateVec(normVec,indTimeVec,absTol)
                isTouchVec=false(size(normVec));
                isNormOkVec=normVec>absTol;
                isnZeroIndTime=indTimeVec>0;
                isTouchVec(isnZeroIndTime)=isNormOkVec(indTimeVec(isnZeroIndTime));
            end
            function x=assignNans(x,y)
                x(:,~y)=nan;
            end
        end
        function self=EllUnionTube(varargin)
            self=self@gras.ellapx.smartdb.rels.ATypifiedAdjustedRel(...
                varargin{:});
        end
    end
end