classdef ReachContLTIProblemDef<gras.ellapx.lreachplain.probdef.AReachContProblemDef
    methods(Static,Access=protected)
        function isOk=isPartialCompatible(aCMat,bCMat,pCMat,pCVec,x0Mat,...
                x0Vec,tLims)
            import gras.mat.symb.iscellofstringconst;
            isOk = ...
                iscellofstringconst(aCMat)&&...
                iscellofstringconst(bCMat)&&...
                iscellofstringconst(pCMat)&&...
                iscellofstringconst(pCVec);
        end
    end    
    methods(Static)
        function isOk=isCompatible(aCMat,bCMat,pCMat,pCVec,x0Mat,...
                x0Vec,tLims)
            isOk = ...
                gras.ellapx.lreachplain.probdef.ReachContLTIProblemDef.isPartialCompatible(...
                aCMat,bCMat,pCMat,pCVec,x0Mat,x0Vec,tLims)&&...
                gras.ellapx.lreachplain.probdef.AReachContProblemDef.isCompatible(...
                aCMat,bCMat,pCMat,pCVec,x0Mat,x0Vec,tLims);
        end
    end
    methods
        function self=ReachContLTIProblemDef(aCMat,bCMat,pCMat,pCVec,...
                x0Mat,x0Vec,tLims)
            %
            import gras.ellapx.lreachplain.probdef.ReachContLTIProblemDef;
            %
            if ~ReachContLTIProblemDef.isPartialCompatible(aCMat,bCMat,pCMat,...
                    pCVec,x0Mat,x0Vec,tLims)
                modgen.common.throwerror(...
                    'wrongInput', 'Incorrect system definition');
            end
            %
            self=self@gras.ellapx.lreachplain.probdef.AReachContProblemDef(...
                aCMat,bCMat,pCMat,pCVec,x0Mat,x0Vec,tLims);
        end
    end
end