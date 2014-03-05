classdef EllTubeProj<gras.ellapx.smartdb.rels.ATypifiedAdjustedRel&...
        gras.ellapx.smartdb.rels.EllTubeProjBasic
    % A class which allows to work with projections of ellipsoid tube objects.
    %
    % Fields:
    %   QArray: cell[1,1] of double[nDims,nDims,nTimePoints] -
    %       a 3-dimentional matrix in which each of nTimePoints slices is a 
    %       double[nDims,nDims] projection of an ellipsoid matrix on specified 
    %       subspace at nTimePoint point of time. Here nTimePoints is number 
    %       of elements in timeVec.
    %   aMat: cell[1,nTimePoints] of double[nDims,1] - a 2-dimentional matrix 
    %       in which each of nTimePoints columns is a projection of
    %       an ellipsoid center. Each center is specified for 
    %       nTimePoint point of time
    %   scaleFactor: double[1, 1] - scale for the created ellipsoid tube
    %   MArray: cell[1,1] of double[nDims,nDims,nTimePoints] -
    %       a 3-dimentional matrix in which each of nTimePoints slices is a 
    %       double[nDims,nDims] projection of a regularization matrix on specified 
    %       subspace at nTimePoint point of time.
    %   dim: double[1, 1] - the dimension of the space on which the touching 
    %       curves are projected
    %   sTime: double[1, 1] - specific point of time which is best suited to
    %       describe good direction
    %   approxSchemaName: cell[1, 1] of char[1,] - name of the 
    %       approximation schema
    %   approxSchemaDescr: cell[1, 1] of char[1,] - description of the 
    %       approximation schema
    %   approxType: gras.ellapx.enums.EApproxType[1,1] - type of approximation 
    %       (External, Internal, NotDefined)
    %   timeVec: double[1, nTimePoints] - time vector 
    %   absTolerance: double[1, 1] - absolute tolerance
    %   relTolerance: double[1, 1] - relative tolerance
    %   indSTime: double[1, 1]  - index of sTime point within timeVec
    %   ltGoodDirMat: cell[1, nTimePoints] of double[nDims, 1] - matrix of 
    %       the projections of good direction vectors on the specified space 
    %       at any point of time from timeVec
    %   lsGoodDirVec: cell[1, 1] of double[nDims, 1] - the projection of good
    %       direction vector on the specified space at sTime point of time
    %   ltGoodDirNormVec: cell[1, 1] of double[1, nTimePoints] - norm of the 
    %       projections of good direction vectors on the specified space at 
    %       any point of time from timeVec
    %   lsGoodDirNorm: double[1, 1] - norm of the projection of good direction 
    %       vector on the specified space at sTime point of time
    %   xTouchCurveMat: cell[1, nTimePoints] of double[nDims, 1] - the projection 
    %       of touch point curve on the specified space for good direction matrix
    %   xTouchOpCurveMat: cell[1, nTimePoints] of double[nDims, 1] - the projection
    %       of touch point curve oposite to the xTouchCurveMat touch point curve
    %   xsTouchVec: cell[1, 1] of double[nDims, 1]  - the projection of touch
    %       point at sTime point of time
    %   xsTouchOpVec: cell[1, 1] of double[nDims, 1] - the projection of a 
    %       point opposite to the xsTouchVec touch point
    %   isLsTouch: logical[1, 1] - a logical variable which indicates whether 
    %       a touch takes place along good direction at sTime point of time
    %   isLsTouchVec: cell[1, 1] of logical[nTimePoints, 1] - a logical
    %       vector which indicates whether a touch takes place along good 
    %       direction at any point of time from timeVec
    %   projSMat: cell[1, 1] of double[nDims, nDims] - projection matrix at 
    %       sTime point of time
    %   projArray: cell[nTimePoints, 1] of double[nDims, nDims] - an array 
    %       of projection matrices at any point of time from timVec
    %   projType: gras.ellapx.enums.EProjType[1, 1] - type of projection 
    %       (Static, DynamicAlongGoodCurve)
    %   ltGoodDirNormOrigVec: cell[1, 1] of double[1, nTimePoints] - norm 
    %       of the original good direction vectors at any point of time from timeVec
    %   lsGoodDirNormOrig: double[1, 1] - norm of the original good direction 
    %       vector at sTime point of time
    %   ltGoodDirOrigMat: cell[1, nTimePoints] of double[nDims, 1] - matrix 
    %       of the original good direction vectors at any point of time from timeVec
    %   lsGoodDirOrigVec: cell[1, 1] of double[nDims, 1] - the original good 
    %       direction vector at sTime point of time
    %   ltGoodDirNormOrigProjVec: cell[1, 1] of double[1, nTimePoints] - norm
    %       of the projection of the original good direction curve
    %   ltGoodDirOrigProjMat: cell[1, 1] of double[nDims, nTimePoints] - the 
    %       projectition of the original good direction curve
    %
    methods(Access=protected)
        function changeDataPostHook(self)
            self.checkDataConsistency();
        end
    end
    methods
        function self=EllTubeProj(varargin)
            self=self@gras.ellapx.smartdb.rels.ATypifiedAdjustedRel(...
                varargin{:}); 
        end
        
    end
end