classdef AEllipsoid < handle
    properties (Access = protected, Abstract) 
        shapeMat
    end
    properties (Access = protected)
        centerVec
        absTol
        relTol
        nPlot2dPoints
        nPlot3dPoints
    end
    
    %methods (Access = protected, Abstract, Static)
    methods (Access = protected, Abstract, Static)
        %SComp = formCompStruct(SEll, SFieldNiceNames, absTol, isPropIncluded)     
    end   
    
    methods (Abstract, Static)
        ellArr = fromRepMat(varargin)
        ellArr = fromStruct(SEllArr)
        polEllArr = polar(ellArr)
    end
    
    methods (Abstract)
        getCopy(ellArr)
        checkIsMe(ellArr, varargin)   
        
    end
    methods (Abstract, Access = protected)
        checkDoesContainArgs(fstEllArr,secObjArr)
    end
    
    methods (Static, Access = protected)
        regQMat = regularize(qMat,absTol)
        
        function SComp = formCompStruct(SEll, SFieldNiceNames, absTol, isPropIncluded)
            if (~isempty(SEll.shapeMat))
                SComp.(SFieldNiceNames.shapeMat) = gras.la.sqrtmpos(SEll.shapeMat, absTol);
            else
                SComp.(SFieldNiceNames.shapeMat) = [];
            end
            SComp.(SFieldNiceNames.centerVec) = SEll.centerVec;
            if (isPropIncluded)
                SComp.(SFieldNiceNames.absTol) = SEll.absTol;
                SComp.(SFieldNiceNames.relTol) = SEll.relTol;
                SComp.(SFieldNiceNames.nPlot2dPoints) = SEll.nPlot2dPoints;
                SComp.(SFieldNiceNames.nPlot3dPoints) = SEll.nPlot3dPoints;
            end
        end
    end
        
    methods
        function resArr=repMat(self,varargin)
            % REPMAT - is analogous to built-in repmat function with one exception - it
            %          copies the objects, not just the handles
            %
            % Example:
            %   firstEllObj = ellipsoid([1; 2], eye(2));
            %   secEllObj = ellipsoid([1; 1], 2*eye(2));
            %   ellVec = [firstEllObj secEllObj];
            %   repMat(ellVec)
            %
            %   ans =
            %   1x2 array of ellipsoids.
            %
            %
            % $Author: Peter Gagarinov <pgagarinov@gmail.com> $   $Date: 24-04-2013$
            % $Copyright: Moscow State University,
            %             Faculty of Computational Mathematics and Cybernetics,
            %             Science, System Analysis Department 2012-2013 $
            %
            %
            sizeVec=horzcat(varargin{:});
            resArr=repmat(self,sizeVec);
            resArr=resArr.getCopy();
        end
        %
        function shMat=getShapeMat(self)
            % GETSHAPEMAT - returns shapeMat matrix of given ellipsoid
            %
            % Input:
            %   regular:
            %      self: ellipsoid[1,1]
            %
            % Output:
            %   shMat: double[nDims,nDims] - shapeMat matrix of ellipsoid
            %
            % Example:
            %   ellObj = ellipsoid([1; 2], eye(2));
            %   getShapeMat(ellObj)
            %
            %   ans =
            %
            %        1     0
            %        0     1
            %
            % $Author: Peter Gagarinov <pgagarinov@gmail.com> $   $Date: 24-04-2013$
            % $Copyright: Moscow State University,
            %             Faculty of Computational Mathematics and Cybernetics,
            %             Science, System Analysis Department 2012-2013 $
            self.checkIfScalar();
            shMat=self.shapeMat;
        end
        %
        function centerVecVec=getCenterVec(self)
            % GETCENTERVEC - returns centerVec vector of given ellipsoid
            %
            % Input:
            %   regular:
            %      self: ellipsoid[1,1]
            %
            % Output:
            %   centerVecVec: double[nDims,1] - centerVec of ellipsoid
            %
            % Example:
            %   ellObj = ellipsoid([1; 2], eye(2));
            %   getCenterVec(ellObj)
            %
            %   ans =
            %
            %        1
            %        2
            %
            % $Author: Peter Gagarinov <pgagarinov@gmail.com> $   $Date: 24-04-2013$
            % $Copyright: Moscow State University,
            %             Faculty of Computational Mathematics and Cybernetics,
            %             Science, System Analysis Department 2012-2013 $
            self.checkIfScalar();
            centerVecVec=self.centerVec;
        end
        
        function checkIfScalar(self,errMsg)
            if nargin<2
                errMsg='input argument must be single ellipsoid.';
            end
            modgen.common.checkvar(self,'isscalar(x)',...
                'errorMessage',errMsg);
        end
    end
    methods (Access = protected)
       function isArrEq = isMatEqualInternal(self,aArr,bArr)
            % ISMATEQUALINTERNAL - returns isArrEq - logical 1(true) if
            %           multidimensional arrays aArr and bArr are equal,
            %           and logical 0(false) otherwise, comparing them
            %           using absTol and relTol fields of the object self
            %
            % Input:
            %   regular:
            %      self: ellipsoid[1,1]
            %      aArr: double[nDim1,nDim2,...,nDimk]
            %      bArr: double[nDim1,nDim2,...,nDimk]
            %
            % Output:
            %   isArrEq: logical[1,1]
            %
            %
            %
            % $Author: Victor Gribov <illuminati1606@gmail.com> $   $Date: 28-05-2013$
            % $Copyright: Moscow State University,
            %             Faculty of Computational Mathematics and Cybernetics,
            %             Science, System Analysis Department 2012-2013 $
            self.checkIfScalar();
            absTol = self.absTol;
            if any(abs(aArr(:))>absTol) || any(abs(bArr(:))>absTol)
                isArrEq = abs(2*(aArr-bArr)./(aArr+bArr));
                isArrEq = all(isArrEq(:)<=self.relTol);
            else
                isArrEq = true;
            end
        end
        %doesContain = doesContainPoly(ellArr,polytope,varagin)
        %[propMat, propVal] = getProperty(hplaneMat,propName, fPropFun)
    end
    methods (Access = protected)
        function [isEqualArr, reportStr] = isEqualInternal(ellFirstArr,...
                ellSecArr, isPropIncluded)
            import modgen.struct.structcomparevec;
            import gras.la.sqrtmpos;
            import elltool.conf.Properties;
            import modgen.common.throwerror;
            %
            nFirstElems = numel(ellFirstArr);
            nSecElems = numel(ellSecArr);
            if (nFirstElems == 0 && nSecElems == 0)
                isEqualArr = true;
                reportStr = '';
                return;
            elseif (nFirstElems == 0 || nSecElems == 0)
                throwerror('wrongInput:emptyArray',...
                    'input ellipsoidal arrays should be empty at the same time');
            end
            
            [~, absTol] = ellFirstArr.getAbsTol;
            firstSizeVec = size(ellFirstArr);
            secSizeVec = size(ellSecArr);
            isnFirstScalar=nFirstElems > 1;
            isnSecScalar=nSecElems > 1;
            
            [~, tolerance] = ellFirstArr.getRelTol;
            
            [SEll1Array, SFieldNiceNames, ~] = ...
                ellFirstArr.toStruct(isPropIncluded);
            SEll2Array = ellSecArr.toStruct(isPropIncluded);
            %
            SEll1Array = arrayfun(@(SEll)ellFirstArr.formCompStruct(SEll,...
                SFieldNiceNames, absTol, isPropIncluded), SEll1Array);
            SEll2Array = arrayfun(@(SEll)ellSecArr.formCompStruct(SEll,...
                SFieldNiceNames, absTol, isPropIncluded), SEll2Array);
            
            if isnFirstScalar&&isnSecScalar
                if ~isequal(firstSizeVec, secSizeVec)
                    throwerror('wrongSizes',...
                        'sizes of ellipsoidal arrays do not... match');
                end;
                compare();
                isEqualArr = reshape(isEqualArr, firstSizeVec);
            elseif isnFirstScalar
                SEll2Array=repmat(SEll2Array, firstSizeVec);
                compare();
                
                isEqualArr = reshape(isEqualArr, firstSizeVec);
            else
                SEll1Array=repmat(SEll1Array, secSizeVec);
                compare();
                isEqualArr = reshape(isEqualArr, secSizeVec);
            end
            function compare()
                [isEqualArr, reportStr] =...
                    modgen.struct.structcomparevec(SEll1Array,...
                    SEll2Array, tolerance);
            end
        end        
    end   
end