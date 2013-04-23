classdef TestSuiteStaticProp < mlunitext.test_case
    properties 
    end
    
    methods
        function self = TestSuiteStaticProp(varargin)
            self = self@mlunitext.test_case(varargin{:});
        end
        
        function self = set_up_param(self,varargin)
             modgen.common.obj.test.StaticPropStorage.flush();
             modgen.common.obj.test.StaticPropStorage2.flush();
        end
 
        function self=test_separation(self)
            modgen.common.obj.test.StaticPropStorage.setProp('alpha',1);
            modgen.common.obj.test.StaticPropStorage.setProp('beta',11);
            modgen.common.obj.test.StaticPropStorage2.setProp('alpha',2);
            modgen.common.obj.test.StaticPropStorage2.setProp('beta',22);
            mlunit.assert_equals(1,...
                modgen.common.obj.test.StaticPropStorage.getProp('alpha'));
            %
            mlunit.assert_equals(2,...
                modgen.common.obj.test.StaticPropStorage2.getProp('alpha'));
            mlunit.assert_equals(11,...
                modgen.common.obj.test.StaticPropStorage.getProp('beta'));
            %
            mlunit.assert_equals(22,...
                modgen.common.obj.test.StaticPropStorage2.getProp('beta'));
        end
        function self=test_checkPresence(self)
            modgen.common.obj.test.StaticPropStorage.setProp('alpha',1);
            modgen.common.obj.test.StaticPropStorage2.setProp('beta',11);        
            %
            [resVal,isThere]=modgen.common.obj.test.StaticPropStorage2.getProp('beta',true);
            mlunit.assert_equals(true,isThere);
            mlunit.assert_equals(11,resVal);
            %
            [resVal,isThere]=modgen.common.obj.test.StaticPropStorage2.getProp('beta2',true);
            mlunit.assert_equals(true,isempty(resVal));
            mlunit.assert_equals(false,isThere);
            %
            [resVal,isThere]=modgen.common.obj.test.StaticPropStorage.getProp('alpha',true);
            mlunit.assert_equals(true,isThere);
            mlunit.assert_equals(1,resVal);
            %
            [resVal,isThere]=modgen.common.obj.test.StaticPropStorage.getProp('alpha2',true);
            mlunit.assert_equals(false,isThere);
            mlunit.assert_equals(true,isempty(resVal));
            %
            try 
               [~,~]=modgen.common.obj.test.StaticPropStorage.getProp('alpha2');
            catch meObj
                self.aux_checkNoPropException(meObj);
            end
            try 
               [~,~]=modgen.common.obj.test.StaticPropStorage.getProp('alpha2',false);
            catch meObj
                self.aux_checkNoPropException(meObj);
            end
            
        end
        function aux_checkNoPropException(~,meObj)
            mlunit.assert_equals(true,~isempty(findstr(':noProp',meObj.identifier)));
        end
               
    end
end