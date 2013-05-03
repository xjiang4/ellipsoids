classdef mlunit_test_disp < mlunit.test_case
    
    properties
        locDir
    end
    
    methods (Access=protected,Static)
        function isNullVec=getIsNullDefault(valueVec,isRandom)
            if nargin<2,
                isRandom=false;
            end
            if isRandom,
                valRange=[0 1];
            else
                valRange=[0 0];
            end
            if iscell(valueVec)&&~iscellstr(valueVec),
                isNullVec=cellfun(@(x)reshape(...
                    logical(randi(valRange,numel(x),1)),size(x)),...
                    valueVec,'UniformOutput',false);
            else
                isNullVec=reshape(logical(randi(...
                    valRange,numel(valueVec),1)),size(valueVec));
            end
        end
    end
    
    methods
        function self = mlunit_test_disp(varargin)
            self = self@mlunit.test_case(varargin{:});
            metaClass=metaclass(self);
            self.locDir=fileparts(which(metaClass.Name));
        end
        
        function self = set_up(self)
            close all;
        end
        %
        function self = tear_down(self)
            close all;
        end
        %
        function self = test_plotts(self)
            SRes=load([self.locDir,filesep,'vaMetricTSObj']);
            relObj=SRes.vaMetricTSObj;
            relObj.addFields(...
                {'plot_spec1','plot_spec2',...
                'metric_value_ts2','color1','color2',...
                'marker_size1','marker_size2',...
                'line_width1','line_width2'});
            %
            relObj.metric_value_ts2=relObj.metric_value_ts;
            relObj.applySetFunc('metric_value_ts2',@(x)(x*1.5));
            nTuples=relObj.getNTuples();
            relObj.plot_spec1=repmat({'+'},nTuples,1);
            relObj.plot_spec2=repmat({'x'},nTuples,1);
            %
            relObj.color1=repmat({[1 0 0]},nTuples,1);
            relObj.color2=repmat({[0 1 0]},nTuples,1);
            relObj.marker_size1=repmat(10,nTuples,1);
            relObj.marker_size2=repmat(2,nTuples,1);
            relObj.line_width1=ones(nTuples,1);
            relObj.line_width2=repmat(2,nTuples,1);
            smartdb.disp.plotts(relObj,'xfieldname', {'time_stamp_ts','time_stamp_ts'},...
                'yfieldname',{'metric_value_ts','metric_value_ts2'},...
                'figuregroupby','inst_id', 'figurenameby','inst_name',...
                'axesgroupby','vametric_configured_id','axesnameby',...
                'vametric_configured_name', 'graphnameby',...
                {'vametric_configured_name','vametric_configured_name'},...
                'dryrun',true,'plotSpecBy',{'plot_spec1','plot_spec2'},...
                'colorBy',{'color1','color2'},...
                'lineWidthBy',{'line_width1','line_width2'},...
                'markerSizeBy',{'marker_size1','marker_size2'});
        end
        function test_RelDataPlotter(self)
            self.aux_testRelDataPlotter(@deal);
        end
        function test_RelDataPlotterLongAxisNames(self)
            self.aux_testRelDataPlotter(@(x)[repmat(x,1,2),'  ',...
                repmat(x,1,48)]);
        end
        %
        function test_RelDataPlotterAutoHoldOn(self)
            
            plObj=process([]);
            check('add');
            %
            plObj=process([],'isAutoHoldOn',false);
            check('replace');
            plObj=process([],'isAutoHoldOn',true);
            check('add');
            %
            function check(expStatus)
                [~,hAxesList]=modgen.struct.getleavelist(...
                    plObj.getPlotStructure.figToAxesToHMap.toStruct);
                %
                isOk=all(cellfun(@(x)strcmp(get(x,'nextplot'),expStatus),...
                    hAxesList));
                mlunitext.assert(isOk);
            end
            function plOutObj=process(plObj,varargin)
                if isempty(plObj)
                    plOutObj=smartdb.disp.RelationDataPlotter(...
                        'nMaxAxesRows',1,'nMaxAxesCols',3,...
                        'figureGroupKeySuffFunc',@(x)sprintf('_gr%d',x));
                else
                    plOutObj=plObj;
                end
                %
                [~,~,~,...
                    ~,plotSimple,~]=self.auxPrepare(...
                    plOutObj,@deal,varargin{:});
                %
                plotSimple();
            end
        end
        %
        function test_RelDataPlotterCustomGetHandleFunc(self)
            
            plObj=process();
            %
            process(...
                'figureGetNewHandleFunc',@figureGetNewHandleFunc,...
                'axesGetNewHandleFunc',@axesGetNewHandleFunc);
            %
            function plOutObj=process(varargin)
                plOutObj=smartdb.disp.RelationDataPlotter(...
                    'nMaxAxesRows',1,'nMaxAxesCols',3,...
                    'figureGroupKeySuffFunc',@(x)sprintf('_gr%d',x),...
                    varargin{:});
                %
                [~,~,~,...
                    ~,plotSimple,~]=self.auxPrepare(...
                    plOutObj,@deal);
                %
                plotSimple();
            end
            function hFigure=figureGetNewHandleFunc(...
                    figureGroupKey,figureGroupKeySuff,varargin)
                figureKey=[figureGroupKey,figureGroupKeySuff];
                hFigure=plObj.getPlotStructure.figHMap(figureKey);
            end
            function hAxes=axesGetNewHandleFunc(axesKey,~,~,~,~,figureKey)
                axesToHMap=plObj.getPlotStructure.figToAxesToHMap(figureKey);
                hAxes=axesToHMap(axesKey);
            end
        end
        
        function plObj=aux_testRelDataPlotter(self,modifyAxesName,varargin)
            plObj=smartdb.disp.RelationDataPlotter(...
                'nMaxAxesRows',1,'nMaxAxesCols',3,...
                'figureGroupKeySuffFunc',@(x)sprintf('_gr%d',x),varargin{:});
            %
            [simpleMasterCheck,checkPlots,checkDisplayedPlots,...
                ~,plotSimple,~]=self.auxPrepare(...
                plObj,modifyAxesName);
            simpleMasterCheck(true);
            simpleMasterCheck(false);
            %%
            plotSimple();
            checkPlots({'figure11_gr1','figure22_gr1',...
                'figure22_gr2'});
            %
            checkDisplayedPlots(...
                struct('figure11_gr1',...
                struct('axes11surf','axes1','axes22surf','axes2'),...
                'figure22_gr1',...
                struct('axes22surf','axes2','axes33surf','axes3',...
                'axes44surf','axes4'),...
                'figure22_gr2',struct('axes55surf','axes5')));
            %
            plObj=smartdb.disp.RelationDataPlotter(...
                'nMaxAxesRows',2,'nMaxAxesCols',1,...
                'figureGroupKeySuffFunc',@(x)sprintf('_gr%d',x));
            %
            [~,~,~,...
                checkCertainCase,~,plotSimple2,checkForEmptyMaps]=self.auxPrepare(...
                plObj,modifyAxesName,varargin{:});
            checkCertainCase();
            %
            plotSimple2();
            plObj.closeAllFigures();
            checkForEmptyMaps();
            plObj.closeAllFigures();
            checkForEmptyMaps();
        end
        function [fSimpleMasterCheck,fCheckPlots,fCheckDisplayedPlots,...
                fCheckCertainCase,fPlotSimple,fPlotSimple2,...
                fCheckForEmptyMaps]=auxPrepare(~,...
                plObj,modifyAxesName,varargin)
            %
            fSimpleMasterCheck=@simpleMasterCheck;
            fCheckPlots=@checkPlots;
            fCheckDisplayedPlots=@checkDisplayedPlots;
            fCheckCertainCase=@checkCertainCase;
            fPlotSimple=@plotSimple;
            fPlotSimple2=@plotSimple2;
            fCheckForEmptyMaps=@checkForEmptyMaps;
            %
            resDir=modgen.test.TmpDataManager.getDirByCallerKey();
            %
            SData.zMat=cellfun(@(x)ones(10,10)*x,num2cell(1:10).',...
                'UniformOutput',false);
            SData.tVec=cellfun(@(x)(1+x*0.05):(20*x),num2cell(1:10).',...
                'UniformOutput',false);
            SData.z2Mat=SData.zMat;
            SData.color=repmat({[0 1 0];[0 0 1];[1 0 1];[1 1 0];[0 0 0]},2,1);
            SData.figureName=[repmat({'figure1'},4,1);repmat({'figure2'},6,1)];
            SData.figureNum=[ones(4,1);2*ones(6,1)];
            SData.entryNum=transpose(1:10);
            %
            SData.axesName=[repmat({'axes1'},2,1);repmat({'axes2'},3,1);...
                repmat({'axes3'},2,1);repmat({'axes4'},1,1);...
                repmat({'axes5'},2,1)];
            SData.axesNum=[ones(2,1);repmat(2,3,1);repmat(3,2,1);...
                repmat(4,1,1);repmat(5,2,1)];
            %
            rel=smartdb.relations.DynamicRelation(SData);
            %
            %% plot to different axes types
            fGetGroup21Key=@(x)sprintf('figure_2_%d',x);
            fGetGroup22Key=@(x)sprintf('figure_2_2_%d',x);
            fGetGroup1Key=@(x)sprintf('figure_%d',x);
            fGetGroup2Key=@(x)sprintf('figure2_%d',x);
            fAxesSetProp=@axesSetPropDoNothingFunc;
            %%
            function plotSimple()
                plObj.plotGeneric(rel,@figureGetGroupNameFunc,...
                    {'figureName','figureNum'},@figureSetPropFunc,...
                    {},@axesGetNameSurfFunc,...
                    {'axesName','axesNum'},...
                    @axesSetPropFunc,{'axesNum','axesName'},...
                    @plotCreateSurfFunc,...
                    {'color','zMat','tVec'},varargin{:});
            end
            function plotSimple2()
                plObj.plotGeneric(rel,@(varargin)'figure',...
                    {},@figureSetPropFunc,...
                    {},{@(varargin)'surf',@(varargin)'plot3'},...
                    {},...
                    @axesSetPropDoNothingFunc,{'axesNum','axesName'},...
                    {@plotCreateSurfFunc,@plotCreatePlot3Func},...
                    {'color','zMat','tVec'},varargin{:});
            end
            function simpleMasterCheck(isSetAxesPost)
                fAxesSetProp=@axesSetPropDoNothingFunc;
                plotSomeTestGraps({fGetGroup1Key,fGetGroup1Key,fGetGroup2Key},isSetAxesPost);
                plotSomeTestGraps({fGetGroup1Key,fGetGroup1Key,fGetGroup2Key},isSetAxesPost);
                plotSomeTestGraps({fGetGroup21Key,fGetGroup21Key,fGetGroup22Key},isSetAxesPost);
                %
                nCurFigures=plObj.getPlotStructure.figHMap.Count;
                mlunit.assert_equals(40,nCurFigures);
                %
                plObj.closeAllFigures();
            end
            function plotSomeTestGraps(arg,isSetAxesProp)
                if isSetAxesProp
                    addArgList={'axesPostPlotFunc',...
                        @(varargin)axesPostPlotFunc(varargin{:})};
                else
                    addArgList={};
                end
                %
                plObj.plotGeneric(rel,...
                    arg,...
                    {'entryNum'},...
                    {@figureSetPropFunc,@figureSetPropFunc,@figureSetPropFunc},...
                    {},{@(varargin)'surf',@(varargin)'plot3',@(varargin)'surf2'},...
                    {'axesName','axesNum'},...
                    {fAxesSetProp,fAxesSetProp,fAxesSetProp},...
                    {'axesNum','axesName'},...
                    {@plotCreateSurfFunc,@plotCreatePlot3Func,@plotCreateSurf2Func},...
                    {'color','zMat','tVec','z2Mat'},...
                    addArgList{:},varargin{:});
                
                if isSetAxesProp
                    [~,isOkVec]=modgen.struct.getleavelist(...
                        modgen.struct.updateleaves(...
                        plObj.getPlotStructure().figToAxesToHMap.toStruct(),...
                        @(x,y)strcmp(y{end},get(x,'UserData'))));
                    mlunit.assert_equals(true,all([isOkVec{:}]));
                end
                function hVec=axesPostPlotFunc(hAxes,axesKey,varargin)
                    hVec=[];
                    set(hAxes,'UserData',axesKey)
                end
                
            end
            function checkCertainCase()
                plObj.plotGeneric(rel,@(x)sprintf('figure_%d',x),...
                    {'entryNum'},@figureSetPropFunc,...
                    {},{@(varargin)modifyAxesName('surf'),...
                    @(varargin)modifyAxesName('plot3')},...
                    {'axesName','axesNum'},...
                    @axesSetPropDoNothingFunc,{'axesNum','axesName'},...
                    {@plotCreateSurfFunc,@plotCreatePlot3Func},...
                    {'color','zMat','tVec'},varargin{:});
                %
                SExp=xmlparse(...
                    ['<root xml_tb_version="2.0" type="struct" >',...
                    '<figure_10_gr1 type="struct" >',...
                    '    <plot3 type="char" >axes5</plot3>',...
                    '    <surf type="char" >axes5</surf>',...
                    '</figure_10_gr1>',...
                    '<figure_1_gr1 type="struct" >',...
                    '    <plot3 type="char" >axes1</plot3>',...
                    '    <surf type="char" >axes1</surf>',...
                    '</figure_1_gr1>',...
                    '<figure_2_gr1 type="struct" >',...
                    '    <plot3 type="char" >axes1</plot3>',...
                    '    <surf type="char" >axes1</surf>',...
                    '</figure_2_gr1>',...
                    '<figure_3_gr1 type="struct" >',...
                    '    <plot3 type="char" >axes2</plot3>',...
                    '    <surf type="char" >axes2</surf>',...
                    '</figure_3_gr1>',...
                    '<figure_4_gr1 type="struct" >',...
                    '    <plot3 type="char" >axes2</plot3>',...
                    '    <surf type="char" >axes2</surf>',...
                    '</figure_4_gr1>',...
                    '<figure_5_gr1 type="struct" >',...
                    '    <plot3 type="char" >axes2</plot3>',...
                    '    <surf type="char" >axes2</surf>',...
                    '</figure_5_gr1>',...
                    '<figure_6_gr1 type="struct" >',...
                    '    <plot3 type="char" >axes3</plot3>',...
                    '    <surf type="char" >axes3</surf>',...
                    '</figure_6_gr1>',...
                    '<figure_7_gr1 type="struct" >',...
                    '   <plot3 type="char" >axes3</plot3>',...
                    '   <surf type="char" >axes3</surf>',...
                    '</figure_7_gr1>',...
                    '<figure_8_gr1 type="struct" >',...
                    '    <plot3 type="char" >axes4</plot3>',...
                    '    <surf type="char" >axes4</surf>',...
                    '</figure_8_gr1>',...
                    '<figure_9_gr1 type="struct" >',...
                    '    <plot3 type="char" >axes5</plot3>',...
                    '    <surf type="char" >axes5</surf>',...
                    '</figure_9_gr1>',...
                    '</root> ']);
                checkDisplayedPlots(SExp);
                checkPlots(cellfun(@(x)sprintf('figure_%d_gr1',x),...
                    num2cell(SData.entryNum).','UniformOutput',false));
            end
            function checkForEmptyMaps()
                SPlot=plObj.getPlotStructure();
                mlunit.assert_equals(0,SPlot.figHMap.Count);
                mlunit.assert_equals(0,SPlot.figToAxesToHMap.Count);
                mlunit.assert_equals(0,SPlot.figToAxesToPlotHMap.Count);
            end
            function checkDisplayedPlots(SExp)
                import modgen.struct.updateleavesext;
                import modgen.struct.updateleaves;
                inpExpFileNameList=fieldnames(SExp);
                nFigures=length(inpExpFileNameList);
                SPlot=plObj.getPlotStructure();
                %
                isOk=all(ismember(inpExpFileNameList,...
                    SPlot.figHMap.keys))&&...
                    SPlot.figHMap.Count==nFigures;
                mlunit.assert_equals(true,isOk);
                %
                SAxisNames=updateleaves(...
                    SPlot.figToAxesToHMap.toStruct(),...
                    @(x,y)get(get(x,'Title'),'String'));
                SExp=updateleavesext(SExp,@fTransform);
                [isOk,reportStr]=modgen.struct.structcompare(...
                    SAxisNames,SExp);
                mlunit.assert_equals(true,isOk,reportStr);
                function [val,path]=fTransform(val,path)
                    import modgen.containers.MapExtended;
                    modField=modifyAxesName(path{4});
                    val=[modField,'_',val];
                    path{4}=MapExtended.key2FieldName(modField);
                end
            end
            function checkPlots(inpExpFileNameList)
                INP_FORMAT_LIST={{'png'},{'fig'},{}};
                EXT_LIST={'png','fig','fig'};
                FORMAT_LIST={'png','fig'};
                nInputs=length(INP_FORMAT_LIST);
                nFormats=length(FORMAT_LIST);
                for iFormat=1:nInputs
                    inpArgList=INP_FORMAT_LIST{iFormat};
                    fileExtName=EXT_LIST{iFormat};
                    plObj.saveAllFigures(resDir,inpArgList{:});
                    check(fileExtName);
                    delete([resDir,filesep,'*.',fileExtName]);
                end
                %
                plObj.saveAllFigures(resDir,FORMAT_LIST);
                for iFormat=1:nFormats
                    formatName=FORMAT_LIST{iFormat};
                    check(formatName);
                end
                delete([resDir,filesep,'*']);
                %
                function check(formatName)
                    expFileNameList=strcat(inpExpFileNameList,'.',...
                        formatName);
                    SFiles=dir([resDir,filesep,'*.',formatName]);
                    fileNameList=sort({SFiles.name});
                    expFileNameList=sort(expFileNameList);
                    mlunit.assert_equals(true,isequal(fileNameList,expFileNameList));
                    delete([resDir,filesep,'*.',formatName]);
                end
            end
            function axesName=axesGetNameSurfFunc(axesName,axesNum)
                axesName=modifyAxesName([axesName,num2str(axesNum),'surf']);
            end
            function figureGroupName=figureGetGroupNameFunc(figureName,figureNum)
                figureGroupName=[figureName,num2str(figureNum)];
            end
            function hVec=plotCreateSurfFunc(hAxes,color,zMat,varargin)
                patchName=sprintf('surface_%d',fix(mean(zMat(:))));
                h0=surface(zMat,'FaceColor','interp',...
                    'EdgeColor','none','DisplayName',patchName,...
                    'CData',repmat(shiftdim(color,-1),size(zMat)),...
                    'Parent',hAxes);
                h1=camlight('left');
                set(h1,'Parent',hAxes);
                hVec=[h0,h1];
            end
            function hVec=plotCreateSurf2Func(hAxes,color,~,~,z2Mat,varargin)
                patchName=sprintf('surface2_%d',fix(mean(z2Mat(:))));
                h0=surface(z2Mat,'FaceColor','none',...
                    'EdgeColor','interp','DisplayName',patchName,...
                    'CData',repmat(shiftdim(color,-1),size(z2Mat)),...
                    'Parent',hAxes);
                h1=camlight('left');
                set(h1,'Parent',hAxes);
                hVec=[h0,h1];
            end
            function hVec=plotCreatePlot3Func(hAxes,color,~,tVec,varargin)
                plotName=sprintf('plot3_%d',fix(mean(tVec)));
                hVec=plot3(tVec,sin(tVec),cos(tVec),...
                    'DisplayName',plotName,'Parent',hAxes',...
                    'Color',color);
                xlabel(hAxes,'sin(t)');
                ylabel(hAxes,'cos(t)');
                zlabel(hAxes,'t');
                grid(hAxes,'on');
                hold(hAxes,'on');
            end
            function hVec=axesSetPropDoNothingFunc(hAxes,basicAxesName,~,axesName)
                axis(hAxes,'auto');
                view(hAxes,3);
                title(hAxes,[basicAxesName,'_',axesName]);
                set(hAxes,'xtickmode','auto',...
                    'ytickmode','auto',...
                    'ztickmode','auto','xgrid','on','ygrid','on','zgrid','on');
                hVec=[];
            end
            function hVec=axesSetPropFunc(hAxes,basicAxesName,axesNum,axesName)
                axis(hAxes,'auto');
                %title(hAxes,basicAxesName);
                yLabel=sprintf('y_%d',axesNum);
                zLabel=sprintf('z_%d',axesNum);
                xLabel=sprintf('x_%d',axesNum);
                %
                set(hAxes,'XLabel',...
                    text('String',xLabel,'Interpreter',...
                    'tex','Parent',hAxes));
                set(hAxes,'YLabel',...
                    text('String',yLabel,'Interpreter',...
                    'tex','Parent',hAxes));
                set(hAxes,'ZLabel',...
                    text('String',zLabel,'Interpreter',...
                    'none','Parent',hAxes));
                set(hAxes,'Title',...
                    text('String',[basicAxesName,'_',axesName],...
                    'Interpreter',...
                    'tex','Parent',hAxes));
                view(hAxes,3);
                set(hAxes,'xtickmode','auto',...
                    'ytickmode','auto',...
                    'ztickmode','auto','xgrid',...
                    'on','ygrid','on','zgrid','on');
                %
                h1=camlight('head');
                set(h1,'Parent',hAxes);
                h2=camlight('head');
                set(h2,'Parent',hAxes);
                hVec=[h1,h2];
            end
            %
            function figureSetPropFunc(hFigure,figureName,indFigureGroup)
                set(hFigure,'NumberTitle','off','WindowStyle','docked',...
                    'RendererMode','manual','Renderer','OpenGL',...
                    'Name',figureName);
                mlunit.assert_equals(indFigureGroup,...
                    str2double(modgen.string.splitpart(...
                    figureName,'_gr',2)));
            end
        end
    end
end