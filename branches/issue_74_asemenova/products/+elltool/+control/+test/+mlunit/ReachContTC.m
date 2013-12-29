classdef ReachContTC < mlunitext.test_case
   properties (Access=private)
        testDataRootDir
        linSys
        reachObj
        tVec
        x0Ell
        l0Mat
        expDim
        reachFactoryObj
    end
 
    methods
        function self = ReachContTC(varargin)
            self = self@mlunitext.test_case(varargin{:});
            [~, className] = modgen.common.getcallernameext(1);
            shortClassName = mfilename('classname');
            self.testDataRootDir = [fileparts(which(className)),...
                filesep, 'TestData', filesep, shortClassName];
        end
        %
        function self = set_up_param(self, reachFactObj)
            self.reachFactoryObj=reachFactObj;
            self.reachObj = reachFactObj.createInstance();
            self.linSys = reachFactObj.getLinSys();
            self.expDim = reachFactObj.getDim();
            self.tVec = reachFactObj.getTVec();
            self.x0Ell = reachFactObj.getX0Ell();
            self.l0Mat = reachFactObj.getL0Mat();
        end
    end
    
    methods 
        function isOk = testReachControl(self)
            isOk=1;
            CMP_TOL=1e-10;
            ellTubeRel=self.reachObj.getEllTubeRel();
            switchSysTimeVec=self.reachObj.getSwitchTimeVec();
            switchTimeVecLenght=numel(switchSysTimeVec);
            intProbDynamicsList=self.reachObj.getIntProbDynamicsList();            
            goodDirSetList=self.reachObj.getGoodDirSetList();
            intEllTube=ellTubeRel.getTuplesFilteredBy('approxType', gras.ellapx.enums.EApproxType.Internal);
            options = odeset('RelTol',1e-4,'AbsTol',1e-4);

            nTuples = intEllTube.getNTuples();
            x0Mat(:,1)=[1;2]; %%% check
            %x0Mat(:,1)=[100; 29]; %%third
            x0Mat(:,1)=[5; -7]; %%rot2d
            
            x0Mat(:,2)=[10.5; 0]; %%rot2d
            x0Mat(:,3)=[-7; -7]; %%rot2d
% %          x0Mat(:,1)=[0.5; 0.5];
% %          x0Mat(:,2)=[0;1];
%            x0Mat(:,1)=[-3;0.4]; %Interval
%            x0Mat(:,2)= [1;0.7]; %Interval
% %             
%            x0Mat(:,3)= [0.4; 0.4]; %Interval
%            x0Mat(:,4)= [5; 0]; %Interval  1.002000 ��� ������� 1.07-6008
           % x0Mat(:,3)=[-1;2];
          % x0Mat(:,1)=[4;1.5];
            for iXCount=1:size(x0Mat,2)
                x0Vec=x0Mat(:,iXCount)
                %x0Vec=[50; 10];
                %particular example (there aren't any switches)
                %x0Vec=[1.7; 1.3; -11.1; -11.6];
                isX0inSet=false;
 
                controlObj=elltool.control.ContControlBuilder(self.reachObj);
                controlFuncObj=controlObj.getControl(x0Vec);
                if (~all(size(x0Vec)==size(intEllTube.aMat{1}(:,1))))
                    self.runAndCheckError('controlObj.getControl(x0Vec)','wrongInput');
                    return;
                end  
                for iTube=1:nTuples
                    %check if x is in E(q,Q), x: <x-q,Q^(-1)(x-q)><=1
                    %if (dot(x-qVec,inv(qMat)*(x-qVec))<=1)

                    qVec=intEllTube.aMat{iTube}(:,1);  
                    qMat=intEllTube.QArray{iTube}(:,:,1); 
                    if (dot(x0Vec-qVec,qMat\(x0Vec-qVec))<=1)
                        isX0inSet=true;
                    end
                end



                if (~isX0inSet)
                    self.runAndCheckError('controlObj.getControl(x0Vec)','wrongInput');
    %             errList = {'wrongInput'};
    %             self.runAndCheckError('obj.doSomethingBad2(inpParamList{:})',errList);
    %           end
                    return;
                end
                isCurrentEqual=true;

                properTube=controlFuncObj.getITube();
                iTube=1;
                for iSwitch=1:switchTimeVecLenght-1
                    if (iSwitch>1)
                        iTube=properTube; %check if this number corresponds tuple in ellTube
                    end
                    iSwitchBack=switchTimeVecLenght-iSwitch;               
                    bpVec=intProbDynamicsList{iSwitchBack}{iTube}.getBptDynamics();
                    bpbMat=intProbDynamicsList{iSwitchBack}{iTube}.getBPBTransDynamics();
    %                  
                    t0=switchSysTimeVec(iSwitch);
                    t1=switchSysTimeVec(iSwitch+1);
                    ind=find(ellTubeRel.timeVec{iTube}==t1);
                    AtMat=intProbDynamicsList{iSwitchBack}{iTube}.getAtDynamics();

                    %[T,Y] = ode45(@(t,y)ode(t,y,AtMat,controlFuncObj,bpVec,bpbMat),[t0 t1],x0Vec',options);
                    h=10^(-3);
                    f=@(t,y)-AtMat.evaluate(t1-t+t0)*y'+controlFuncObj.evaluate(y',t);
                    %f=@(t,y)AtMat.evaluate(t)*y'+controlFuncObj.evaluate(y',t);
                    Y=eiler(h,t0,t1,x0Vec',f);
                    q1Vec=ellTubeRel.aMat{iTube}(:,ind); 
                    q1Mat=ellTubeRel.QArray{iTube}(:,:,ind);
  
                    if (dot(Y(end,:)'-q1Vec,q1Mat\(Y(end,:)'-q1Vec))>1)
                        isCurrentEqual=false;
                    end

 
                end
                q1Vec=ellTubeRel.aMat{iTube}(:,end);
                q1Mat=ellTubeRel.QArray{iTube}(:,:,end);
                % Unfortunately this comparison is satisfied so there
                % are mistakes
                if (dot(Y(end,:)'-q1Vec,q1Mat\(Y(end,:)'-q1Vec))>1+1e-05)
                    isCurrentEqual=false;
                end
                isOk=isOk&&isCurrentEqual;
            end
            %isOk=isOk&&isCurrentEqual;
            
            
            
            
            mlunitext.assert_equals(true, isOk);
            
            
            
            function dy=ode(t,y,AtMat,controlFuncVec,bpVec,bpbMat)
               isCurEqual=true;
               dy=zeros(AtMat.getNRows(),1); 
               dy=AtMat.evaluate(t)*y+controlFuncVec.evaluate(y,t);

            end


            function y=eiler(h,x0,x1,y0,f)
            %     if frac((x1-x0)/h)
            %         trunc((x1-x0)/h)+1;
            %     end
                i=1;
                xInd=x0;
                y(1,:)=y0';
                while (xInd<x1)
                    y(i+1,:)=y(i,:)+h*f(xInd,y(i,:))';
                    xInd=xInd+h;
                    i=i+1;

                end
            end

        end  
        
    end
end