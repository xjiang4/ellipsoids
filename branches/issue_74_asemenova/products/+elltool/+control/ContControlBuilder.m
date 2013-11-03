classdef ContControlBuilder
    properties (Access = protected)
        %reachObj
        intEllTube
        probDynamicsList
        goodDirSetList
    end
    methods        
        function self=ContControlBuilder(reachContObj)
            %reachObj=reachContObj.getCopy();
            ellTubeRel=reachContObj.getEllTubeRel();
            self.intEllTube=ellTubeRel.getTuplesFilteredBy('approxType', ...
                gras.ellapx.enums.EApproxType.Internal);
            self.probDynamicsList=reachContObj.getIntProbDynamicsList();
            self.goodDirSetList=reachContObj.getGoodDirSetList();
        end
        
        function controlFuncObj=getControl(self,x0)
            nTuples = self.intEllTube.getNTuples;
            %Tuple selection
            properIndTube=1;
            minDistance=1e+3;
            for iTube=1:nTuples
                %check if x is in E(q,Q), x: <x-q,Q^(-1)(x-q)><=1
                %if (dot(x-qVec,inv(qMat)*(x-qVec))<=1)
                
                qVec=self.intEllTube.aMat{iTube}(:,1);
                qMat=self.intEllTube.QArray{iTube}(:,:,1);
                if (dot(x0-qVec,qMat\(x0-qVec))<=1)
                    ellObj = ellipsoid(qVec, qMat);
                    % now is always -1
                    iDistance=ellObj.distance(x0);
                    
                    if (iDistance<minDistance)
                       minDistance=iDistance;
                       properIndTube=iTube;
                    end
                end
            end
            goodDirOrderedVec=mapGoodDirInd(self.goodDirSetList{1}{1},self.intEllTube);
            indTube=goodDirOrderedVec(properIndTube);
            properEllTube=self.intEllTube.getTuples(properIndTube);
            qVec=properEllTube.aMat{:}(:,1);
            qMat=properEllTube.QArray{:}(:,:,1);
            k=findEllWithoutX(qVec, qMat, x0);
            properEllTube.scale(@(x)sqrt(k),'QArray'); %% или 1/k
            % multiply k^2
            controlFuncObj=elltool.control.ControlVectorFunct(properEllTube,...
                self.probDynamicsList, self.goodDirSetList,indTube);  
            %
            function k=findEllWithoutX(qVec, qMat, x0)
               
                epsilon=1e-3;
                k=1;
                if (dot(x0-qVec,qMat\(x0-qVec))<=1)
                    % find proper k
                    step=1e-2;
                    k=1-step;
                    while ((dot(x0-qVec,inv(k*qMat)*(x0-qVec))<=1+epsilon)&&(k>0))
                        k=k-step;
                    end;                    
                    %qNewMat=k*qMat;
                else                    
                    %qNewMat=qMat;
                end                
            end            
   
            function goodDirOrderedVec=mapGoodDirInd(goodDirSetObj,ellTube)
                CMP_TOL=1e-10;
                nTuples = ellTube.getNTuples;
                goodDirOrderedVec=zeros(1,nTuples);
                lsGoodDirMat = goodDirSetObj.getlsGoodDirMat();
                for iGoodDir = 1:size(lsGoodDirMat, 2)
                    lsGoodDirMat(:, iGoodDir) = ...
                        lsGoodDirMat(:, iGoodDir) / ...
                        norm(lsGoodDirMat(:, iGoodDir));
                end
                lsGoodDirCMat = ellTube.lsGoodDirVec();
                for iTuple = 1 : nTuples
                    %
                    % good directions' indexes mapping
                    %
                    curGoodDirVec = lsGoodDirCMat{iTuple};
                    curGoodDirVec = curGoodDirVec / norm(curGoodDirVec);
                    for iGoodDir = 1:size(lsGoodDirMat, 2)
                        isFound = norm(curGoodDirVec - ...
                            lsGoodDirMat(:, iGoodDir)) <= CMP_TOL;
                        if isFound
                            break;
                        end
                    end
                    mlunitext.assert_equals(true, isFound,...
                        'Vector mapping - good dir vector not found');
                    goodDirOrderedVec(iTuple)=iGoodDir;
                end
            end
        end
    end    
end