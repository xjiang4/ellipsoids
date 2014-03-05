EllUnion = gras.ellapx.smartdb.test.examples.getUnion();
%
% get the list of field descriptions
%
Descr = EllUnion.getFieldDescrList();
%
% get for given field a nested logical/cell array containing is-null 
% indicators for cell content. For example, for approxSchemaName field.
%
IsNull = EllUnion.getFieldIsNull('approxSchemaName');
%
% get for given field logical vector determining whether value of this 
% field in each cell is null or not. For example, for approxSchemaName field.
%
ValueIsNull = EllUnion.getFieldIsValueNull('approxSchemaName');
%
% get the list of field names
%
Name = EllUnion.getFieldNameList();
%
% project object with specified fields. For example, with fields that are
% not to be cut or concatenated.
%
nameList = EllUnion.getNoCatOrCutFieldsList();
Proj = EllUnion.getFieldProjection(nameList);
%
% get the list of field types
%
Type = EllUnion.getFieldTypeList();
%
% get the list of field type specifications. Field type specification is a 
% sequence of type names corresponding to field value types starting with 
% the top level and going down into the nested content of a field (for a 
% field having a complex type).
%
TypeSpec = EllUnion.getFieldTypeSpecList();
% or
TypeSpec = EllUnion.getFieldTypeSpecList(nameList);
%
% get a matrix composed from the size vectorsfor the specified fields
%
ValueSizeMat = EllUnion.getFieldValueSizeMat(nameList);
%
% get a vector indicating whether a particular field is composed of null 
% values completely
%
ValueNull = EllUnion.getIsFieldValueNull(nameList);
%
% get a size vector for the specified dimensions. If no dimensions are 
% specified, a size vector for all dimensions up to minimum dimension is 
% returned
MinDimensionSize = EllUnion.getMinDimensionSize();
%
% get a minimum dimensionality for a given object
%
MinDimensionality = EllUnion.getMinDimensionality();
%
% get a number of elements in a given object
%
NElems = EllUnion.getNElems();
%
% get a number of fields in a given object
%
NFiedls = EllUnion.getNFields();
%
% get a number of tuples in a given object
%
NTuples = EllUnion.getNTuples();
%
% get sort index for all tuples of given relation with respect to some of 
% its fields
%
SortIndex = EllUnion.getSortIndex(nameList);
% also we can specify the direction of sorting ('asc' or 'desc')
SortIndex = EllUnion.getSortIndex(nameList,'Direction','asc');
%
% get tuples with given indices from given relation
%
Tuples = EllUnion.getTuples([1,2,3]);
%
% get tuples from given relation such that afixed index field contains 
% values from a given set of value
%
FilteredTuples = EllUnion.getTuplesFilteredBy('sTime', 1);
%
% get internal representation for a set of unique tuples for given relation
%
UniqueData = EllUnion.getUniqueData();
%
% get a relation containing the unique tuples from the original relation
%
UniqueTuples = EllUnion.getUniqueTuples();
