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

            isBackward=self.reachObj.isbackward();
            %there are 3 cases for x0
            %x0 will be passed as input argument that value is for particular
            %test data
            
          
            x0=[1.7; 1.3; -11.1; -11.6];
            controlObj=elltool.control.ContControlBuilder(self.reachObj);
            controlFuncObj=controlObj.getControl(x0);
            properTube=controlFuncObj.getITube();
            for iSwitch=1:switchTimeVecLenght-1
                if (iSwitch==1)
                    iTube=1;
                else
                    iTube=properTube;
                end
                iSwitchBack=switchTimeVecLenght-iSwitch;
                isCurrentEqual=true;
                bpVec=intProbDynamicsList{iSwitchBack}{iTube}.getBptDynamics();
                bpbMat=intProbDynamicsList{iSwitchBack}{iTube}.getBPBTransDynamics();
                %check if u(x,t)\in P(t) for all t
                
%                 ump0Vec=controlFuncObj.evaluate(xi,timeVec(:))-bpVec.evaluate(timeVec(:));
%                 if (dot(ump0Vec,bpbMat.evaluate(timeVec(:))\ump0Vec)>1)
%                    isCurrentEqual=false; 
%                 end
%                 isEqual=isEqual&&isCurrentEqual;
%                 
                t0=switchSysTimeVec(1);
                t1=switchSysTimeVec(iSwitch+1);
                
                AtMat=intProbDynamicsList{iSwitch}{iTube}.getAtDynamics();
                
                [T,Y] = ode45(@(t,y)ode(t,y,AtMat,controlFuncObj,bpVec,bpbMat),[t0 t1],x0',options);
    
                q1Vec=ellTubeRel.aMat{iTube}(:,end);
                q1Mat=ellTubeRel.QArray{iTube}(:,:,end);
                % Unfortunately this comparison doesn't satisfied so there
                % are mistakes
                if (dot(Y(end,:)'-q1Vec,q1Mat\(Y(end,:)'-q1Vec))>1)                    
                    isCurrentEqual=false; 
                end
                isOk=isOk&&isCurrentEqual;   
                
            end
            
            
            mlunitext.assert_equals(true, isOk);
            
            
            
            function dy=ode(t,y,AtMat,controlFuncVec,bpVec,bpbMat)
               isCurEqual=true;
               dy=zeros(AtMat.getNRows(),1); 
               dy=AtMat.evaluate(t)*y+controlFuncVec.evaluate(y,t);
               ump0Vec=controlFuncVec.evaluate(y,t)-bpVec.evaluate(t);
               if (dot(ump0Vec,bpbMat.evaluate(t)\ump0Vec)>1)
                   isCurEqual=false;
               end
               % return or events
            end
        end        
    end
end