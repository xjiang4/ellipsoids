classdef ControlVectorFunct < elltool.control.IControlVectFunction
    properties
        properEllTube
        probDynamicsList
        goodDirSetList
        iTube
    end
    methods
        function self=ControlVectorFunct(properEllTube,...
                probDynamicsList, goodDirSetList,iTube)
            self.properEllTube=properEllTube;
            self.probDynamicsList=probDynamicsList;
            self.goodDirSetList=goodDirSetList;
            self.iTube=iTube;
        end
        function res=evaluate(self,x,timeVec)
            %depends on input, should be check if x has wrong dimension
            res=zeros(size(x,1),size(timeVec,2));
       
               
            %curProbDynObj, curGoodDirSetObj must correspond the time period
            
            %self.probDynamicsList{1}{1}.getTimeVec();
            for i=1:size(timeVec,2)
                probTimeVec=self.probDynamicsList{1}{1}.getTimeVec();
                if ((timeVec(i)<=probTimeVec(end))&&(timeVec(i)>=probTimeVec(1)))
                    curProbDynObj=self.probDynamicsList{1}{1};
                    curGoodDirSetObj=self.goodDirSetList{1}{1};
                    
                else
                    for iSwitch=2:numel(self.probDynamicsList)
                        probTimeVec=self.probDynamicsList{iSwitch}{self.iTube}.getTimeVec();
                        if ((timeVec(i)<=probTimeVec(end))&&(timeVec(i)>=probTimeVec(1)))
                            curProbDynObj=self.probDynamicsList{iSwitch}{self.iTube};
                            curGoodDirSetObj=self.goodDirSetList{iSwitch}{self.iTube};
                            break;
                        end
                    end
                end;
                %X(t,t0)=X(t,s)*X(s,t0)=inv(X(s,t))*X(s,t0);
                xstTransMat=(curGoodDirSetObj.getXstTransDynamics());
                t1=max(probTimeVec);                
                %st1tMat=xtt0Mat.evaluate(t1)*inv(xtt0Mat.evaluate(timeVec(i)));                
                st1tMat=inv(xstTransMat.evaluate(t1)')*(xstTransMat.evaluate(timeVec(i))');
                
                %\ instead inv(A)*b to reduce calculation time
                bpVec=curProbDynObj.getBptDynamics.evaluate(timeVec(i));%ellipsoid center
                bpbMat=curProbDynObj.getBPBTransDynamics.evaluate(timeVec(i));   %ellipsoid matrice
                pVec=st1tMat*bpVec;
                pMat=st1tMat*bpbMat*st1tMat';
                
%                 pVec=st1tMat*bpVec;
%                 pMat=st1tMat*bpbMat*st1tMat';
                
                ellTubeTimeVec=self.properEllTube.timeVec{:};
                
                % ! can be mistake
                ind=find(ellTubeTimeVec <= timeVec(i));
                tInd=size(ind,2);
                if ellTubeTimeVec(tInd)<timeVec(i)
                    
                    nDim=size(self.properEllTube.aMat{:},1);
                    qVec=zeros(nDim,1);
                    for iDim=1:nDim
                        qVec(iDim)=interp1(ellTubeTimeVec,self.properEllTube.aMat{:}(iDim,:),timeVec(i));
                    end;
                    nDimRow=size(self.properEllTube.QArray{:},1);
                    nDimCol=size(self.properEllTube.QArray{:},2);
                    qMat=zeros(nDimRow,nDimCol);
                    for iDim=1:nDimRow
                        %QArraytime=self.properEllTube.QArray{:}(iDim,:,:);
                        for jDim=1:nDimCol
                            QArrayTime(1,:)=self.properEllTube.QArray{:}(iDim,jDim,:);
                            qMat(iDim,jDim)=interp1(ellTubeTimeVec,QArrayTime,timeVec(i));
                        end
                    end;
                    
                else
                    if (ellTubeTimeVec(tInd)==timeVec(i))
                        qVec=self.properEllTube.aMat{:}(:,tInd);
                        qMat=self.properEllTube.QArray{:}(:,:,tInd);
                    end
                end
                
                % should check if x is always in tube
                
                l0=findl0(qVec,qMat,x);
                %res=pMat(timeVec(ind))-PArray(timeVec(ind))*l0*dot(l0,QArray(timeVec(ind))*l0)^(-1/2);
                res(:,i)=pVec-(pMat*l0)/sqrt(dot(l0,pMat*l0));
                res(:,i)=inv(st1tMat)*res(:,i);
                ump0Vec=res(:,i)-bpVec;
                elu=dot(ump0Vec,bpbMat\ump0Vec)
                if (elu>1+1e-5)
                   isCurEqual=false
                end
                %                 bCMat=curGoodDirSetObj.getProblemDef().getBMatDef();
                %                 %bMat=cellfun(@eval,bCMat);
            end
            function l0=findl0(elxCentVec,elXMat,x)
                
                I=eye(size(elXMat));
                %                 f=@(lambda) 1/dot(inv(I+lambda*inv(elXMat))*(x-elxCentVec),...
                %                     inv(elXMat)*inv(I+lambda*inv(elXMat))*(x-elxCentVec))-1;
                f=@(lambda) 1/dot((I+lambda*inv(elXMat))\(x-elxCentVec),...
                    inv(elXMat)*inv(I+lambda*inv(elXMat))*(x-elxCentVec))-1;
                lambda=fsolve(f,1.0e-3);
                s0=(I+lambda*inv(elXMat))\(x-elxCentVec)+elxCentVec;
                l0=(x-s0)/norm(x-s0);
            end
            
        end
        function iTube=getITube(self)
            iTube=self.iTube;
        end
    end
end