classdef ObjectApproximationTestCase < mlunitext.test_case
    
    methods
        
        
        function self = ObjectApproximationTestCase(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        
        function self = testIsConvexHull(self)
            import  elltool.multobj.calcconvexhull;
            %2D case, convex hull contains not all points
            pointsMat = [1 1;0 2; 3 5; 1 6; 2 7; 0.5 8];
            expConvexMat = [0.8944    0.4472;...
                0.5547    0.8321; 0.8944   -0.4472;...
                -0.7071   -0.7071; -0.9965    0.0830];
            expConvexVec = zeros(1,5)';
            expDiscrVec = zeros(1,5);
            expVertMat = [3 5;0 2; 0.5 8; 1 1; 2 7];
            [convexMat convexVec discrVec vertMat]= ...
                calcconvexhull(pointsMat,[],[],3,{'relPrec',1.e-7,...
                'errorCheckMode',0,'faceDist',.9e-6});
            mlunitext.assert(self.check(convexMat,expConvexMat,vertMat,...
                expVertMat,convexVec,expConvexVec,discrVec,expDiscrVec));
            
            %2D case, convex hull contains all the points
            pointsMat = [0 0;0.5 0.1; 0 2.24; 5.3 7];
            expConvexMat = [ 0.8209   -0.5711;  0.1961   -0.9806;...
                -0.6682 0.7440; -1.0000 0];
            expConvexVec = [ -0.3533; 0; -1.6665; 0];
            expDiscrVec = zeros(1,4);
            expVertMat = [5.3 7;0 0; 0 2.24; 0.5 0.1];
            [convexMat convexVec discrVec vertMat]= ...
                calcconvexhull(pointsMat,[],[],3,{'approxPrec',1.e-4,...
                'discardIneqMode',0,'inApproxDist',1.e-6});
            mlunitext.assert(self.check(convexMat,expConvexMat,vertMat,...
                expVertMat,convexVec,expConvexVec,discrVec,expDiscrVec));
            
            %2D case, non-default value of IncDim
            pointsMat = [0 0;0.5 2; 0.1 0.1; 5 3];
            expConvexMat = [0 0;-0.2169 0.9762;-0.9701 0.2425;-0.2588...
                0.9659;0.5145 -0.8575; 0.9659 -0.2588; -0.7071  -0.7071;...
                0 0];
            expConvexVec = [0;-1.8439; 0;-1.8024; 0;-4.0532; 0; -1.0000];
            expDiscrVec =  1.0e-06*[0 0 0 0.0298 0 0.1788];
            expVertMat = [0 0;5 3; 0.5 2];
            [convexMat convexVec discrVec vertMat]=...
                calcconvexhull(pointsMat,[],[],1,{'incDim',1});
            mlunitext.assert(self.check(convexMat,expConvexMat,vertMat,...
                expVertMat,convexVec,expConvexVec,discrVec,expDiscrVec));
            %
            pointsMat = [0 0;1 1; 2 4; -1 -5; -2 0; 1 0.1; -1 -0.1; 1 3; ...
                2 3; 7 7; 7.2 7.1; -1 2; 1 2];
            expConvexMat = [-0.5145 0.8575; -0.4472 0.8944; -0.5547 0.8321;...
                           -0.8944 0.4472;0.8278 -0.5610; -0.9806 -0.1961];
            expConvexVec =[-2.4010;-3.1305;-2.2188;-1.7889;-1.9772;-1.9612];
            expDiscrVec =  1.0e-06*[ 0.1192 -0.0596 0.1192 0.0596 0.0387...
                -0.0149];
            expVertMat = [7.2 7.1; -2 0; -1 -5; -1 2; 2 4; 7 7];
            [convexMat convexVec discrVec vertMat]=...
                calcconvexhull(pointsMat,[],[],2,{'nAddTopElems',16,...
                'inftyDef',1e4,'relPrec',1e-10});
            mlunitext.assert(self.check(convexMat,expConvexMat,vertMat,...
                expVertMat,convexVec,expConvexVec,discrVec,expDiscrVec));
            
            %2D case, not accurate enough values of properties
            pointsMat = [1 1;0 2; 3 5; 1 6; 2 7; 0.5 8];
            expConvexMat = [ 0.8944   -0.4472;   -0.7071   -0.7071;...
                0.7682    0.6402;   -0.9965    0.0830];
            expConvexVec = [-0.4472; 1.4142; -5.5056; -0.1661];
            expDiscrVec = [0 0 0.5121 0.4568];
            expVertMat = [3 5;0 2; 0.5 8; 1 1];
            [convexMat convexVec discrVec vertMat]=...
                calcconvexhull(pointsMat,[],[],2,{'inApproxDist',1e-2,...
                'ApproxDist',9e-1});
           mlunitext.assert(self.check(convexMat,expConvexMat,vertMat,...
                expVertMat,convexVec,expConvexVec,discrVec,expDiscrVec));
            
            % the same points,but bad accuracy
            pointsMat = [1 1;0 2; 3 5; 1 6; 2 7; 0.5 8];
            [convexMat convexVec discrVec vertMat]=...
                calcconvexhull(pointsMat,[],[],1,{'relPrec',1e-1});
            mlunitext.assert((0==numel(convexMat))&&(0==numel(convexVec))...
                &&(0 == numel(discrVec))&&(0 == numel(vertMat)));
            
            %3D case
            pointsMat = [0 0 0; 1 0 1; 1 1 0; 2 3 6; 9 1 1];
            expConvexMat = [ 0.1231   -0.9847   -0.1231;...
                0.1077   -0.8619    0.4956;...
                -0.5145   -0.6860    0.5145;...
                0.1231   -0.1231   -0.9847;...
                0.0403    0.9459   -0.3220;...
                -0.7022    0.7022   -0.1170];
            expConvexVec = [-0.0000;-0.6033;  0.0000; 0.0000;...
                -0.9861;0.0000];
            
            expDiscrVec = 1.0e-07*[0.4470 0 0.2839 0.8941 0.6333];
            
            expVertMat =  [9 1 1; 0 0 0; 2 3 6; 1 1 0; 1 0 1];
            
            
            [convexMat convexVec discrVec vertMat] =...
                calcconvexhull(pointsMat,[],[],1,{'relPrec',1.e-8});
            mlunitext.assert(self.check(convexMat,expConvexMat,vertMat,...
                expVertMat,convexVec,expConvexVec,discrVec,expDiscrVec));
            %3D case, with Pareto shell
            pointsMat = [0 0 0; 1.2 0 4; 3 2 2; 0.25 0.5 0.1; 1 2.2 6];
            expConvexMat = [ 0.5684 0 -0.8227; -0.3464 0.9122 -0.2188;...
                0.3714 0 -0.9285; -0.8930 0.4497 -0.0161;...
                0.8944 0  0.4472; -0.9864 0 0.1644];
            expConvexVec = [-0.0598; -0.3476; 0; 0; -3.5777; 0];
            expDiscrVec = zeros(1,5);
            expVertMat = [3 2 2; 0 0 0; 1 2.2 6; 0.25 0.5 0.1];
            [convexMat convexVec discrVec vertMat]=...
                calcconvexhull(pointsMat,[1 2 3],[1 1 1],3,{'ApproxDist',...
                1.e-7,'precTest',1.e-7,'faceDist',1.e-8});
            mlunitext.assert(self.check(convexMat,expConvexMat,vertMat,...
                expVertMat,convexVec,expConvexVec,discrVec,expDiscrVec));
            %3D case,convex hull is empty
            pointsMat = [0 0 0; 0.5 2 1; 1 4 2];
            
            [convexMat convexVec discrVec vertMat]=...
                calcconvexhull(pointsMat,[],[],0,{});
            mlunitext.assert((0==numel(convexMat))&&(0==numel(convexVec))...
                &&(0 == numel(discrVec))&&(0 == numel(vertMat)));
            
            
            %wrong input
            self.runAndCheckError...
                ('elltool.multobj.calcconvexhull([1 2 3; 2 8 0],[],[],0)',...
                'wrongSize');
        end
        %
        function self = testIsEllipsoidApprox(self)
            import  elltool.multobj.calcellipsoidapprox;
            %
            semiaxesVec=[0.16 0.64];
            expApproxMat =  [-0.9476    0.3194;   -0.9640    0.2659;...
                0.9476  0.3194;    0.9640    0.2659;    0.9476  -0.3194;...
                0.9640  -0.2659;  -0.9476   -0.3194;   -0.9640  -0.2659;...
                -0.8841  0.4673;   -0.9229    0.3850;    0.8841  0.4673;...
                0.9229  0.3850;   -0.8841   -0.4673;   -0.9229  -0.3850;...
                0.8841  -0.4673;   0.9229   -0.3850;   -0.7078   0.7064;...
                -0.8197  0.5727;    0.7078    0.7064;    0.8197  0.5727;...
                0.7078  -0.7064;   0.8197   -0.5727;   -0.7078  -0.7064;...
                -0.8197  -0.5727; -0.1928    0.9812;   -0.5103   0.8600;...
                0.5103    0.8600;  0.1928    0.9812;  -0.1928   -0.9812;...
                -0.5103   -0.8600;  0.1928   -0.9812;   0.5103  -0.8600;...
                -0.9997    0.0246; -0.9971    0.0756;   0.9997   0.0246;...
                0.9971    0.0756; -0.9971   -0.0756;  -0.9997   -0.0246;...
                0.9971   -0.0756;  0.9997   -0.0246;  -0.9796   -0.2010;...
                -0.9912   -0.1325;  0.9796   -0.2010;  0.9912   -0.1325;...
                -0.9796    0.2010; -0.9912    0.1325;  0.9796    0.2010;...
                0.9912    0.1325];
            
            expApproxVec = [-0.2542; -0.2294; -0.2542; -0.2294; -0.2542;...
                -0.2294;   -0.2542;   -0.2294;   -0.3304;   -0.2869;...
                -0.3304;   -0.2869;   -0.3304;   -0.2869;   -0.3304; ...
                -0.2869;   -0.4655;   -0.3888;   -0.4655;   -0.3888; ...
                -0.4655;   -0.3888;   -0.4655;   -0.3888;   -0.6280; ...
                -0.5558;   -0.5558;   -0.6280;   -0.6280;   -0.5558;...
                -0.6280;   -0.5558;   -0.1600;   -0.1659;   -0.1600;...
                -0.1659;   -0.1659;   -0.1600;   -0.1659;   -0.1600;...
                -0.2018;   -0.1790;   -0.2018;   -0.1790;   -0.2018;...
                -0.1790;   -0.2018;   -0.1790];
            
            expDiscrVec = 1.0e-03 *[ 0.9212    0.2767    0.9212   0.2767...
                0.9212    0.2767    0.9212    0.2767    0.3985    0.3460...
                0.3985    0.3460    0.3985    0.3460    0.3985    0.3460...
                0.5614    0.4689    0.5614    0.4689    0.5614    0.4689...
                0.5614    0.4690    0.7573    0.6702    0.6703    0.7574...
                0.7574    0.6702    0.7574    0.6702    0.7739    0.8028...
                0.7739    0.8028    0.8028    0.7739    0.8028    0.7739...
                0.9764    0.8659    0.9764    0.8659    0.9763    0.8659...
                0.9763    0.8659];
            
            
            
            expVertMat =  [0.1600  0;   -0.1600  0; 0 0.6400; 0 -0.6400;...
                0.1131  -0.4525; -0.1131   -0.4525;   0.1131    0.4525;...
                -0.1131  0.4525;  0.0612    0.5913;  -0.0612    0.5913;...
                -0.0612 -0.5913;  0.0612   -0.5913;  -0.1478    0.2449;...
                0.1478   0.2449;  -0.1478   -0.2449;   0.1478   -0.2449;...
                0.0312  -0.6277;  -0.0312   -0.6277;  -0.0312    0.6277;...
                0.0312   0.6277;   0.0889   -0.5321;  -0.0889   -0.5321;...
                -0.0889  0.5321;   0.0889    0.5321;   0.1330    0.3556;...
                -0.1330  0.3556;   0.1330   -0.3556;  -0.1330   -0.3556;...
                0.1569  -0.1249;  -0.1569   -0.1249;   0.1569    0.1249;...
                -0.1569  0.1249;   0.0157   -0.6369;  -0.0157   -0.6369;...
                0.0157   0.6369;  -0.0157    0.6369;  -0.0464   -0.6124;...
                0.0464  -0.6124;   0.0464    0.6124;  -0.0464    0.6124;...
                0.0754  -0.5644;   -0.0754   -0.5644;  0.0754    0.5644;...
                -0.0754  0.5644;   -0.1015   -0.4947;  0.1015   -0.4947;...
                0.1015   0.4947;   -0.1015    0.4947;  -0.1074   0.4742;...
                0.1074   0.4742;    0.1074   -0.4742;  -0.1074  -0.4742;...
                -0.0684  0.5786;   -0.0823    0.5489;   0.0684   0.5786;...
                0.0823   0.5489;   -0.0684   -0.5786;  -0.0823  -0.5489;...
                0.0684  -0.5786;    0.0823   -0.5489;  -0.0389  0.6208; ...
                -0.0539  0.6026;    0.0389    0.6208;  0.0539    0.6026;...
                0.0389  -0.6208;    0.0539   -0.6026; -0.0389   -0.6208;...
                -0.0539  -0.6026; -0.0079   0.6392;  - 0.0235    0.6331;...
                0.0235   0.6331;   0.0079   0.6392;   -0.0079   -0.6392;...
                -0.0235  -0.6331;  0.0079  -0.6392;    0.0235   -0.6331;...
                -0.1592  0.0627;  -0.1531   0.1858;    0.1592    0.0627;...
                0.1531   0.1858;  -0.1531  -0.1858;   -0.1592   -0.0627;...
                0.1531  -0.1858;   0.1592  -0.0627;   -0.1237   -0.4060;...
                -0.1411  -0.3017;  0.1237  -0.4060;    0.1411   -0.3017;...
                -0.1237  0.4060;  -0.1411   0.3017;    0.1237    0.4060;...
                0.1411    0.3017];
            
            [approxMat approxVec discrVec vertMat]= ...
                calcellipsoidapprox(semiaxesVec,[],[],4,{'approxPrec',...
                1e-5,'freeMemoryMode',0,'faceDist',.9e-8,'relPrec',1.e-8});
            mlunitext.assert(self.check(approxMat,expApproxMat,vertMat,...
                expVertMat,approxVec,expApproxVec,discrVec,expDiscrVec));
            
            %with Pareto shell
            semiaxesVec=[1 0.4];
            expApproxMat =[-0.8720 0.4895; -0.8224 0.5690; 0.8720 0.4895;...
                0.8224 0.5690; -0.9556 0.2947;-0.9174 0.3980;...
                0.9556 0.2947;  0.9174 0.3980;-0.9834 0.1814;...
                -0.9981 0.0613;  0.9834 0.1814; 0.9981 0.0613;...
                -0.0196 0.9998; -0.0592 0.9982; 0.0592 0.9982;...
                0.0196 0.9998;  0.1417 0.9899; 0.0997 0.9950;...
                -0.1417 0.9899; -0.0997 0.9950; 0.2331 0.9724;...
                0.1859 0.9826; -0.2331 0.9724;-0.1859 0.9826;...
                0.3408 0.9401;  0.2844 0.9587;-0.3408 0.9401;...
                -0.2844 0.9587;  0.4747 0.8801; 0.4038 0.9149;...
                -0.4747 0.8801; -0.4038 0.9149; 0.6458 0.7635;...
                0.5551 0.8318; -0.6458 0.7635;-0.5551 0.8318;...
                0.7453 0.6667; -0.7453 0.6667; 1.0000 0;...
                -1.0000  0] ;
            
            expApproxVec = zeros(40,1);
            
            expDiscrVec = zeros(1,40);
            
            
            expVertMat =  [ 1.0000 0; -1.0000 0;0 0.4000;
                0.7071    0.2828;   -0.7071   0.2828;   -0.9239  0.1531;...
                0.9239    0.1531;   -0.3827   0.3696;    0.3827  0.3696;...
                0.9808    0.0780;   -0.9808   0.0780;    0.8315  0.2222;...
                -0.8315   0.2222;   0.5556   0.3326;   -0.5556  0.3326;...
                0.1951    0.3923;   -0.1951   0.3923;   -0.9952  0.0392;...
                0.9952    0.0392;   -0.9569   0.1161;    0.9569  0.1161;...
                -0.8819   0.1886;   0.8819   0.1886;   -0.7730  0.2538;...
                0.7730    0.2538;   -0.6344   0.3092;    0.6344  0.3092;...
                -0.4714   0.3528;   0.4714   0.3528;   -0.2903  0.3828;...
                0.2903    0.3828;    0.0980   0.3981;   -0.0980  0.3981;...
                0.9988    0.0196;   -0.9988   0.0196;    0.9892  0.0587;...
                -0.9892   0.0587;   0.9700   0.0972;   -0.9700  0.0972;...
                -0.9638   0.1067;   0.9638   0.1067;   -0.9853  0.0684;...
                0.9853    0.0684;   -0.9973   0.0294;    0.9973  0.0294;...
                -0.0491   0.3995;  -0.1467   0.3957;    0.1467  0.3957;...
                0.0491    0.3995;    0.3369   0.3766;    0.2430  0.3880;...
                -0.3369   0.3766;  -0.2430   0.3880;    0.5141  0.3431;...
                0.4276    0.3616;   -0.5141   0.3431;   -0.4276  0.3616;...
                0.6716    0.2964;    0.5957   0.3213;   -0.6716  0.2964;...
                -0.5957   0.3213;   0.8032   0.2383;    0.7410  0.2686;...
                -0.8032   0.2383;  -0.7410   0.2686;    0.9040  0.1710;...
                0.8577    0.2056;   -0.9040   0.1710;   -0.8577  0.2056;...
                0.9415    0.1348;   -0.9415   0.1348];
            
            [approxMat approxVec discrVec vertMat]=...
                calcellipsoidapprox(semiaxesVec,[1 2],[1 -1],5,...
                {'discardIneqMode',0,'faceDist',1e-9,...
                'inApproxDist',1e-6,'ApproxDist',1e-7,'inftyDef',1e7});
            mlunitext.assert(self.check(approxMat,expApproxMat,vertMat,...
                expVertMat,approxVec,expApproxVec,discrVec,expDiscrVec));
            
            % the same ellipsoid, but another properties (not accurate
            % enough)
            
            semiaxesVec=[1 0.4];
            expApproxMat=[-0.5992 0.8006; -0.4381 0.8989; 0.5992 0.8006;...
                0.4381 0.8989; -0.7968  0.6043; -0.9710  0.2391;...
                0.7968 0.6043;  0.9710  0.2391;  0.0793  0.9968;...
                0.2582 0.9661; -0.2582  0.9661; -0.0793  0.9968;...
                1.0000 0;   -1.0000 0];
            
            expApproxVec=[-0.6761; -0.5641; -0.6761; -0.5641; -0.8286;
                -0.9710; -0.8286; -0.9710; -0.3987; -0.4558;
                -0.4558; -0.3987; -1.0000; -1.0000];
            expDiscrVec=[0.0099 0.0027 0.0099 0.0027 0.0040 0.0094 0.0040...
                0.0094 0.0078 0.0089 0.0089 0.0078 0 0];
            expVertMat=[1.0000 0;
                -1.0000   0;      0    0.4000;    0.7071    0.2828;...
                -0.7071   0.2828;-0.9239  0.1531;  0.9239    0.1531;...
                -0.3827   0.3696; 0.3827  0.3696;  0.9808    0.0780;...
                -0.9808   0.0780; 0.8315  0.2222; -0.8315    0.2222];
            
            [approxMat approxVec discrVec vertMat]=...
                calcellipsoidapprox(semiaxesVec,[1 2],[1 -1],3,...
                {'precTest',1e-2,'ApproxDist',1e-2,'faceDist',1e-3});
            
            mlunitext.assert(self.check(approxMat,expApproxMat,vertMat,...
                expVertMat,approxVec,expApproxVec,discrVec,expDiscrVec));
            
            %bad propeties value
            semiaxesVec=[1 1];
            [convexMat convexVec discrVec vertMat]=...
                calcellipsoidapprox(semiaxesVec,[],[],2,{'ApproxDist',1,...
                'inApproxDist',1});
            mlunitext.assert((0==numel(convexMat))&&(0==numel(convexVec))...
                &&(0 == numel(discrVec))&&(0 == numel(vertMat)));
            
            % not good acuracy in calculating dot product
            semiaxesVec=[1 4];
            expApproxMat=[ -0.8561 0.5167; -0.9947 0.1030; 0.9947 0.1030;...
                0.8561  0.5167; -0.8561 -0.5167; -0.9947 -0.1030;...
                0.8561 -0.5167;  0.9947 -0.1030];
            
            expApproxVec=[-2.0669; -0.9947; -0.9947; -2.0669; -2.0669;...
                -0.9947; -2.0669; -0.9947];
            expDiscrVec=zeros(1,8);
            expVertMat=[1.0000 0; -1.0000  0; 0  4.0000;...
                0  -4.0000;  0.7071   -2.8284; -0.7071   -2.8284;...
                0.7071  2.8284;   -0.7071    2.8284];
            
            
            [approxMat approxVec discrVec vertMat]=...
                calcellipsoidapprox(semiaxesVec,[],[],1,{'relPrec',1e-1});
            
            mlunitext.assert(self.check(approxMat,expApproxMat,vertMat,...
                expVertMat,approxVec,expApproxVec,discrVec,expDiscrVec));
            
            
            %wrong input
            self.runAndCheckError...
                ('elltool.multobj.calcellipsoidapprox([1 3 5;1 5 2],[],[],0)',...
                'wrongSize');
            self.runAndCheckError...
                ('elltool.multobj.calcellipsoidapprox([1 -1 0],[],[1 4 9],0)',...
                'wrongSizes');
            properties={'relPrec','1e-6'};   %#ok<NASGU>
            self.runAndCheckError...
                ('elltool.multobj.calcellipsoidapprox([1 1 1],[],[],1,properties)',...
                'wrongParamsType');
        end
    end
    methods (Static)
        function isOk=check(data1Mat,exp1Mat,data2Mat,exp2Mat,data1Vec,...
                exp1Vec,data2Vec,exp2Vec)
            PREC=1.e-4;
            isOk=all(all(abs(data1Mat - exp1Mat)<PREC))...
                &&all(abs(data1Vec - exp1Vec)<PREC)...
                &&all(abs(data2Vec - exp2Vec)<PREC)...
                &&all(all(abs(data2Mat - exp2Mat)<PREC));
        end
    end
    
end