classdef HyperplaneDispStructTC < elltool.core.test.mlunit.ADispStructTC
    %
    %$Author: Alexander Karev <Alexander.Karev.30@gmail.com> $
    %$Date: 2013-06$
    %$Copyright: Moscow State University,
    %            Faculty of Computational Mathematics
    %            and Computer Science,
    %            System Analysis Department 2013 $
    methods (Access = protected, Static)
        
        function objArrCVec = getToStructObj()
            objArrCVec = {hyperplane([1, 1, 2]', 3),...
                hyperplane(),...
                hyperplane([1, 1, 2]', 3),...
                hyperplane([1, 1, 2]', 3),...
                hyperplane([1, 1, 2]', 2),...
                hyperplane.fromRepMat(1, 1, [5 5 5]),...
                hyperplane.fromRepMat(1, 1, [5 5 5])};
            objArrCVec{7}(1) = hyperplane();
        end
        
        function SArrCVec = getToStructStruct()
            SArrCVec = {struct('normal', [1, 1, 2]', 'shift', 3),...
                struct('normal', [], 'shift', []),...
                struct('normal', [], 'shift', []),...
                struct('normal', [1, 1, 2]', 'shift',...
                3, 'absTol', 1e-7, 'relTol', 1e-5),...
                struct('normal', [1, 1, 2]', 'shift', ...
                3, 'absTol', 1e-7),...
                struct('normal', num2cell(ones(5, 5, 5)), ...
                'shift', num2cell(ones(5, 5, 5))),...
                struct('normal', num2cell(ones(5, 5, 5)), ...
                'shift', num2cell(ones(5, 5, 5)))};
            SArrCVec{1} = normalize(SArrCVec{1});
            SArrCVec{4} = normalize(SArrCVec{4});
            SArrCVec{5} = normalize(SArrCVec{5});
            
            function SHpNormalized = normalize(SHp)
                SHpNormalized = SHp;
                SHpNormalized.shift = ...
                    SHpNormalized.shift/norm(SHpNormalized.normal);
                SHpNormalized.normal =...
                    SHpNormalized.normal/norm(SHpNormalized.normal);
            end
        end
        
        function isPropsCVec = getToStructIsPropIncluded()
            isPropsCVec = {false, false, false, true,...
                false, false, false};
        end
        
        function isResultCVec = getToStructResult()
            isResultCVec = {true, true, false, true, false, true, false};
        end
        
        function testNumber = getToStructTestNumber()
            testNumber = 7;
        end
        
        function objArrCVec = getFromStructObj()
            objArrCVec = {hyperplane([1, 2]', 3),...
                hyperplane([1, 2]', 3),...
                hyperplane(),...
                hyperplane([1, 2]', 3),...
                hyperplane.fromRepMat(1, 1, [5 5 5]),...
                hyperplane.fromRepMat(1, 1, [5 5 5])};
            objArrCVec{6}(1) = hyperplane();
        end
        
        function SArrCVec = getFromStructStruct()
            SArrCVec = {struct('normal', [1, 2]', 'shift', 3),...
                struct('normal', [1, 2]', 'shift', 3),...
                struct('normal', [1, 2]', 'shift', 3,...
                'absTol', 1e-5),...
                struct('normal', [1, 2]', 'shift', 3,...
                'absTol', 1e-5),...
                struct('normal', num2cell(ones(5, 5, 5)), ...
                'shift', num2cell(ones(5, 5, 5))),...
                struct('normal', num2cell(ones(5, 5, 5)), ...
                'shift', num2cell(ones(5, 5, 5)))};
        end
        
        function isResultCVec = getFromStructResult()
            isResultCVec = {true, true, false, false, true, false};
        end
        
        function testNumber = getFromStructTestNumber()
            testNumber = 6;
        end
        
        function objArrCVec = getDisplayObj()
            objArrCVec = {hyperplane([1, 2]', 3),...
                hyperplane(),...
                hyperplane([1, 1]', 3),...
                hyperplane.fromStruct(struct('normal',...
                num2cell(ones(5, 5, 5)), ...
                'shift', num2cell(ones(5, 5, 5)))),...
                hyperplane([1, 2]', 3),...
                ellipsoid()};
            objArrCVec{5} = [objArrCVec{5} objArrCVec{5}];
        end
        
        function stringsCVec = getDisplayStrings()
            stringsCVec = {'hyperplane object', ...
                'Properties',...
                'shift',...
                'normal',...
                'Hyperplane shift'};
            stringsCVec = repmat({stringsCVec}, 1, 6);
            stringsCVec{5} = horzcat(stringsCVec{5}, 'ObjArr(1)');
        end
        
        function isResultCVec = getDisplayResult()
            isResultCVec = {true, true, true, true, true, false};
        end
        
        function testNumber = getDisplayTestNumber()
            testNumber = 6;
        end
        
        function objArrCVec = getEqFstObj()
            objArrCVec = {hyperplane([1, 2]', 3),...
                hyperplane(),...
                hyperplane([1, 1]', 3),...
                hyperplane([1, 2]', 3),...
                hyperplane([1, 2]', 3),...
                hyperplane.fromStruct(struct('normal',...
                num2cell(ones(5, 5, 5)), ...
                'shift', num2cell(ones(5, 5, 5)))),...
                hyperplane.fromStruct(struct('normal',...
                num2cell(ones(5, 5, 5)), ...
                'shift', num2cell(ones(5, 5, 5)))),...
                hyperplane([1, 2]', 3)};
            objArrCVec{8} = [objArrCVec{8} objArrCVec{8}];
        end
        
        function objArrCVec = getEqSndObj()
            objArrCVec = {hyperplane([1, 2]', 3),...
                hyperplane(),...
                hyperplane([1, 1]', 3),...
                hyperplane([1, 1]', 3),...
                hyperplane(),...
                hyperplane.fromStruct(struct('normal',...
                num2cell(ones(5, 5, 5)), ...
                'shift', num2cell(ones(5, 5, 5)))),...
                hyperplane.fromStruct(struct('normal',...
                num2cell(ones(5, 5, 5)), ...
                'shift', num2cell(ones(5, 5, 5)))),...
                hyperplane([1, 2]', 3)};
            objArrCVec{7}(1) = hyperplane();
            objArrCVec{8} = [objArrCVec{8} objArrCVec{8}];
        end
        
        function isResultCVec = getEqResult()
            isResultCVec = {true, true, true, false, false, true, false, true};
        end
        
        function testNumber = getEqTestNumber()
            testNumber = 8;
        end
    end
    
    methods (Access = public)
        function self = HyperplaneDispStructTC(varargin)
            self = self@elltool.core.test.mlunit.ADispStructTC(varargin{:});
        end
    end
end