classdef ControlVectorFunct < elltool.control.IControlVectFunction
    properties
        properEllTube
        probDynamicsList
        goodDirSetList
        iTube
        koef
    end
    methods
        function self=ControlVectorFunct(properEllTube,...
                probDynamicsList, goodDirSetList,iTube,k)
            self.properEllTube=properEllTube;
            self.probDynamicsList=probDynamicsList;
            self.goodDirSetList=goodDirSetList;
            self.iTube=iTube;
            self.koef=k;
        end
        function res=evaluate(self,x,timeVec)
            
            res=zeros(size(x,1),size(timeVec,2));
            import ;
            isMistake=false;   
            %find curProbDynObj, curGoodDirSetObj corresponding to that time period                       
            
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
                
                xstTransMat=(curGoodDirSetObj.getXstTransDynamics());
                t1=max(probTimeVec);                
                
                %st1tMat=X(t,t1)=X(t,s)X(s,t1)=inv(X(s,t))X(s,t1)
                
                %%%st1tMat=inv(xstTransMat.evaluate(t1)')*(xstTransMat.evaluate(timeVec(i))');
                st1tMat=inv(xstTransMat.evaluate(timeVec(i))')*(xstTransMat.evaluate(t1)');
                %\ instead inv(A)*b to reduce calculation time
                bpVec=curProbDynObj.getBptDynamics.evaluate(timeVec(i));%ellipsoid center
                bpbMat=curProbDynObj.getBPBTransDynamics.evaluate(timeVec(i));   %ellipsoid matrice
                pVec=st1tMat*bpVec;
                pMat=st1tMat*bpbMat*st1tMat';
                
                ellTubeTimeVec=self.properEllTube.timeVec{:};
                
                ind=find(ellTubeTimeVec <= timeVec(i));
                tInd=size(ind,2);
              
                %find proper ellipsoid which corresponts current time
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
                
                % check if x is always in tube (to find out if there is already mistake)
%                 elext=dot(x-qVec,qMat\(x-qVec))
%                 elint=dot(x-qVec,(qMat*(1/self.koef))\(x-qVec))   
                curtime=timeVec(i)


%                 ellipsoidExt=ellipsoid(qVec,qMat);
%                 ellipsoidInt=ellipsoid(qVec,qMat*(1/self.koef));
%                 %figure;
%                 plot(ellipsoidInt);
%                 hold on;
%                 plot(ellipsoidExt,'g');
%                 hold on;
%                 plot(x(1),x(2),'*');
%                 hold on;
                if ((dot(x-qVec,qMat\(x-qVec))<1)||(dot(x-qVec,(qMat*(1/self.koef))\(x-qVec))>1))                    
                    isMistake=true            
                    ellipsoidExt=ellipsoid(qVec,qMat);
                    ellipsoidInt=ellipsoid(qVec,qMat*(1/self.koef));
                %figure;
%                     plot(ellipsoidInt);
%                     hold on;
%                     plot(ellipsoidExt,'g');
%                     hold on;
%                     plot(x(1),x(2),'*');
%                     hold on;
                end
                
                l0=findl0(qVec,qMat,x)
                %res=pMat(timeVec(ind))-PArray(timeVec(ind))*l0*dot(l0,QArray(timeVec(ind))*l0)^(-1/2);
                res(:,i)=pVec-(pMat*l0)/sqrt(dot(l0,pMat*l0));%-!!!
                res(:,i)=inv(st1tMat)*res(:,i)
                ump0Vec=res(:,i)-bpVec;
                %%% u is always in the boundary of control set
%                 elu=dot(ump0Vec,bpbMat\ump0Vec)
%                 if (elu>1+1e-5)
%                    isCurEqual=false

%                 end

            end
            function l0=findl0(elxCentVec,elXMat,x)
                
                 I=eye(size(elXMat));
%                 %                 f=@(lambda) 1/dot(inv(I+lambda*inv(elXMat))*(x-elxCentVec),...
%                 %                     inv(elXMat)*inv(I+lambda*inv(elXMat))*(x-elxCentVec))-1;
%                 f=@(lambda) 1/dot((I+lambda*inv(elXMat))\(x-elxCentVec),...
%                     inv(elXMat)*inv(I+lambda*inv(elXMat))*(x-elxCentVec))-1;
%                 lambda=fsolve(f,1.0e-3)
%                 s0=(I+lambda*inv(elXMat))\(x-elxCentVec)+elxCentVec;
%                 l0=(x-s0)/norm(x-s0);
                  f=@(lambda)1/(dot(inv(I+lambda*inv(elXMat))*(x-elxCentVec),...
                      inv(elXMat)*inv(I+lambda*inv(elXMat))*(x-elxCentVec)))-1;
                  lambda=fsolve(f,1.0e-5);
                  s0=inv(I+lambda*inv(elXMat))*(x-elxCentVec)+elxCentVec;
                  l0=(x-s0)/norm(x-s0);

            end
            
        end
        function iTube=getITube(self)
            iTube=self.iTube;
        end
    end
end