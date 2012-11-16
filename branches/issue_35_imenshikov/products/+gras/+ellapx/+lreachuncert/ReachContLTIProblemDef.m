classdef ReachContLTIProblemDef<gras.ellapx.lreachuncert.AReachContProblemDef
    methods(Static)
        function isOk=isCompatible(aCMat,bCMat,pCMat,pCVec,cCMat,...
                qCMat,qCVec,x0Mat,x0Vec,tLims)
            import gras.mat.symb.iscellofstringconst;
            isOk = ...
                iscellofstringconst(aCMat)&&...
                iscellofstringconst(bCMat)&&...
                iscellofstringconst(pCMat)&&...
                iscellofstringconst(pCVec)&&...
                iscellofstringconst(cCMat)&&...
                iscellofstringconst(qCMat)&&...
                iscellofstringconst(qCVec)&&...
                gras.ellapx.lreachuncert.AReachContProblemDef.isCompatible(...
                aCMat,bCMat,pCMat,pCVec,cCMat,qCMat,qCVec,x0Mat,x0Vec,tLims);
        end
    end
    methods
        function self=ReachContLTIProblemDef(aCMat,bCMat,pCMat,pCVec,...
                cCMat,qCMat,qCVec,x0Mat,x0Vec,tLims)
            %
            import gras.ellapx.lreachuncert.ReachContLTIProblemDef;
            %
            if ~ReachContLTIProblemDef.isCompatible(aCMat,bCMat,pCMat,...
                    pCVec,cCMat,qCMat,qCVec,x0Mat,x0Vec,tLims)
                modgen.common.throwerror(...
                    'wrongInput', 'Incorrect system definition');
            end
            %
            self=self@gras.ellapx.lreachuncert.AReachContProblemDef(...
                aCMat,bCMat,pCMat,pCVec,cCMat,qCMat,qCVec,x0Mat,x0Vec,...
                tLims);
        end
    end
end