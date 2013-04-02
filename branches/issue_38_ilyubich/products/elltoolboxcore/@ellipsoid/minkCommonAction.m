function varargout = minkCommonAction(getEllArr,fCalcBodyTriArr,fCalcCenterTriArr,varargin)
import elltool.plot.plotgeombodyarr;
if (nargout == 1)||(nargout == 0)
    charColor = 'empty';
    cellfun(@(x)findColorChar(x),varargin);
    [reg,~,isShowAll]=...
        modgen.common.parseparext(varargin,...
        {'showAll' ;...
        false;
        @(x)isa(x,'logical')});
    
    if ~strcmp(charColor,'empty')
        reg = {reg{1},charColor,reg{2:end}};
    end
    [plObj,nDim,isHold]= plotgeombodyarr('ellipsoid',fCalcBodyTriArr,@patch,reg{:});
    if (nDim < 3)
        [reg]=...
            modgen.common.parseparext(reg,...
            {'relDataPlotter';...
            [],;@(x)isa(x,'smartdb.disp.RelationDataPlotter'),...
            });
        plObj= plotgeombodyarr('ellipsoid',fCalcCenterTriArr,...
            @(varargin)patch(varargin{:},'marker','*'),reg{:},'relDataPlotter',plObj, 'priorHold',true,'postHold',isHold);
    end
    if isShowAll
        [reg]=...
            modgen.common.parseparext(reg,...
            {'relDataPlotter','newFigure','fill','lineWidth','color','shade','priorHold','postHold'});
        ellArr = cellfun(@(x)getEllArr(x),reg,'UniformOutput', false);
        ellArr = vertcat(ellArr{:});
        plObj = ellArr.plot('color', [0 0 0],'relDataPlotter',plObj,'priorHold',true);
    end
    if nargout == 1
        varargout = {{plObj,isHold}};
    end
else
    [reg]=...
        modgen.common.parseparext(varargin,...
        {'relDataPlotter','newFigure','fill','lineWidth','color','shade','priorHold','postHold';...
        [],0,[],[],[],0,false,false;@(x)isa(x,'smartdb.disp.RelationDataPlotter'),...
        @(x)isa(x,'logical'),@(x)isa(x,'logical'),@(x)isa(x,'double'),...
        @(x)isa(x,'double'),...
        @(x)isa(x,'double'), @(x)isa(x,'logical'),@(x)isa(x,'logical')});
    ellsCMat = cellfun(@(x)getEllArr(x),reg,'UniformOutput', false);
    ellsArr = vertcat(ellsCMat{:});
    ellsArrDims = dimension(ellsArr);
    mDim    = min(ellsArrDims);
    nDim    = max(ellsArrDims);
    if mDim ~= nDim
        throwerror('dimMismatch', ...
            'Objects must have the same dimensions.');
    end
    
    xSumCMat = fCalcBodyTriArr(ellsArr);
    qSumCMat = fCalcCenterTriArr(ellsArr);
    varargout(1) = qSumCMat;
    varargout(2) = xSumCMat;
end
    function findColorChar(value)
        if ischar(value)&&isColorDef(value)
            charColor = value;
        end
        function isColor = isColorDef(value)
            isColor = strcmp(value, 'r') || strcmp(value, 'g') || strcmp(value, 'b') || ...
                strcmp(value, 'y') || strcmp(value, 'c') || ...
                strcmp(value, 'm') || strcmp(value, 'w');
        end
    end
end