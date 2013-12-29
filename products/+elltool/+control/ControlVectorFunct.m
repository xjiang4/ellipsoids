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
        function resVec=evaluate(self,x,timeVec)
            
            resVec=zeros(size(x,1),size(timeVec,2));
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
                t0=min(probTimeVec);
                xt1tMat=inv((xstTransMat.evaluate(t1-t1+t0))')*((xstTransMat.evaluate(t1-timeVec(i)+t0))');
                %xtt1Matp=inv((xstTransMat.evaluate(t1-timeVec(i)))')*((xstTransMat.evaluate(t1-t1))');
%               xtt1Matp=inv((xstTransMat.evaluate(timeVec(i)))')*((xstTransMat.evaluate(t1))');
%               xt1tMat=inv(xtt1Matp);
                bpVec=-curProbDynObj.getBptDynamics.evaluate(t1-timeVec(i)+t0);%ellipsoid center
                bpbMat=curProbDynObj.getBPBTransDynamics.evaluate(t1-timeVec(i)+t0);   %ellipsoid matrice
                pVec=xt1tMat*bpVec;
                pMat=xt1tMat*bpbMat*xt1tMat';
                    
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
                
                %for debugging!!!
                if ((dot(x-qVec,qMat\(x-qVec))<1)||(dot(x-qVec,(qMat*(1/self.koef))\(x-qVec))>1))
                    %if point is not situated between ellipsoids 
                    isMistake=true            
                    ellipsoidExt=ellipsoid(qVec,qMat);
                    ellipsoidInt=ellipsoid(qVec,qMat*(1/self.koef));
                    % if point is out of both ellipsoids
                    if (dot(x-qVec,(qMat*(1/self.koef))\(x-qVec))>1)
                        isOutOfBound=true
                        elext=dot(x-qVec,qMat\(x-qVec))
                        elint=dot(x-qVec,(qMat*(1/self.koef))\(x-qVec))
                        ellObj = ellipsoid(qVec, qMat*(1/self.koef));
                    
                        %iDistance=ellObj.distance(x)
                        curtime=timeVec(i)
                    end                
                end
                %
                ml1Vec=sqrt(dot(x-qVec,inv(qMat)*(x-qVec)));
                l0=inv(qMat)*(x-qVec)/ml1Vec;
                if (dot(-l0,x)>dot(l0,x))
                    l0=-l0;
                end
                l0=l0/norm(l0)
% %                 l0=findl0(qVec,qMat,x)
                
                resVec(:,i)=pVec-(pMat*l0)/sqrt(dot(l0,pMat*l0));
                resVec(:,i)=inv(xt1tMat)*resVec(:,i);

            end 
            function l0=findl0(elxCentVec,elXMat,x)
                
                 I=eye(size(elXMat));
%                
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