classdef ArrayTestPropForSuite<mlunitext.test_case
    properties
      simpleTypeNoCharList={{'int8'},{'int16'},{'int32'},{'int64'},{'double'},...
                {'logical'},{'single'},...
                {'uint8'},{'uint16'},{'uint32'},{'uint64'},{'struct'},...
                {'modgen.common.type.test.TestValueType'},...
                {'modgen.common.type.test.TestHandleType'}};
      complexTypeList={...
                {'cell','int8'},{'cell','int16'},{'cell','int32'},...
                {'cell','int64'},{'cell','double'},...
                {'cell','logical'},{'cell','single'},...
                {'cell','uint8'},{'cell','uint16'},{'cell','uint32'},...
                {'cell','uint64'},{'cell','char'},...
                {'cell','cell','int64'},{'cell','cell','double'},...
                {'cell','cell','logical'},{'cell','cell','single'},...
                {'cell','cell','uint8'},{'cell','cell','uint16'},...
                {'cell','cell','uint32'},...
                {'cell','cell','uint64'},{'cell','cell','char'},...
                {'cell','struct'},{'cell','cell','struct'},...
                {'cell','modgen.common.type.test.TestValueType'},...
                {'cell','cell','modgen.common.type.test.TestValueType'},...
                {'cell','modgen.common.type.test.TestHandleType'},...
                {'cell','cell','modgen.common.type.test.TestHandleType'}};
      typeListNoChar
      typeList
      simpleTypeList
      sizeCVec={[10,1],[0 1],[10,2,3],[0,2,3]};
    end
    methods
        function self = ArrayTestPropForSuite(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end        
        function self = set_up_param(self,varargin)
            self.typeListNoChar=[self.simpleTypeNoCharList,self.complexTypeList];
            self.simpleTypeList=[self.simpleTypeNoCharList,{{'char'}}];
            self.typeList=[self.typeListNoChar,{{'char'}}];
        end
    end
end