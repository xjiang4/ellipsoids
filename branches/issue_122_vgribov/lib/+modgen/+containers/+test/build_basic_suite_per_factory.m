function suite=build_basic_suite_per_factory(mapFactory,formatList)
import modgen.containers.*;
import modgen.containers.test.*;
%
loader = mlunitext.test_loader;
nFormats=length(formatList);
for iFormat=1:nFormats
    suite_diskbasedhashmapList{iFormat} = loader.load_tests_from_test_case(...
        'modgen.containers.test.mlunit_test_diskbasedhashmap',mapFactory,...
        'storageFormat',formatList{iFormat},...
        'useHashedKeys',true,'marker',...
        [formatList{iFormat},'_useHashedKeysTrue']);
end
suite_diskbasedhashmap_none = loader.load_tests_from_test_case(...
    'modgen.containers.test.mlunit_test_diskbasedhashmap_nostorage',...
    mapFactory,'useHashedKeys',true,'marker','useHashKeysTrue');
%
for iFormat=1:nFormats
    suite_diskbasedhashmap_nohashkeysList{iFormat} = loader.load_tests_from_test_case(...
        'modgen.containers.test.mlunit_test_diskbasedhashmap',mapFactory,...
        'storageFormat',formatList{iFormat},...
        'useHashedKeys',false,'marker',...
        [formatList{iFormat},'_useHashedKeysFalse']);
end
suite_diskbasedhashmap_none_nohashkeys = loader.load_tests_from_test_case(...
    'modgen.containers.test.mlunit_test_diskbasedhashmap_nostorage',...
    mapFactory,'useHashedKeys',false,'marker','useHashKeysFalse');
%
suite_mlunit_test_ahashmap_basic=loader.load_tests_from_test_case(...
    'modgen.containers.test.ondisk.mlunit_test_ahashmap_basic',mapFactory);
%
testList=horzcat(...
    suite_diskbasedhashmap_none.tests,...
    suite_diskbasedhashmap_none_nohashkeys.tests,...
    suite_mlunit_test_ahashmap_basic.tests);
%
for iFormat=1:nFormats
    testList=horzcat(testList,...
        suite_diskbasedhashmapList{iFormat}.tests,...
        suite_diskbasedhashmap_nohashkeysList{iFormat}.tests);
end
%    
suite = mlunitext.test_suite(testList);
