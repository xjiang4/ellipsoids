EllProj = gras.ellapx.smartdb.test.examples.getProj();
%
% get the list of field descriptions
%
Descr = EllProj.getFieldDescrList();
%
% get for given field a nested logical/cell array containing is-null 
% indicators for cell content. For example, for approxSchemaName field.
%
IsNull = EllProj.getFieldIsNull('approxSchemaName');
%
% get for given field logical vector determining whether value of this 
% field in each cell is null or not. For example, for approxSchemaName field.
%
ValueIsNull = EllProj.getFieldIsValueNull('approxSchemaName');
%
% get the list of field names
%
Name = EllProj.getFieldNameList();
%
% project object with specified fields. For example, with fields that are
% not to be cut or concatenated.
%
nameList = EllProj.getNoCatOrCutFieldsList();
Proj = EllProj.getFieldProjection(nameList);
%
% get the list of field types
%
Type = EllProj.getFieldTypeList();
%
% get the list of field type specifications. Field type specification is a 
% sequence of type names corresponding to field value types starting with 
% the top level and going down into the nested content of a field (for a 
% field having a complex type).
%
TypeSpec = EllProj.getFieldTypeSpecList();
% or
TypeSpec = EllProj.getFieldTypeSpecList(nameList);
%
% get a matrix composed from the size vectorsfor the specified fields
%
ValueSizeMat = EllProj.getFieldValueSizeMat(nameList);
%
% get a vector indicating whether a particular field is composed of null 
% values completely
%
ValueNull = EllProj.getIsFieldValueNull(nameList);
%
% get a size vector for the specified dimensions. If no dimensions are 
% specified, a size vector for all dimensions up to minimum dimension is 
% returned
MinDimensionSize = EllProj.getMinDimensionSize();
%
% get a minimum dimensionality for a given object
%
MinDimensionality = EllProj.getMinDimensionality();
%
% get a number of elements in a given object
%
NElems = EllProj.getNElems();
%
% get a number of fields in a given object
%
NFiedls = EllProj.getNFields();
%
% get a number of tuples in a given object
%
NTuples = EllProj.getNTuples();
%
% get sort index for all tuples of given relation with respect to some of 
% its fields
%
SortIndex = EllProj.getSortIndex(nameList);
% also we can specify the direction of sorting ('asc' or 'desc')
SortIndex = EllProj.getSortIndex(nameList,'Direction','asc');
%
% get tuples with given indices from given relation
%
Tuples = EllProj.getTuples(1);
%
% get tuples from given relation such that afixed index field contains 
% values from a given set of value
%
FilteredTuples = EllProj.getTuplesFilteredBy('sTime', 1);
%
% get internal representation for a set of unique tuples for given relation
%
UniqueData = EllProj.getUniqueData();
%
% get a relation containing the unique tuples from the original relation
%
UniqueTuples = EllProj.getUniqueTuples();
