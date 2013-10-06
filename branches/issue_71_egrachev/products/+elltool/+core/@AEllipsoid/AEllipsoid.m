classdef AEllipsoid < handle
    properties (Access = protected, Abstract) 
        shapeMat
    end
    
    %methods (Access = protected, Abstract, Static)
    methods (Access = protected, Static)
        formCompStruct(SEll, SFieldNiceNames, absTol, isPropIncluded)
    end   
    
    methods (Abstract)
        getCopy(ellArr)
        checkIsMe(~, ellArr, varargin)        
        isEmpty(myEllArr)
    end
    methods (Abstract, Access = protected)
        checkDoesContainArgs(fstEllArr,secObjArr)
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
    end
    methods (Access = private)
        %doesContain = doesContainPoly(ellArr,polytope,varagin)
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